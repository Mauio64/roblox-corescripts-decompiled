local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux

require(ParentParent.Common.LocalTypes)

local Constants = require(ParentParent.Common.Constants)
local Promise = dependencies.Promise
local Analytics = require(ParentParent.Analytics)
local FieldNames = Analytics.FieldNames
local EventNames = Analytics.EventNames
local setupFireAnalyticsEvents = require(ParentParent.Analytics.setupFireAnalyticsEvents)
local formatContacts = require(ParentParent.Utils.formatContacts)
local ContactsProtocol = dependencies.ContactsProtocol
local Dash = dependencies.Dash
local EnumScreens = dependencies.SocialModalsCommon.EnumScreens
local AmpApiProvider = dependencies.AmpUpsell.AmpApiProvider
local AccessResponseEnum = dependencies.AmpUpsell.AmpEnums.AccessResponseEnum
local getFFlagFindFriendsClickedEventEnabled = require(ParentParent.Flags.getFFlagFindFriendsClickedEventEnabled)
local ContactsList = require(script.Parent.ContactsList)
local ContactsListMapDispatchToProps = require(script.Parent.ContactsListMapDispatchToProps)
local ContactsListMapStateToProps = require(script.Parent.ContactsListMapStateToProps)
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local UploadContactsSources = require(ParentParent.Analytics.Enums.UploadContactsSources)
local getFIntContactImporterUploadContactsMin = require(ParentParent.Flags.getFIntContactImporterUploadContactsMin)
local IXPVariants = require(ParentParent.Common.IXPVariants)
local FFlagContactImporterIXPCleanup = require(ParentParentParent.SharedFlags).FFlagContactImporterIXPCleanup
local DiscoverabilityAnalytics = dependencies.DiscoverabilityAnalytics
local v28 = Roact.PureComponent:extend("ContactsListContainer")

v28.defaultProps = {
	contactsProtocol = ContactsProtocol.default
}

