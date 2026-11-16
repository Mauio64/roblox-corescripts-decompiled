local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local roact = dependencies.Roact
local roactRodux = dependencies.RoactRodux
require(parent.Common.LocalTypes)
local Constants = require(parent.Common.Constants)
local promise = dependencies.Promise
local Analytics = require(parent.Analytics)
local FieldNames = Analytics.FieldNames
local EventNames = Analytics.EventNames
local setupFireAnalyticsEvents = require(parent.Analytics.setupFireAnalyticsEvents)

local formatContacts = require(parent.Utils.formatContacts)
local contactsProtocol = dependencies.ContactsProtocol
local dash = dependencies.Dash

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local ampApiProvider = dependencies.AmpUpsell.AmpApiProvider
local accessResponseEnum = dependencies.AmpUpsell.AmpEnums.AccessResponseEnum
local getFFlagFindFriendsClickedEventEnabled = require(parent.Flags.getFFlagFindFriendsClickedEventEnabled)
local ContactsList = require(script.Parent.ContactsList)
local ContactsListMapDispatchToProps = require(script.Parent.ContactsListMapDispatchToProps)
local ContactsListMapStateToProps = require(script.Parent.ContactsListMapStateToProps)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local UploadContactsSources = require(parent.Analytics.Enums.UploadContactsSources)
local getFIntContactImporterUploadContactsMin = require(parent.Flags.getFIntContactImporterUploadContactsMin)

local discoverabilityAnalytics = dependencies.DiscoverabilityAnalytics

local extended = roact.PureComponent:extend("ContactsListContainer")

extended.defaultProps = { contactsProtocol = contactsProtocol.default }

