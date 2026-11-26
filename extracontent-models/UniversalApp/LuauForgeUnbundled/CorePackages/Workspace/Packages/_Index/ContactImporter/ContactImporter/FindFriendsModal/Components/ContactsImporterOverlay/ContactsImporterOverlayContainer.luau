local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local contactImporterModalInfoUpdater = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/contactImporterModalInfoUpdater")
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics")

local roact = dependencies.Roact
local roactRodux = dependencies.RoactRodux
local permissionsProtocol = dependencies.PermissionsProtocol
local promise = dependencies.Promise

local ContactsImporterOverlay = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/FindFriendsModal/Components/ContactsImporterOverlay/ContactsImporterOverlay")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/FindFriendsModal/Components/ContactsImporterOverlay/mapDispatchToProps")
local selectors = dependencies.RoduxContacts.Selectors
local appStorageService = dependencies.AppStorageService
local discoverabilityAnalytics = dependencies.DiscoverabilityAnalytics

local extended = roact.PureComponent:extend("ContactsImporterOverlayContainer")

extended.defaultProps = {
	checkOrRequestPermissions = function(p2)
		return permissionsProtocol.default:checkOrRequestPermissions(p2)
	end,
	localUserId = "",
	handleShowToastForTests = nil
}

function extended:init()
	self.isFromAddFriendsPage = self.props.navigation.getParam(Constants.IS_FROM_ADD_FRIENDS_PAGE, false)

	local v5 = if self.isFromAddFriendsPage then discoverabilityAnalytics.EntryPoints.AddFriends else discoverabilityAnalytics.EntryPoints.HomePage
	self.entryPoint = v5

	self.fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = { entry = self.entryPoint }
	})

	local param = self.props.navigation.getParam(Constants.OPEN_AMP_UPSELL)
	function self.checkOrRequestContactsPermissions()
		return self.props.checkOrRequestPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS })
	end

	function self.failedToUpload(p2)
		self.props.showToast(TextKeys.CI_FAILED)
	end

	function self.closeModal()
		self.props.navigation.pop()
	end

	function self.permissionsFlowToContactImporter()
		local props = self.props
		local navigation = props.navigation
		local param2 = navigation.getParam(Constants.IS_FROM_SIGNUP)

		self.checkOrRequestContactsPermissions():andThen(function(p2)
			if p2 == permissionsProtocol.Status.AUTHORIZED then
				updateOptedInUsers:addUserToLocalStorage(appStorageService, props.localUserId)

				if param2 then
					props.updateUserSettings()
					props.navigation.pop()
				else
					props.hideContactImporterModal()
					navigation.replace(enumScreens.ContactsList, {
						[Constants.SHOULD_UPDATE_USER_SETTINGS] = true,
						[Constants.IS_PHONE_VERIFIED] = navigation.getParam(Constants.IS_PHONE_VERIFIED),
						[Constants.OPEN_LEARN_MORE_LINK] = navigation.getParam(Constants.OPEN_LEARN_MORE_LINK),
						openAmpUpsell = param,
						entryPoint = self.entryPoint
					})
				end
			else
				if p2 ~= permissionsProtocol.Status.DENIED then
					return promise.reject()
				end

				navigation.replace(enumScreens.ContactsRevokedAccessDialog, {
					screenSize = props.screenSize,
					closeModal = self.closeModal
				})
			end

			return promise.resolve()
		end):catch(self.failedToUpload)
	end

	function self.checkDiscoverability(p2)
		local param2 = self.props.navigation.getParam(Constants.IS_PHONE_VERIFIED)
		return p2 and param2
	end

	function self.onConnectContacts()
		local param2 = self.props.navigation.getParam("isDiscoverabilityUnset")
		self.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalContinue)

		if self.checkDiscoverability(param2) then
			self.navigateToDiscoverabilityModal()
		else
			self.permissionsFlowToContactImporter()
		end
	end

	function self.navigateToDiscoverabilityModal()
		local props = self.props
		local navigation = props.navigation

		props.getUserSettingsMetadata():andThen(function()
			navigation.replace(enumScreens.DiscoverabilityOverlay, {
				entryPoint = self.entryPoint
			})
		end)
	end

	function self.onAddFriendsActivated()
		local props = self.props
		self.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalAddFriends)

		props.navigation.replace(enumScreens.AddFriendsPage)
	end

	function self.onCloseClicked()
		local props = self.props
		self.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalClose)
		props.navigation.pop()
	end

	function self.onLearnMoreClick()
		self.props.openLearnMoreLink()
	end
end

function extended.didMount(p2)
	p2.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalPageLoad)

	contactImporterModalInfoUpdater:addSeenCount(appStorageService, p2.props.localUserId)
	contactImporterModalInfoUpdater:updateTimestamp(appStorageService, p2.props.localUserId, DateTime.now().UnixTimestampMillis)
end

function extended.render(props)
	local props2 = props.props
	local navigation = props2.navigation
	local param = navigation.getParam(Constants.IS_FROM_ADD_FRIENDS_PAGE, false)
	local param2 = props.props.navigation.getParam(Constants.IS_FROM_SIGNUP)
	local param3 = navigation.getParam(Constants.IS_FROM_SOCIAL_ONBOARDING_BUTTONS)

	return roact.createElement(ContactsImporterOverlay, {
		screenSize = props2.screenSize,
		onCloseClicked = props.onCloseClicked,
		onAddFriendsActivated = props.onAddFriendsActivated,
		onConnectContacts = props.onConnectContacts,
		onLearnMoreClick = props.onLearnMoreClick,
		isFromAddFriendsPage = param,
		isFromSignup = param3 and true or param2
	})
end

return roactRodux.connect(function(p2)
	return {
		contacts = selectors.sortContacts(p2),
		localUserId = p2.LocalUserId,
		screenSize = p2.ScreenSize
	}
end, mapDispatchToProps)(extended)
