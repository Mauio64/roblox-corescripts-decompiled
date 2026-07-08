local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local _ = ParentParent.Parent
local TextKeys = require(ParentParent.Common.TextKeys)
local contactImporterModalInfoUpdater = require(ParentParent.Utils.contactImporterModalInfoUpdater)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local EnumScreens = dependencies.SocialModalsCommon.EnumScreens
local Constants = require(ParentParent.Common.Constants)
local Analytics = require(ParentParent.Analytics)
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local PermissionsProtocol = dependencies.PermissionsProtocol
local Promise = dependencies.Promise
local ContactsImporterOverlay = require(script.Parent.ContactsImporterOverlay)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local Selectors = dependencies.RoduxContacts.Selectors
local AppStorageService = dependencies.AppStorageService
local DiscoverabilityAnalytics = dependencies.DiscoverabilityAnalytics
local v19 = Roact.PureComponent:extend("ContactsImporterOverlayContainer")

v19.defaultProps = {
	localUserId = "",
	handleShowToastForTests = nil,
	checkOrRequestPermissions = function(p1) -- line: 44
		-- upvalues: PermissionsProtocol (copy)
		return PermissionsProtocol.default:checkOrRequestPermissions(p1)
	end
}

function v19.init(p2) -- line: 52
	-- upvalues: Constants (copy), DiscoverabilityAnalytics (copy), Analytics (copy), PermissionsProtocol (copy), TextKeys (copy), updateOptedInUsers (copy), AppStorageService (copy), EnumScreens (copy), Promise (copy)
	p2.isFromAddFriendsPage = p2.props.navigation.getParam(Constants.IS_FROM_ADD_FRIENDS_PAGE, false)
	p2.entryPoint = if not p2.isFromAddFriendsPage then DiscoverabilityAnalytics.EntryPoints.HomePage else DiscoverabilityAnalytics.EntryPoints.AddFriends
	p2.fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = {
			entry = p2.entryPoint
		}
	})

	local v22 = p2.props.navigation.getParam(Constants.OPEN_AMP_UPSELL)

	function p2.checkOrRequestContactsPermissions() -- line: 67
		-- upvalues: p2 (copy), PermissionsProtocol (copy)
		return p2.props.checkOrRequestPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS })
	end
	function p2.failedToUpload(_) -- line: 74
		-- upvalues: p2 (copy), TextKeys (copy)
		p2.props.showToast(TextKeys.CI_FAILED)
	end
	function p2.closeModal() -- line: 81
		-- upvalues: p2 (copy)
		p2.props.navigation.pop()
	end
	function p2.permissionsFlowToContactImporter() -- line: 85
		-- upvalues: p2 (copy), Constants (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), EnumScreens (copy), v22 (copy), Promise (copy)
		local props = p2.props
		local navigation = props.navigation
		local v34 = navigation.getParam(Constants.IS_FROM_SIGNUP)

		p2.checkOrRequestContactsPermissions():andThen(function(p4) -- line: 91
			-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), AppStorageService (copy), props (copy), v34 (copy), navigation (copy), EnumScreens (copy), Constants (copy), v22 (copy), p2 (copy), Promise (copy)
			if p4 == PermissionsProtocol.Status.AUTHORIZED then
				updateOptedInUsers:addUserToLocalStorage(AppStorageService, props.localUserId)

				if v34 then
					props.updateUserSettings()
					props.navigation.pop()
				else
					props.hideContactImporterModal()
					navigation.replace(EnumScreens.ContactsList, {
						[Constants.SHOULD_UPDATE_USER_SETTINGS] = true,
						[Constants.IS_PHONE_VERIFIED] = navigation.getParam(Constants.IS_PHONE_VERIFIED),
						[Constants.OPEN_LEARN_MORE_LINK] = navigation.getParam(Constants.OPEN_LEARN_MORE_LINK),
						openAmpUpsell = v22,
						entryPoint = p2.entryPoint
					})
				end

				return Promise.resolve()
			end

			if p4 == PermissionsProtocol.Status.DENIED then
				navigation.replace(EnumScreens.ContactsRevokedAccessDialog, {
					screenSize = props.screenSize,
					closeModal = p2.closeModal
				})

				return Promise.resolve()
			end

			return Promise.reject()
		end):catch(p2.failedToUpload)
	end
	function p2.checkDiscoverability(p5) -- line: 122
		-- upvalues: p2 (copy), Constants (copy)
		local v36 = p2.props.navigation.getParam(Constants.IS_PHONE_VERIFIED)

		return p5 and v36
	end
	function p2.onConnectContacts() -- line: 128
		-- upvalues: p2 (copy), Analytics (copy)
		local v37 = p2.props.navigation.getParam("isDiscoverabilityUnset")

		p2.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalContinue)

		if p2.checkDiscoverability(v37) then
			p2.navigateToDiscoverabilityModal()

			return
		end

		p2.permissionsFlowToContactImporter()
	end
	function p2.navigateToDiscoverabilityModal() -- line: 140
		-- upvalues: p2 (copy), EnumScreens (copy)
		local props = p2.props
		local navigation = props.navigation

		props.getUserSettingsMetadata():andThen(function() -- line: 144
			-- upvalues: navigation (copy), EnumScreens (copy), p2 (copy)
			navigation.replace(EnumScreens.DiscoverabilityOverlay, {
				entryPoint = p2.entryPoint
			})
		end)
	end
	function p2.onAddFriendsActivated() -- line: 151
		-- upvalues: p2 (copy), Analytics (copy), EnumScreens (copy)
		local props = p2.props

		p2.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalAddFriends)
		props.navigation.replace(EnumScreens.AddFriendsPage)
	end
	function p2.onCloseClicked() -- line: 158
		-- upvalues: p2 (copy), Analytics (copy)
		local props = p2.props

		p2.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalClose)
		props.navigation.pop()
	end
	function p2.onLearnMoreClick() -- line: 164
		-- upvalues: p2 (copy)
		p2.props.openLearnMoreLink()
	end
end
function v19.didMount(p6) -- line: 171
	-- upvalues: Analytics (copy), contactImporterModalInfoUpdater (copy), AppStorageService (copy)
	p6.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalPageLoad)
	contactImporterModalInfoUpdater:addSeenCount(AppStorageService, p6.props.localUserId)
	contactImporterModalInfoUpdater:updateTimestamp(AppStorageService, p6.props.localUserId, DateTime.now().UnixTimestampMillis)
end
function v19.render(p7) -- line: 183
	-- upvalues: Constants (copy), Roact (copy), ContactsImporterOverlay (copy)
	local props = p7.props
	local navigation = props.navigation
	local v27 = navigation.getParam(Constants.IS_FROM_ADD_FRIENDS_PAGE, false)
	local v28 = p7.props.navigation.getParam(Constants.IS_FROM_SIGNUP)
	local v29 = navigation.getParam(Constants.IS_FROM_SOCIAL_ONBOARDING_BUTTONS)

	return Roact.createElement(ContactsImporterOverlay, {
		screenSize = props.screenSize,
		onCloseClicked = p7.onCloseClicked,
		onAddFriendsActivated = p7.onAddFriendsActivated,
		onConnectContacts = p7.onConnectContacts,
		onLearnMoreClick = p7.onLearnMoreClick,
		isFromAddFriendsPage = v27,
		isFromSignup = not not v29 or v28
	})
end

return RoactRodux.connect(function(p8) -- line: 201
	-- upvalues: Selectors (copy)
	return {
		contacts = Selectors.sortContacts(p8),
		localUserId = p8.LocalUserId,
		screenSize = p8.ScreenSize
	}
end, mapDispatchToProps)(v19)
