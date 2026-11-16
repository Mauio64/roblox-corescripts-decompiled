local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local TextKeys = require(parent.Common.TextKeys)
local contactImporterModalInfoUpdater = require(parent.Utils.contactImporterModalInfoUpdater)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers

local enumScreens = dependencies.SocialModalsCommon.EnumScreens
local Constants = require(parent.Common.Constants)
local Analytics = require(parent.Analytics)

local roact = dependencies.Roact
local roactRodux = dependencies.RoactRodux
local permissionsProtocol = dependencies.PermissionsProtocol
local promise = dependencies.Promise

local ContactsImporterOverlay = require(script.Parent.ContactsImporterOverlay)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local selectors = dependencies.RoduxContacts.Selectors
local appStorageService = dependencies.AppStorageService
local discoverabilityAnalytics = dependencies.DiscoverabilityAnalytics

local extended = roact.PureComponent:extend("ContactsImporterOverlayContainer")

extended.defaultProps = {
	checkOrRequestPermissions = function(p)
		return permissionsProtocol.default:checkOrRequestPermissions(p)
	end,
	localUserId = "",
	handleShowToastForTests = nil
}

function extended:init()
	self.isFromAddFriendsPage = self.props.navigation.getParam(Constants.IS_FROM_ADD_FRIENDS_PAGE, false)
	local entryPoint

	if self.isFromAddFriendsPage then
		entryPoint = discoverabilityAnalytics.EntryPoints.AddFriends
	else
		entryPoint = discoverabilityAnalytics.EntryPoints.HomePage
	end

	self.entryPoint = entryPoint

	self.fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
		analytics = Analytics.AnalyticsService,
		defaultAnalyticsInfo = { entry = self.entryPoint }
	})

	local param = self.props.navigation.getParam(Constants.OPEN_AMP_UPSELL)
	function self.checkOrRequestContactsPermissions()
		return self.props.checkOrRequestPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS })
	end

	function self.failedToUpload(_)
		self.props.showToast(TextKeys.CI_FAILED)
	end

	function self.closeModal()
		self.props.navigation.pop()
	end

	function self.permissionsFlowToContactImporter()
		local props = self.props
		local navigation = props.navigation
		local param2 = navigation.getParam(Constants.IS_FROM_SIGNUP)

		self.checkOrRequestContactsPermissions():andThen(function(p)
			if p == permissionsProtocol.Status.AUTHORIZED then
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
				if p ~= permissionsProtocol.Status.DENIED then
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

	function self.checkDiscoverability(p)
		local param2 = self.props.navigation.getParam(Constants.IS_PHONE_VERIFIED)
		return p and param2
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
			navigation.replace(enumScreens.DiscoverabilityOverlay, { entryPoint = self.entryPoint })
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

function extended.didMount(p)
	p.fireAnalyticsEvent(Analytics.EventNames.ContactImportModalPageLoad)

	contactImporterModalInfoUpdater:addSeenCount(appStorageService, p.props.localUserId)
	contactImporterModalInfoUpdater:updateTimestamp(
		appStorageService,
		p.props.localUserId,
		DateTime.now().UnixTimestampMillis
	)
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

return roactRodux.connect(function(p)
	return {
		contacts = selectors.sortContacts(p),
		localUserId = p.LocalUserId,
		screenSize = p.ScreenSize
	}
end, mapDispatchToProps)(extended)
