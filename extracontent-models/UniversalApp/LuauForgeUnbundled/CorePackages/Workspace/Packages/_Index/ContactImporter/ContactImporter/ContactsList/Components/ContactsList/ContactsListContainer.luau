local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local roactRodux = dependencies.RoactRodux
require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/LocalTypes")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local promise = dependencies.Promise
local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics")
local fieldNames = Analytics.FieldNames
local eventNames = Analytics.EventNames
local setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/setupFireAnalyticsEvents")

local formatContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/formatContacts")
local contactsProtocol = dependencies.ContactsProtocol
local dash = dependencies.Dash

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local ampApiProvider = dependencies.AmpUpsell.AmpApiProvider
local accessResponseEnum = dependencies.AmpUpsell.AmpEnums.AccessResponseEnum
local getFFlagFindFriendsClickedEventEnabled = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFFlagFindFriendsClickedEventEnabled")
local ContactsList = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/ContactsList")
local ContactsListMapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/ContactsListMapDispatchToProps")
local ContactsListMapStateToProps = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsList/ContactsListMapStateToProps")
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local UploadContactsSources = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/UploadContactsSources")
local getFIntContactImporterUploadContactsMin = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFIntContactImporterUploadContactsMin")

local discoverabilityAnalytics = dependencies.DiscoverabilityAnalytics

local extended = roact.PureComponent:extend("ContactsListContainer")

extended.defaultProps = { contactsProtocol = contactsProtocol.default }