function v28.init(p1) -- line: 74
	-- upvalues: setupFireAnalyticsEvents (copy), Analytics (copy), getDeepValue (copy), AmpApiProvider (copy), Promise (copy), EventNames (copy), FieldNames (copy), formatContacts (copy), UploadContactsSources (copy), FFlagContactImporterIXPCleanup (copy), IXPVariants (copy), getFIntContactImporterUploadContactsMin (copy), Constants (copy), AccessResponseEnum (copy), EnumScreens (copy), DiscoverabilityAnalytics (copy), getFFlagFindFriendsClickedEventEnabled (copy), Dash (copy)
	p1.entryPoint = p1.props.navigation.getParam("entryPoint")
	p1.fireAnalyticsEvent = setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = {
			entry = p1.entryPoint
		}
	})
	p1.state = {
		hasUploadError = false,
		isFetching = true,
		showMatchedContacts = false
	}

	function p1.getPropOrParam(p2) -- line: 91
		-- upvalues: p1 (copy), getDeepValue (copy)
		if p1.props.navigation and p1.props.navigation.getParam(p2) or p1.props.navigation then
			return p1.props.navigation.getParam(p2)
		end

		return getDeepValue(p1.props, p2)
	end

	p1.contactsCount = nil
	p1.numTotalNumbersOnDevice = nil
	p1.numTotalContactsOnDevice = nil
	p1.numContactsWithMultipleNumbers = nil
	p1.startTime = os.clock()
	p1.ampApiProvider = if p1.props.ampApiProvider == nil then AmpApiProvider else p1.props.ampApiProvider

	local function makeErrorFunction(s1: string) -- line: 107
		-- upvalues: Promise (copy), p1 (copy)
		return function(p3) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), s1 (copy)
			if type(p3) == "table" and p3.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(s1, {
				failedStep = s1
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = s1
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end
	end

	function p1.requestFriendship(p4) -- line: 145
		-- upvalues: p1 (copy), EventNames (copy)
		local props = p1.props

		p1.fireAnalyticsEvent(EventNames.RequestFriendship, {
			requestedId = p4
		})
		props.requestFriendship({
			currentUserId = props.localUserId,
			contactId = p4
		}):andThen(function() -- line: 157
			-- upvalues: props (copy), p4 (copy)
			props.requestSent(p4)
		end)
	end
	function p1.fireContactImportingTimeEvent(t1: {[any]: any}) -- line: 162
		-- upvalues: p1 (copy), EventNames (copy), FieldNames (copy)
		p1.fireAnalyticsEvent(EventNames.ContactImportingTime, {
			[FieldNames.NumTotalContactsImported] = p1.contactsCount,
			[FieldNames.NumMatchedContacts] = t1.numMatchedContacts,
			[FieldNames.NumTotalContactsOnDevice] = p1.numTotalContactsOnDevice,
			[FieldNames.NumMaxContacts] = true,
			[FieldNames.NumMinContacts] = true,
			[FieldNames.NumTotalNumbersOnDevice] = p1.numTotalNumbersOnDevice,
			[FieldNames.NumContactsWithMultipleNumbers] = p1.numContactsWithMultipleNumbers,
			loadingTime = os.clock() - p1.startTime,
			isSuccessfulUpload = t1.isSuccessfulUpload
		})
	end
	function p1.getContactsFromDevice() -- line: 180
		-- upvalues: p1 (copy), Promise (copy)
		local props = p1.props

		return props.contactsProtocol:supportsContacts():andThen(function(p5) -- line: 185
			-- upvalues: Promise (copy), props (copy)
			if not p5 then
				return Promise.reject()
			end

			return props.contactsProtocol:getContacts()
		end):catch(function() -- line: 192
			-- upvalues: Promise (copy)
			return Promise.reject()
		end)
	end
	function p1.formatContactsFromDevice(p6) -- line: 197
		-- upvalues: p1 (copy), formatContacts (copy)
		local props = p1.props

		if #(p6.contacts or {}) == 0 then
			return {
				contactsCount = 0,
				countryCode = nil,
				contacts = {}
			}
		end

		props.deviceContactsReceived(p6.contacts)

		local v46 = formatContacts(p6)

		p1.contactsCount = #v46.contacts
		p1.numTotalContactsOnDevice = v46.contactsCount

		local n1 = 0
		local n2 = 0

		for _, v in ipairs(p6.contacts) do
			local v51 = #v.phonenumber

			if v51 > 1 then
				n2 += 1
			end

			n1 += v51
		end

		p1.numTotalNumbersOnDevice = n1
		p1.numContactsWithMultipleNumbers = n2

		return v46
	end
	function p1.uploadDeviceContacts(p7) -- line: 230
		-- upvalues: UploadContactsSources (copy), p1 (copy), FFlagContactImporterIXPCleanup (copy), IXPVariants (copy), getFIntContactImporterUploadContactsMin (copy), Promise (copy), EventNames (copy)
		p7.source = UploadContactsSources.CI

		local props = p1.props

		if #p7.contacts == 0 or (not FFlagContactImporterIXPCleanup and props.variant == IXPVariants.INVITES_ONLY or #p7.contacts < getFIntContactImporterUploadContactsMin()) then
			return Promise.resolve({
				shouldFindContacts = false
			})
		end

		return props.uploadContacts(p7):andThen(function() -- line: 246
			-- upvalues: Promise (copy)
			return Promise.resolve({
				shouldFindContacts = true
			})
		end, function() -- line: 248
			-- upvalues: p1 (copy), EventNames (copy), Promise (copy)
			p1.fireAnalyticsEvent(EventNames.FailedUploadContactsFromDevice, {
				failedStep = EventNames.FailedUploadContactsFromDevice
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = EventNames.FailedUploadContactsFromDevice
			})

			return Promise.resolve({
				shouldFindContacts = true
			})
		end)
	end
	function p1.findContacts(p8) -- line: 262
		-- upvalues: p1 (copy), Promise (copy)
		local props = p1.props

		if p8.shouldFindContacts then
			return props.findContacts()
		end

		return Promise.resolve()
	end
	function p1.getContactEntities(p9) -- line: 271
		-- upvalues: p1 (copy), Promise (copy)
		local props = p1.props

		if p9 then
			return props.getContactEntities(p9)
		end

		return Promise.resolve()
	end
	function p1.fireHasLoaded(p10) -- line: 281
		-- upvalues: getDeepValue (copy), p1 (copy), EventNames (copy), FieldNames (copy), Promise (copy)
		local v59 = getDeepValue(p10 or {}, "responseBody.userContactsEntities")
		local v60 = not v59 and 0 or #v59

		p1.fireAnalyticsEvent(EventNames.ContactsListLoaded, {
			[FieldNames.NumTotalContactsImported] = p1.contactsCount,
			[FieldNames.NumMatchedContacts] = v60,
			[FieldNames.NumMaxContacts] = true,
			[FieldNames.NumMinContacts] = true,
			[FieldNames.NumTotalContactsOnDevice] = p1.numTotalContactsOnDevice
		})
		p1:setState({
			isFetching = false
		})
		p1.fireContactImportingTimeEvent({
			isSuccessfulUpload = true,
			nummatchedContacts = v60
		})

		return Promise.resolve()
	end
	function p1.failedToUpload(_) -- line: 303
		-- upvalues: p1 (copy)
		p1:setState({
			hasUploadError = true,
			isFetching = false
		})
		p1.fireContactImportingTimeEvent({
			isSuccessfulUpload = false
		})
	end
	function p1.getContacts() -- line: 312
		-- upvalues: p1 (copy), Constants (copy), AccessResponseEnum (copy), FFlagContactImporterIXPCleanup (copy), EventNames (copy), Promise (copy)
		p1:setState({
			isFetching = true
		})

		local v62 = p1.ampApiProvider.getFeatureAccess({ Constants.SHOW_MATCHED_CONTACTS })
		local v63 = ((if not (#v62.featureAccessList > 0) then AccessResponseEnum.Actionable else v62.featureAccessList[1].access)) == AccessResponseEnum.Granted

		p1:setState({
			showMatchedContacts = v63
		})

		if not FFlagContactImporterIXPCleanup and (p1.props.isPVRequired and not v63) then
			local v64 = p1.getContactsFromDevice()
			local formatContactsFromDevice = p1.formatContactsFromDevice
			local FailedGetContactsFromDevice = EventNames.FailedGetContactsFromDevice
			local v67 = v64:andThen(formatContactsFromDevice, function(p12) -- line: 108
				-- upvalues: Promise (copy), p1 (copy), FailedGetContactsFromDevice (copy)
				if type(p12) == "table" and p12.hasAlreadyErrored then
					return Promise.reject({
						hasAlreadyErrored = true
					})
				end

				p1:setState({
					hasUploadError = true,
					isFetching = false
				})
				p1.fireAnalyticsEvent(FailedGetContactsFromDevice, {
					failedStep = FailedGetContactsFromDevice
				})
				p1.fireContactImportingTimeEvent({
					isSuccessfulUpload = false,
					failedStep = FailedGetContactsFromDevice
				})

				return Promise.reject({
					hasAlreadyErrored = true
				})
			end)
			local fireHasLoaded = p1.fireHasLoaded
			local FailedFormatContactsFromDevice = EventNames.FailedFormatContactsFromDevice

			v67:andThen(fireHasLoaded, function(p13) -- line: 108
				-- upvalues: Promise (copy), p1 (copy), FailedFormatContactsFromDevice (copy)
				if type(p13) == "table" and p13.hasAlreadyErrored then
					return Promise.reject({
						hasAlreadyErrored = true
					})
				end

				p1:setState({
					hasUploadError = true,
					isFetching = false
				})
				p1.fireAnalyticsEvent(FailedFormatContactsFromDevice, {
					failedStep = FailedFormatContactsFromDevice
				})
				p1.fireContactImportingTimeEvent({
					isSuccessfulUpload = false,
					failedStep = FailedFormatContactsFromDevice
				})

				return Promise.reject({
					hasAlreadyErrored = true
				})
			end):catch(p1.failedToUpload)

			return
		end

		local v70 = p1.getContactsFromDevice()
		local formatContactsFromDevice = p1.formatContactsFromDevice
		local FailedGetContactsFromDevice = EventNames.FailedGetContactsFromDevice
		local v73 = v70:andThen(formatContactsFromDevice, function(p14) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), FailedGetContactsFromDevice (copy)
			if type(p14) == "table" and p14.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(FailedGetContactsFromDevice, {
				failedStep = FailedGetContactsFromDevice
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = FailedGetContactsFromDevice
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end)
		local uploadDeviceContacts = p1.uploadDeviceContacts
		local FailedFormatContactsFromDevice = EventNames.FailedFormatContactsFromDevice
		local v76 = v73:andThen(uploadDeviceContacts, function(p15) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), FailedFormatContactsFromDevice (copy)
			if type(p15) == "table" and p15.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(FailedFormatContactsFromDevice, {
				failedStep = FailedFormatContactsFromDevice
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = FailedFormatContactsFromDevice
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end)
		local findContacts = p1.findContacts
		local FailedUploadContactsFromDevice = EventNames.FailedUploadContactsFromDevice
		local v79 = v76:andThen(findContacts, function(p16) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), FailedUploadContactsFromDevice (copy)
			if type(p16) == "table" and p16.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(FailedUploadContactsFromDevice, {
				failedStep = FailedUploadContactsFromDevice
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = FailedUploadContactsFromDevice
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end)
		local getContactEntities = p1.getContactEntities
		local FailedFindContacts = EventNames.FailedFindContacts
		local v82 = v79:andThen(getContactEntities, function(p17) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), FailedFindContacts (copy)
			if type(p17) == "table" and p17.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(FailedFindContacts, {
				failedStep = FailedFindContacts
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = FailedFindContacts
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end)
		local fireHasLoaded = p1.fireHasLoaded
		local FailedGetContactEntities = EventNames.FailedGetContactEntities

		v82:andThen(fireHasLoaded, function(p18) -- line: 108
			-- upvalues: Promise (copy), p1 (copy), FailedGetContactEntities (copy)
			if type(p18) == "table" and p18.hasAlreadyErrored then
				return Promise.reject({
					hasAlreadyErrored = true
				})
			end

			p1:setState({
				hasUploadError = true,
				isFetching = false
			})
			p1.fireAnalyticsEvent(FailedGetContactEntities, {
				failedStep = FailedGetContactEntities
			})
			p1.fireContactImportingTimeEvent({
				isSuccessfulUpload = false,
				failedStep = FailedGetContactEntities
			})

			return Promise.reject({
				hasAlreadyErrored = true
			})
		end):catch(p1.failedToUpload)
	end
	function p1.closeModal(p19) -- line: 342
		-- upvalues: p1 (copy), FFlagContactImporterIXPCleanup (copy), IXPVariants (copy)
		local props = p1.props
		local state = p1.state

		p1.fireAnalyticsEvent(p19, {
			isLoading = if not FFlagContactImporterIXPCleanup then p1.isFetching(props.variant, IXPVariants) else p1.state.isFetching,
			loadingTime = if not state.isFetching then nil else os.clock() - p1.startTime
		})

		if p1.props.navigation then
			p1.props.navigation.pop()

			return
		end

		if p1.props.onClose then
			p1.props.onClose()
		end
	end
	function p1.onAddFriendsActivated() -- line: 356
		-- upvalues: p1 (copy), EnumScreens (copy)
		p1.props.navigation.replace(EnumScreens.AddFriendsPage)
	end

	p1.isFetching = not FFlagContactImporterIXPCleanup and function(p20, p21) -- line: 365
		-- upvalues: p1 (copy)
		local state = p1.state

		if p20 == p21.BLENDED then
			return state.isFetching
		end

		return false
	end or nil

	function p1.openDiscoverabilityModal() -- line: 370
		-- upvalues: p1 (copy), EnumScreens (copy), DiscoverabilityAnalytics (copy), Constants (copy), AccessResponseEnum (copy), getFFlagFindFriendsClickedEventEnabled (copy), EventNames (copy), Dash (copy)
		local navigation = p1.props.navigation

		navigation.replace(EnumScreens.DiscoverabilityOverlay, {
			isStandaloneDiscoverabilityModal = true,
			entryPoint = DiscoverabilityAnalytics.EntryPoints.ContactsList,
			navigateOnActivated = function() -- line: 377
				-- upvalues: navigation (copy), EnumScreens (copy), Constants (copy), p1 (copy)
				navigation.replace(EnumScreens.ContactsList, {
					[Constants.SHOULD_UPDATE_USER_SETTINGS] = true,
					[Constants.IS_PHONE_VERIFIED] = p1.getPropOrParam(Constants.IS_PHONE_VERIFIED),
					openAmpUpsell = p1.getPropOrParam(Constants.OPEN_AMP_UPSELL),
					entryPoint = p1.entryPoint
				})
			end
		})

		local v92 = p1.getPropOrParam(Constants.OPEN_AMP_UPSELL)

		p1.openAmpUpsell = if not v92 then Dash.noop else function() -- line: 390
			-- upvalues: AccessResponseEnum (copy), p1 (copy), getFFlagFindFriendsClickedEventEnabled (copy), EventNames (copy), v92 (copy), Constants (copy)
			if getFFlagFindFriendsClickedEventEnabled() then
				p1.fireAnalyticsEvent(EventNames.FindFriendsButtonClicked)
			end

			v92(Constants.SHOW_MATCHED_CONTACTS, function(p22, _) -- line: 391
				-- upvalues: AccessResponseEnum (copy), p1 (copy)
				if p22 == AccessResponseEnum.Granted then
					p1.getContacts()
					p1.openDiscoverabilityModal()
				end
			end)
		end
	end
end
function v28.didMount(p24) -- line: 407
	p24.getContacts()
end
function v28.render(p25) -- line: 411
	-- upvalues: FFlagContactImporterIXPCleanup (copy), Roact (copy), ContactsList (copy), IXPVariants (copy), Analytics (copy)
	local props = p25.props
	local v34 = if not FFlagContactImporterIXPCleanup then props.variant else nil
	local entryPoint = p25.entryPoint

	return Roact.createElement(ContactsList, {
		deviceContacts = props.deviceContacts,
		matchedContacts = props.matchedContacts,
		isFetching = if not FFlagContactImporterIXPCleanup then p25.isFetching(v34, IXPVariants) else p25.state.isFetching,
		requestFriendship = p25.requestFriendship,
		screenSize = props.screenSize,
		hasUploadError = p25.state.hasUploadError,
		onAddFriendsActivated = p25.onAddFriendsActivated,
		closeModal = p25.closeModal,
		showAddFriendsButton = entryPoint == Analytics.EntryPoints.HomePage,
		variant = if not FFlagContactImporterIXPCleanup then props.variant else nil,
		openProfilePeekView = p25.props.openProfilePeekView,
		showMatchedContacts = p25.state.showMatchedContacts,
		openAmpUpsell = p25.openAmpUpsell
	})
end

return RoactRodux.connect(ContactsListMapStateToProps, ContactsListMapDispatchToProps)(v28)