function extended:init()
	self.entryPoint = self.props.navigation.getParam("entryPoint")

	self.fireAnalyticsEvent = setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = { entry = self.entryPoint }
	})

	self.state = { hasUploadError = false, isFetching = true, showMatchedContacts = false }

	function self.getPropOrParam(p)
		if self.props.navigation and self.props.navigation.getParam(p) or self.props.navigation then
			return self.props.navigation.getParam(p)
		end

		return getDeepValue(self.props, p)
	end

	self.contactsCount = nil

	self.numTotalNumbersOnDevice = nil
	self.numTotalContactsOnDevice = nil
	self.numContactsWithMultipleNumbers = nil
	self.startTime = os.clock()
	local ampApiProvider2

	if self.props.ampApiProvider == nil then
		ampApiProvider2 = ampApiProvider
	else
		ampApiProvider2 = self.props.ampApiProvider
	end

	self.ampApiProvider = ampApiProvider2

	local function makeErrorFunction(failedStep: string) -- 5 equivalent calls inferred from this helper
		return function(p)
			if type(p) == "table" and p.hasAlreadyErrored then
				return promise.reject({ hasAlreadyErrored = true })
			end

			self:setState({ hasUploadError = true, isFetching = false })

			self.fireAnalyticsEvent(failedStep, { failedStep = failedStep })

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = failedStep
			})

			return promise.reject({ hasAlreadyErrored = true })
		end
	end

	function self.requestFriendship(p)
		local props = self.props

		self.fireAnalyticsEvent(EventNames.RequestFriendship, { requestedId = p })

		props.requestFriendship({ currentUserId = props.localUserId, contactId = p }):andThen(function()
			props.requestSent(p)
		end)
	end

	function self.fireContactImportingTimeEvent(p)
		self.fireAnalyticsEvent(EventNames.ContactImportingTime, {
			[FieldNames.NumTotalContactsImported] = self.contactsCount,
			[FieldNames.NumMatchedContacts] = p.numMatchedContacts,
			[FieldNames.NumTotalContactsOnDevice] = self.numTotalContactsOnDevice,
			[FieldNames.NumMaxContacts] = true,
			[FieldNames.NumMinContacts] = true,
			[FieldNames.NumTotalNumbersOnDevice] = self.numTotalNumbersOnDevice,
			[FieldNames.NumContactsWithMultipleNumbers] = self.numContactsWithMultipleNumbers,
			loadingTime = os.clock() - self.startTime,
			isSuccessfulUpload = p.isSuccessfulUpload
		})
	end

	function self.getContactsFromDevice()
		local props = self.props

		return props.contactsProtocol:supportsContacts():andThen(function(p)
			if p then
				return props.contactsProtocol:getContacts()
			end

			return promise.reject()
		end):catch(function()
			return promise.reject()
		end)
	end

	function self.formatContactsFromDevice(p)
		local props = self.props

		if #(p.contacts or {}) == 0 then
			return { contacts = {}, contactsCount = 0, countryCode = nil }
		end

		props.deviceContactsReceived(p.contacts)

		local v = formatContacts(p)

		self.contactsCount = #v.contacts
		self.numTotalContactsOnDevice = v.contactsCount
		local count = 0
		local total = 0

		for _, contact in ipairs(p.contacts) do
			local count2 = #contact.phonenumber

			if count2 > 1 then
				count += 1
			end

			total += count2
		end

		self.numTotalNumbersOnDevice = total
		self.numContactsWithMultipleNumbers = count

		return v
	end

	function self.uploadDeviceContacts(p)
		p.source = UploadContactsSources.CI
		local props = self.props

		if #p.contacts == 0 or #p.contacts < getFIntContactImporterUploadContactsMin() then
			return promise.resolve({ shouldFindContacts = false })
		end

		return props.uploadContacts(p):andThen(function()
			return promise.resolve({ shouldFindContacts = true })
		end, function()
			self.fireAnalyticsEvent(EventNames.FailedUploadContactsFromDevice, {
				failedStep = EventNames.FailedUploadContactsFromDevice
			})

			self.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = EventNames.FailedUploadContactsFromDevice
			})

			return promise.resolve({ shouldFindContacts = true })
		end)
	end

	function self.findContacts(p)
		local props = self.props

		if p.shouldFindContacts then
			return props.findContacts()
		end

		return promise.resolve()
	end

	function self.getContactEntities(p)
		local props = self.props

		if p then
			return props.getContactEntities(p)
		end

		return promise.resolve()
	end

	local function fn(options) -- 1 equivalent call inferred from this helper
		local deepValue = getDeepValue(options or {}, "responseBody.userContactsEntities")

		if deepValue then
			return #deepValue
		end

		return 0
	end

	function self.fireHasLoaded(options)
		local nummatchedContacts = fn(options) -- inferred equivalent call
		self.fireAnalyticsEvent(EventNames.ContactsListLoaded, {
			[FieldNames.NumTotalContactsImported] = self.contactsCount,
			[FieldNames.NumMatchedContacts] = nummatchedContacts,
			[FieldNames.NumMaxContacts] = true,
			[FieldNames.NumMinContacts] = true,
			[FieldNames.NumTotalContactsOnDevice] = self.numTotalContactsOnDevice
		})

		self:setState({ isFetching = false })

		self.fireContactImportingTimeEvent({
			isSuccessfulUpload = true,
			nummatchedContacts = nummatchedContacts
		})

		return promise.resolve()
	end

	function self.failedToUpload(_)
		self:setState({ hasUploadError = true, isFetching = false })

		self.fireContactImportingTimeEvent({ isSuccessfulUpload = false })
	end

	function self.getContacts()
		self:setState({ isFetching = true })

		local featureAccess = self.ampApiProvider.getFeatureAccess({ Constants.SHOW_MATCHED_CONTACTS })
		local v

		if #featureAccess.featureAccessList > 0 then
			v = featureAccess.featureAccessList[1].access
		else
			v = accessResponseEnum.Actionable
		end

		self:setState({
			showMatchedContacts = v == accessResponseEnum.Granted
		})

		self.getContactsFromDevice():andThen(
			self.formatContactsFromDevice,
			makeErrorFunction(EventNames.FailedGetContactsFromDevice) -- inferred equivalent call
		):andThen(
			self.uploadDeviceContacts,
			makeErrorFunction(EventNames.FailedFormatContactsFromDevice) -- inferred equivalent call
		):andThen(
			self.findContacts,
			makeErrorFunction(EventNames.FailedUploadContactsFromDevice) -- inferred equivalent call
		):andThen(
			self.getContactEntities,
			makeErrorFunction(EventNames.FailedFindContacts) -- inferred equivalent call
		):andThen(
			self.fireHasLoaded,
			makeErrorFunction(EventNames.FailedGetContactEntities) -- inferred equivalent call
		):catch(self.failedToUpload)
	end

	local function fn2() -- 1 equivalent call inferred from this helper
		if self.props.navigation then
			self.props.navigation.pop()
		elseif self.props.onClose then
			self.props.onClose()
		end
	end

	function self.closeModal(p)
		local state = self.state

		local fireAnalyticsEvent = self.fireAnalyticsEvent
		local v = { isLoading = self.state.isFetching, loadingTime = 0 }
		local loadingTime

		if state.isFetching then
			loadingTime = os.clock() - self.startTime
		end

		v.loadingTime = loadingTime
		fireAnalyticsEvent(p, v)
		fn2() -- inferred equivalent call
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
		local openAmpUpsell

		if propOrParam then
			openAmpUpsell = function()
				local function fn3(p, _)
					if p == accessResponseEnum.Granted then
						self.getContacts()
						self.openDiscoverabilityModal()
					end
				end

				if getFFlagFindFriendsClickedEventEnabled() then
					self.fireAnalyticsEvent(EventNames.FindFriendsButtonClicked)
				end

				propOrParam(Constants.SHOW_MATCHED_CONTACTS, fn3)
			end
		else
			openAmpUpsell = dash.noop
		end

		self.openAmpUpsell = openAmpUpsell
	end
end

function extended.didMount(p)
	p.getContacts()
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