function extended:init()
	self.entryPoint = self.props.navigation.getParam("entryPoint")

	self.fireAnalyticsEvent = setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = { entry = self.entryPoint }
	})

	self.state = {
		hasUploadError = false,
		isFetching = true,
		showMatchedContacts = false
	}

	function self.getPropOrParam(p2)
		if self.props.navigation and self.props.navigation.getParam(p2) or self.props.navigation then
			return self.props.navigation.getParam(p2)
		end

		return getDeepValue(self.props, p2)
	end

	self.contactsCount = nil

	self.numTotalNumbersOnDevice = nil
	self.numTotalContactsOnDevice = nil
	self.numContactsWithMultipleNumbers = nil
	self.startTime = os.clock()
	local v5 = if self.props.ampApiProvider == nil then ampApiProvider else self.props.ampApiProvider
	self.ampApiProvider = v5

	local function makeErrorFunction(p2)
		return function(p3)
			if type(p3) == "table" and p3.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(p2, { failedStep = p2 })

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = p2
			})

			return promise.reject({ hasAlreadyErrored = true })
		end
	end

	function self.requestFriendship(p2)
		local props = self.props

		self.fireAnalyticsEvent(eventNames.RequestFriendship, { requestedId = p2 })

		props.requestFriendship({ currentUserId = props.localUserId, contactId = p2 }):andThen(function()
			props.requestSent(p2)
		end)
	end

	function self.fireContactImportingTimeEvent(p2)
		self.fireAnalyticsEvent(eventNames.ContactImportingTime, {
			[fieldNames.NumTotalContactsImported] = self.contactsCount,
			[fieldNames.NumMatchedContacts] = p2.numMatchedContacts,
			[fieldNames.NumTotalContactsOnDevice] = self.numTotalContactsOnDevice,
			[fieldNames.NumMaxContacts] = true,
			[fieldNames.NumMinContacts] = true,
			[fieldNames.NumTotalNumbersOnDevice] = self.numTotalNumbersOnDevice,
			[fieldNames.NumContactsWithMultipleNumbers] = self.numContactsWithMultipleNumbers,
			loadingTime = os.clock() - self.startTime,
			isSuccessfulUpload = p2.isSuccessfulUpload
		})
	end

	function self.getContactsFromDevice()
		local props = self.props

		return props.contactsProtocol:supportsContacts():andThen(function(p2)
			if p2 then
				return props.contactsProtocol:getContacts()
			end

			return promise.reject()
		end):catch(function()
			return promise.reject()
		end)
	end

	function self.formatContactsFromDevice(p2)
		local props = self.props

		if #(p2.contacts or {}) == 0 then
			return { contacts = {}, contactsCount = 0, countryCode = nil }
		end

		props.deviceContactsReceived(p2.contacts)

		local v6 = formatContacts(p2)

		self.contactsCount = #v6.contacts
		self.numTotalContactsOnDevice = v6.contactsCount
		local count = 0
		local total = 0

		for i, contact in ipairs(p2.contacts) do
			local count2 = #contact.phonenumber

			if count2 > 1 then
				count += 1
			end

			total += count2
		end

		self.numTotalNumbersOnDevice = total
		self.numContactsWithMultipleNumbers = count

		return v6
	end

	function self.uploadDeviceContacts(p2)
		p2.source = UploadContactsSources.CI
		local props = self.props

		if #p2.contacts == 0 or #p2.contacts < getFIntContactImporterUploadContactsMin() then
			return promise.resolve({ shouldFindContacts = false })
		end

		return props.uploadContacts(p2):andThen(function()
			return promise.resolve({ shouldFindContacts = true })
		end, function()
			self.fireAnalyticsEvent(eventNames.FailedUploadContactsFromDevice, {
				failedStep = eventNames.FailedUploadContactsFromDevice
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = eventNames.FailedUploadContactsFromDevice
			})

			return promise.resolve({ shouldFindContacts = true })
		end)
	end

	function self.findContacts(p2)
		local props = self.props

		if p2.shouldFindContacts then
			return props.findContacts()
		end

		return promise.resolve()
	end

	function self.getContactEntities(p2)
		local props = self.props

		if p2 then
			return props.getContactEntities(p2)
		end

		return promise.resolve()
	end

	function self.fireHasLoaded(options)
		local deepValue = getDeepValue(options or {}, "responseBody.userContactsEntities")

		local v6 = deepValue and #deepValue or 0

		self.fireAnalyticsEvent(eventNames.ContactsListLoaded, {
			[fieldNames.NumTotalContactsImported] = self.contactsCount,
			[fieldNames.NumMatchedContacts] = v6,
			[fieldNames.NumMaxContacts] = true,
			[fieldNames.NumMinContacts] = true,
			[fieldNames.NumTotalContactsOnDevice] = self.numTotalContactsOnDevice
		})

		self:setState({ isFetching = false })

		self.fireContactImportingTimeEvent({
			isSuccessfulUpload = true,
			nummatchedContacts = v6
		})

		return promise.resolve()
	end

	function self.failedToUpload(p2)
		self:setState({ hasUploadError = true, isFetching = false })

		self.fireContactImportingTimeEvent({ isSuccessfulUpload = false })
	end

	function self.getContacts()
		self:setState({ isFetching = true })

		local featureAccess = self.ampApiProvider.getFeatureAccess({ Constants.SHOW_MATCHED_CONTACTS })
		self:setState({
			showMatchedContacts = (if #featureAccess.featureAccessList > 0 then featureAccess.featureAccessList[1].access else accessResponseEnum.Actionable) == accessResponseEnum.Granted
		})

		local contactsFromDevice = self.getContactsFromDevice()
		local formatContactsFromDevice = self.formatContactsFromDevice
		local failedGetContactsFromDevice = eventNames.FailedGetContactsFromDevice
		local v8 = contactsFromDevice:andThen(formatContactsFromDevice, function(p2)
			if type(p2) == "table" and p2.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedGetContactsFromDevice, {
				failedStep = failedGetContactsFromDevice
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedGetContactsFromDevice
			})

			return promise.reject({ hasAlreadyErrored = true })
		end)
		local uploadDeviceContacts = self.uploadDeviceContacts
		local failedFormatContactsFromDevice = eventNames.FailedFormatContactsFromDevice
		local v9 = v8:andThen(uploadDeviceContacts, function(p2)
			if type(p2) == "table" and p2.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedFormatContactsFromDevice, {
				failedStep = failedFormatContactsFromDevice
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedFormatContactsFromDevice
			})

			return promise.reject({ hasAlreadyErrored = true })
		end)
		local findContacts = self.findContacts
		local failedUploadContactsFromDevice = eventNames.FailedUploadContactsFromDevice
		local v10 = v9:andThen(findContacts, function(p2)
			if type(p2) == "table" and p2.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedUploadContactsFromDevice, {
				failedStep = failedUploadContactsFromDevice
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedUploadContactsFromDevice
			})

			return promise.reject({ hasAlreadyErrored = true })
		end)
		local getContactEntities = self.getContactEntities
		local failedFindContacts = eventNames.FailedFindContacts
		local v11 = v10:andThen(getContactEntities, function(p2)
			if type(p2) == "table" and p2.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedFindContacts, {
				failedStep = failedFindContacts
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedFindContacts
			})

			return promise.reject({ hasAlreadyErrored = true })
		end)
		local fireHasLoaded = self.fireHasLoaded
		local failedGetContactEntities = eventNames.FailedGetContactEntities
		v11:andThen(fireHasLoaded, function(p2)
			if type(p2) == "table" and p2.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedGetContactEntities, {
				failedStep = failedGetContactEntities
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedGetContactEntities
			})

			return promise.reject({ hasAlreadyErrored = true })
		end):catch(self.failedToUpload)
	end

	function self.closeModal(p2)
		local state = self.state

		local fireAnalyticsEvent = self.fireAnalyticsEvent
		local v6 = { isLoading = self.state.isFetching, loadingTime = 0 }
		local v7 = if state.isFetching then os.clock() - self.startTime else nil
		v6.loadingTime = v7
		fireAnalyticsEvent(p2, v6)

		if self.props.navigation then
			self.props.navigation.pop()
		elseif self.props.onClose then
			self.props.onClose()
		end
	end

	function self.onAddFriendsActivated()
		self.props.navigation.replace(enumScreens.AddFriendsPage)
	end

	self.isFetching = nil

	function self.openDiscoverabilityModal()
		local navigation = self.props.navigation

		navigation.replace(enumScreens.DiscoverabilityOverlay, {
			isStandaloneDiscoverabilityModal = true,
			entryPoint = discoverabilityAnalytics.EntryPoints.ContactsList,
			navigateOnActivated = function()
				navigation.replace(enumScreens.ContactsList, {
					[Constants.SHOULD_UPDATE_USER_SETTINGS] = true,
					[Constants.IS_PHONE_VERIFIED] = self.getPropOrParam(Constants.IS_PHONE_VERIFIED),
					openAmpUpsell = self.getPropOrParam(Constants.OPEN_AMP_UPSELL),
					entryPoint = self.entryPoint
				})
			end
		})

		local propOrParam = self.getPropOrParam(Constants.OPEN_AMP_UPSELL)
		local v6 = self
		local v7

		if propOrParam then
			v7 = function()
				local function fn(p2, p3)
					if p2 == accessResponseEnum.Granted then
						self.getContacts()
						self.openDiscoverabilityModal()
					end
				end

				if getFFlagFindFriendsClickedEventEnabled() then
					self.fireAnalyticsEvent(eventNames.FindFriendsButtonClicked)
				end

				propOrParam(Constants.SHOW_MATCHED_CONTACTS, fn)
			end
		else
			v7 = dash.noop
		end

		v6.openAmpUpsell = v7
	end
end

function extended.didMount(p2)
	p2.getContacts()
end

function extended.render(props)
	local props2 = props.props
	local entryPoint = props.entryPoint

	return roact.createElement(ContactsList, {
		deviceContacts = props2.deviceContacts,
		matchedContacts = props2.matchedContacts,
		isFetching = props.state.isFetching,
		requestFriendship = props.requestFriendship,
		screenSize = props2.screenSize,
		hasUploadError = props.state.hasUploadError,
		onAddFriendsActivated = props.onAddFriendsActivated,
		closeModal = props.closeModal,
		showAddFriendsButton = entryPoint == Analytics.EntryPoints.HomePage,
		openProfilePeekView = props.props.openProfilePeekView,
		showMatchedContacts = props.state.showMatchedContacts,
		openAmpUpsell = props.openAmpUpsell
	})
end

return roactRodux.connect(ContactsListMapStateToProps, ContactsListMapDispatchToProps)(extended)
