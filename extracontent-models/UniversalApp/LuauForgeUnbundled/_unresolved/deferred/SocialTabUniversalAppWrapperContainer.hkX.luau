local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy
local withStyle = UIBlox.Style.withStyle
local contexts = require("@luauforge/bundled/ecs").Analytics.Enums.Contexts
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/dAF")
local module3 = require("@luauforge/bundled/ehY")
local module4 = require("@luauforge/deferred/hkY")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module5 = require("@luauforge/deferred/hkZ")
local robloxEventReceiver = require("@luauforge/bundled/ehP").RobloxEventReceiver
local module6 = require("@luauforge/deferred/gHS")

local squadAppChatEventReceiver = require("@luauforge/deferred/hla").SquadAppChatEventReceiver

local module7 = require("@luauforge/bundled/fvN")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local module8 = require("@luauforge/deferred/hlY")

local module9 = require("@luauforge/deferred/hlZ")
local module10 = require("@luauforge/bundled/ect")

local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")
local getDefaultQualityLevel = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GetDefaultQualityLevel
local androidBackButtonConnection = require("@luauforge/deferred/hmz").AndroidBackButtonConnection

local enumScreens = require("@luauforge/deferred/hmz").EnumScreens
local module12 = require("@luauforge/deferred/hnK")
local context = require("@luauforge/deferred/hnM").Context
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local module13 = require("@luauforge/deferred/egn")

local module14 = require("@luauforge/bundled/hnQ")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local fFlagSignalsNavP3Final = SharedFlags.FFlagSignalsNavP3Final

local module16 = require("@luauforge/deferred/hnR")

local Container = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/Container")

local module18 = require("@luauforge/bundled/eie")
local module19 = require("@luauforge/bundled/ecq")
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents

local module20 = require("@luauforge/bundled/dKt")
local module21 = require("@luauforge/bundled/ehB")
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local module22 = require("@luauforge/bundled/dKz")
local module23 = require("@luauforge/bundled/dGJ")
local fFlagCentralOverlayExcludeDeviceSafePadding = SharedFlags.FFlagCentralOverlayExcludeDeviceSafePadding
local useNavBarPlacement = module22.useNavBarPlacement
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local convertUniverseIdToString = SharedFlags.ConvertUniverseIdToString

local communityListRouting = require("@luauforge/bundled/dGP").CommunityListRouting

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local module24 = require("@luauforge/bundled/hGe")
local default = require("@luauforge/bundled/bZh").PermissionsProtocol.default
local default2 = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local defineFastFlag = game:DefineFastFlag("SocialTabShouldRequestPushPermissions", false)
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local getFFlagEnablePushNotificationsUpsellModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnablePushNotificationsUpsellModal
local defineFastFlag2 = game:DefineFastFlag("PushUpsellExposureLogFix", false)

local getFStringPushUpsellVariantName = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringPushUpsellVariantName
local fFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local fFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local fFlagSocialTabWrapperStableNavigationProps = SharedFlags.FFlagSocialTabWrapperStableNavigationProps
local fFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagAppChatMomentShareCardNavigation = SharedFlags.FFlagAppChatMomentShareCardNavigation
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled
local getShortcutBarStatusStore

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	getShortcutBarStatusStore = require("@luauforge/bundled/ehS").GetShortcutBarStatusStore
else
	getShortcutBarStatusStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local extended = Roact.PureComponent:extend("SocialTabUniversalAppWrapper")

extended.defaultProps = {
	renderSocialTab = function()
		return Roact.createElement(module12)
	end,
	renderRoactChat = function()
		return context.with(function(p2)
			return p2.wasEverVisible and Roact.createElement(module16, p2) or nil
		end)
	end,
	renderChatPushUpsellPrompts = fFlagChatPushUpsellPromptsEnabled and function()
		return Roact.createElement(require("@luauforge/bundled/fBo").ChatPromptsHandler)
	end or nil,
	runService = RunService
}

function extended:init()
	self.state = {
		wasChatEverTapped = self.props.isVisible,
		externalNavigationByScreen = {}
	}

	self.chatToastRef = Roact.createRef()

	self.androidBackButtonConnection = androidBackButtonConnection(self.props.guiService, module7)

	self.androidBackButtonConnectionSocialTab = androidBackButtonConnection(self.props.guiService, module7)

	self._rnBypassActionSignal = selfViewVisibilityUpdatedSignal.new()

	self._rnBypassActionSignalSocialTab = selfViewVisibilityUpdatedSignal.new()

	self.backButtonEnabled = false

	self._performanceTesting = module5
	self._robloxEventReceiver = robloxEventReceiver.new(self.props.notificationService)

	function self.renderOnLoaded()
		if self.state.wasChatEverTapped then
			return Roact.createFragment({
				screen = self.props.renderSocialTab(),
				externalNavigation = Roact.createElement(Container, {
					navigationByScreen = self.state.externalNavigationByScreen
				})
			})
		end

		return nil
	end

	function self.setBackButtonEnabled(backButtonEnabled)
		self.backButtonEnabled = backButtonEnabled
	end

	function self.setTabBarVisibleFromChat(p2)
		local v5 = self.props.shouldSystemBarUsuallyBePresent and true or p2
		self.props.setTabBarVisibleFromChat(v5)
	end

	function self.setActiveConversationId(p2)
		logger:debug("{} setting activeConversationId as {}", "SocialTabUniversalAppWrapper", p2)
		self:setState({
			activeConversationId = p2 or Roact.None
		})
	end

	function self.getActiveConversationId()
		return self.state.activeConversationId
	end

	function self.initRoactChatNavigation()
		self._rnBypassActionSignalSocialTab:fire(RoactNavigation.Actions.navigate({
			routeName = enumScreens.RoactChat
		}))
	end

	function self.updateExternalNavigationForScreen(p2, p3)
		self:setState(function(p4, p5)
			if p2 then
				return {
					externalNavigationByScreen = llama.Dictionary.join(p4.externalNavigationByScreen, {
						[p3] = p2
					})
				}
			end

			local copy = llama.Dictionary.copy(p4.externalNavigationByScreen)
			copy[p3] = nil
			return { externalNavigationByScreen = copy }
		end)
	end

	function self.navigateDownToNotifications(p2)
		local v5 = p2 or false

		self.props.navigateDownToNotifications(function()
			if v5 then
				self.setTabBarVisibleFromChat(true)
			end
		end)
	end

	function self.navigateToCoHubAddConnections()
		self.props.navigation.navigate(module.CoHubAddConnections)
	end

	function self.openProfileWebView(p2)
		self.props.navigateDownToViewUserProfile(p2, function()
			if self.props.wideMode then
				self.setTabBarVisibleFromChat(self.props.wideMode)
			end
		end)
	end

	function self.openProfilePeekView(p2, p3)
		self.props.openProfilePeekView(p2, {
			onClose = function()
				if self.state.getIsTabBarEnabled then
					self.setTabBarVisibleFromChat(self.state.getIsTabBarEnabled())
				end

				if p3 and p3.onClose then
					p3.onClose()
				end
			end,
			onOpen = function()
				self.setTabBarVisibleFromChat(false)

				if p3 and p3.onOpen then
					p3.onOpen()
				end
			end,
			resetPeekView = true
		})
	end

	function self.navigateDownToReportAbuse(p2, p3)
		if self.props.useLuafiedReportFlow then
			self.props.openReportDialog(p2, p3)
		else
			self.props.navigateDownToReportAbuse(p2, p3)
		end
	end

	function self.navigateDownToPrivacySettings()
		self.props.navigateDownToPrivacySettings()
	end

	function self.navigateDownToGroups()
		local function fn()
			self.setTabBarVisibleFromChat(true)
		end

		if communityListRouting.getShouldUseLuaCommunityList() then
			self.props.openGroupsListPage(fn)
		else
			self.props.navigateDownToGroups(fn)
		end
	end

	function self.navigateDownToAddFriends()
		self.props.navigateDownToAddFriends(function()
			self.setTabBarVisibleFromChat(true)
		end)
	end

	function self.navigateToHomePage()
		self.props.navigation.navigate(module.Home)
	end

	function self.FriendFinder()
		self.props.navigateDownToFriendFinder(function()
			self.setTabBarVisibleFromChat(true)
		end)
	end

	function self.AddFriendsAccountProvider(p2)
		self.props.navigateDownToAddFriendsAccountProvider(p2)
	end

	function self.setIsTabBarEnabled(p2)
		self:setState({ getIsTabBarEnabled = p2 })
	end

	function self.openUserContextualMenu(p2)
		local onClose = p2.onClose

		local joined = llama.Dictionary.join(p2, {
			onCloseGameDetails = function()
				self.setTabBarVisibleFromChat(true)
			end,
			onClose = function()
				if onClose then
					onClose()
				end
			end,
			onCloseProfileWebview = function()
				self.setTabBarVisibleFromChat(true)
			end,
			user = module8(p2.user)
		})

		self.props.openContextualMenu(joined)
	end

	function self.navigateToUserInfo(p2, data)
		if not data then
			self.openProfileWebView(p2)
			return
		end

		local contextualMenuProps = data.contextualMenuProps or {}

		if data.contextualMenuProps then
			contextualMenuProps = llama.Dictionary.join(contextualMenuProps, {
				onCloseGameDetails = function()
					self.setTabBarVisibleFromChat(true)
				end,
				onClose = function()
					if data.contextualMenuProps.onClose then
						data.contextualMenuProps.onClose()
					end
				end,
				onCloseProfileWebview = function()
					self.setTabBarVisibleFromChat(true)
				end,
				user = module8(data.contextualMenuProps.user)
			})
		end

		local joined = llama.Dictionary.join(data.profilePeekViewProps or {}, {
			resetPeekView = true,
			onClose = function()
				if self.state.getIsTabBarEnabled then
					self.setTabBarVisibleFromChat(self.state.getIsTabBarEnabled())
				end

				if data.profilePeekViewProps and data.profilePeekViewProps.onClose then
					data.profilePeekViewProps.onClose()
				end
			end,
			onOpen = function()
				self.setTabBarVisibleFromChat(false)

				if data.profilePeekViewProps and data.profilePeekViewProps.onOpen then
					data.profilePeekViewProps.onOpen()
				end
			end,
			source = data.source
		})

		self.props.navigateToUserInfo(p2, {
			contextualMenuProps = contextualMenuProps,
			profilePeekViewProps = joined,
			openJoinable = data.openJoinable,
			entryPoint = data.entryPoint
		})
	end

	function self.navigateDownToMomentsImmersive(p2, p3)
		local getMomentsCapabilities = require("@luauforge/bundled/fIP").Stores.GetMomentsCapabilities

		if
			fFlagEnableArgus
			and fFlagEnableArgusImmersiveNav
			and getMomentsCapabilities(false).getHasMomentsAccess(false)
		then
			self.props.navigateDownToMomentsImmersive(p2, p3)
		end
	end

	local v5 = {
		[enumScreens.GameDetail] = self.props.navigateToGameDetails,
		[enumScreens.ViewUserProfile] = self.navigateToUserInfo,
		[enumScreens.Notifications] = self.navigateDownToNotifications,
		[enumScreens.LearnMore] = self.props.openLearnMoreLink,
		[enumScreens.ReportAbuse] = self.navigateDownToReportAbuse,
		[enumScreens.PrivacySettings] = self.navigateDownToPrivacySettings
	}
	local momentsImmersive = enumScreens.MomentsImmersive

	local v6 = if fFlagAppChatMomentShareCardNavigation and fFlagEnableArgus and fFlagEnableArgusImmersiveNav then self.navigateDownToMomentsImmersive else nil
	v5[momentsImmersive] = v6

	local coHubAddConnections = enumScreens.CoHubAddConnections
	local v7 = if fFlagCreateConnectionsHub then self.navigateToCoHubAddConnections else nil
	v5[coHubAddConnections] = v7

	v5[enumScreens.AddFriends] = self.navigateDownToAddFriends
	v5[enumScreens.Groups] = self.navigateDownToGroups
	v5[enumScreens.FriendFinder] = self.FriendFinder
	v5[enumScreens.AddFriendsAccountProvider] = self.AddFriendsAccountProvider

	v5[enumScreens.ViewUser] = self.openUserContextualMenu

	v5[enumScreens.VerifiedBadgeModal] = self.props.openVerifiedBadgeModal
	v5[enumScreens.DiscoverabilityModal] = self.props.openDiscoverabilityModal

	v5[enumScreens.ProfileQRCode] = function()
		self.props.navigateTo3DQRCodePage({ source = contexts.AddFriends })
	end
	v5[enumScreens.SearchPage] = function()
		self.props.navigation.navigate(module.SearchPage, {
			defaultSearchType = searchTypes.Players
		})
	end
	v5[enumScreens.AmpWizardContainer] = self.props.openAmpWizardContainer

	local home = enumScreens.Home
	local v8 = if getFFlagIsSquadEnabled() then self.navigateToHomePage else nil
	v5[home] = v8
	self.navigateToLuaAppPages = v5

	self.luaAppPages = { playerSearchPage = module13 }

	local renderSteppedConnection = nil
	renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
		end

		local settings_2 = settings()
		settings_2.Rendering.QualityLevel = getDefaultQualityLevel()
	end)

	function self.onBackButtonPressed()
		if self.props.canGoBack then
			self.props.navigateBack()
		elseif self.backButtonEnabled then
			self._rnBypassActionSignal:fire(RoactNavigation.Actions.back())
		else
			self.androidBackButtonConnection.showExitDialog()
		end
	end

	function self.isAndroidBackButtonHandlerDisabled(p2): nil | boolean
		return p2 == module.GameDetail
			or (if not fFlagShareTargetGameCleanup then p2 == module.ShareGameToChat else nil)
			or p2 == module.AvatarExperienceWrapperTransparent
			or p2 == module.AvatarExperienceWrapper
			or p2 == module.ProfilePlatform
	end

	self._navigatingFromSocialTabEvent = nil

	function self.setNavigatingFromSocialTabEvent(p2)
		self._navigatingFromSocialTabEvent = {
			startTime = os.clock(),
			startPage = enumScreens.SocialTab,
			endPage = p2
		}
	end

	function self.getNavigatingFromSocialTabEvent()
		return self._navigatingFromSocialTabEvent
	end

	if defineFastFlag then
		local notificationsCanReceivePush = self.props.shouldShowPushUpsell
			and self.props.notificationsCanReceivePush

		if getFFlagEnablePushNotificationsUpsellModal and notificationsCanReceivePush then
			if self.props.pushUpsellVariant ~= nil then
				local v9

				if defineFastFlag2 then
					v9 = self.props.pushUpsellVariant == 0
				else
					v9 = self.props.pushUpsellVariant > -1
				end

				if v9 then
					local pushUpsellEventConfig = module14.PushUpsellEventConfig
					local modalEventConstants = module14.ModalEventConstants

					default2:logRobloxTelemetryEvent(pushUpsellEventConfig, {}, {
						[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
						[modalEventConstants.EntryPoint] = module.Chat
					})
				end

				if self.props.pushUpsellVariant <= 0 then
					default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS })
				end
			end
		elseif notificationsCanReceivePush then
			default:requestPermissions({ default.Permissions.POST_NOTIFICATIONS })
		end
	end

	self.generateContext = memoize(function(p2, p3, p4, p5, p6, p7, p8, p9, isLuaProfilePageEnabled, luaAddFriendsPageEnabled, androidBackButtonHandlerDisabled, getAndroidBackButtonHandlerDisabled)
		local v9 = {}
		v9.wasEverVisible = self.state.wasEverVisible
		v9.localUserId = p3
		v9.isVisible = p2
		v9.pageType = p6
		v9.parameters = p7
		v9.navigationProps = p4
		v9.logger = logger
		v9.navigateToLuaAppPages = self.navigateToLuaAppPages
		v9.rnBypassActionSignal = self._rnBypassActionSignal
		v9.rnBypassActionSignalSocialTab = self._rnBypassActionSignalSocialTab

		v9.getActiveConversationId = self.getActiveConversationId
		v9.setActiveConversationId = self.setActiveConversationId
		v9.setBackButtonEnabled = self.setBackButtonEnabled
		v9.setTabBarVisible = self.setTabBarVisibleFromChat
		v9.luaAppPages = self.luaAppPages
		v9.wideMode = p8
		v9.notificationCount = p5
		v9.robloxEventReceiver = self._robloxEventReceiver
		v9.userInputService = UserInputService
		v9.roactChatEntryPoint = module16
		v9.androidBackButtonConnection = self.androidBackButtonConnectionSocialTab
		v9.signal = selfViewVisibilityUpdatedSignal

		if not fFlagSignalsNavP3Final then
			getAndroidBackButtonHandlerDisabled = nil
		end

		v9.getAndroidBackButtonHandlerDisabled = getAndroidBackButtonHandlerDisabled

		if fFlagSignalsNavP3Final then
			androidBackButtonHandlerDisabled = nil
		elseif not fFlagSocialTabWrapperStableNavigationProps then
			androidBackButtonHandlerDisabled = self.isAndroidBackButtonHandlerDisabled(p9)
		end

		v9.androidBackButtonHandlerDisabled = androidBackButtonHandlerDisabled

		v9.setIsTabBarEnabled = isLuaProfilePageEnabled and self.setIsTabBarEnabled or nil
		v9.isLuaProfilePageEnabled = isLuaProfilePageEnabled

		v9.useRoactService = module18
		v9.roactAnalytics = module19
		v9.roactAnalyticsCommonGameEvents = roactAnalyticsCommonGameEvents

		v9.joinGame = module3
		v9.openGameDetails = module20
		v9.navigateDown = module21

		v9.presenceType = module2.PresenceType
		v9.appPage = module

		v9.convertUniverseIdToString = convertUniverseIdToString

		v9.setNavigatingFromSocialTabEvent = self.setNavigatingFromSocialTabEvent
		v9.getNavigatingFromSocialTabEvent = self.getNavigatingFromSocialTabEvent
		v9.luaAddFriendsPageEnabled = luaAddFriendsPageEnabled
		v9.setAppLoaded = module6
		v9.fetchUnreadConversationCount = self.props.fetchUnreadConversationCount
		v9.notificationService = self.props.notificationService
		v9.config = module4
		v9.performanceTesting = module5
		v9.notificationType = module7
		v9.diagService = self.props.roactAnalytics.Diag
		v9.eventIngestService = self.props.eventIngestService
		v9.openProfilePeekView = self.props.openProfilePeekView
		v9.closeCentralOverlay = self.props.closeCentralOverlay
		v9.openLearnMoreLink = self.props.openLearnMoreLink
		v9.showToast = self.props.showToast
		v9.updateExternalNavigationForScreen = self.updateExternalNavigationForScreen
		v9.initialRouteName = self.props.initialRouteName
		v9.openPlayerContextualMenu = self.props.openPlayerContextualMenu

		local v10 = if fFlagChatPushUpsellPromptsEnabled then self.props.renderChatPushUpsellPrompts else nil
		v9.renderChatLandingPrompts = v10
		return v9
	end)
end

function extended:render()
	return withStyle(function(p2)
		local initRoactChatNavigation = self.initRoactChatNavigation
		local createElement = Roact.createElement
		local provider = context.Provider
		local generateContext = self.generateContext
		local isVisible = self.props.isVisible
		local localUserId = self.props.localUserId
		local navigationProps = self.props.navigationProps
		local notificationCount = self.props.notificationCount
		local pageType = self.props.pageType
		local parameters = self.props.parameters
		local wideMode = self.props.wideMode
		local currentAppPage = if not fFlagSocialTabWrapperStableNavigationProps then self.props.currentAppPage else nil

		local luaAddFriendsPageEnabled = self.props.luaAddFriendsPageEnabled
		local androidBackButtonHandlerDisabled

		if fFlagSocialTabWrapperStableNavigationProps then
			androidBackButtonHandlerDisabled = self.props.androidBackButtonHandlerDisabled
		end

		local v7 = if fFlagSignalsNavP3Final then self.props.getAndroidBackButtonHandlerDisabled else nil
		local v5 = {
			value = generateContext(
				isVisible,
				localUserId,
				navigationProps,
				notificationCount,
				pageType,
				parameters,
				wideMode,
				currentAppPage,
				true,
				luaAddFriendsPageEnabled,
				androidBackButtonHandlerDisabled,
				v7
			)
		}

		local createElement2 = Roact.createElement
		local v10 = {
			BorderSizePixel = 0,
			BackgroundColor3 = self.props.BackgroundColor,
			BackgroundTransparency = self.props.BackgroundTransparency,
			useFullScalePage = self.props.useFullScalePage,
			includeStatusBar = true,
			includeBottomBar = not (fFlagCentralOverlayExcludeDeviceSafePadding and SharedFlags.FFlagExtendScrollingFramesBySafeInsets and module22.getScrollAwayEnabled() and module23[module.Chat].enableScrollAway) and self.props.navBarPlacement == module22.Placement.Bottom and self.props.bottomBarVisible ~= false
		}
		local v12 = {
			ChatEventReceiver = Roact.createElement(module9, {
				robloxEventReceiver = self._robloxEventReceiver,
				rnBypassActionSignal = self._rnBypassActionSignal,
				initRoactChatNavigation = initRoactChatNavigation,
				activeConversationId = self.state.activeConversationId
			}),
			SocialTab = self.renderOnLoaded(),
			SquadAppChatEventReceiver = 0
		}

		local v13 = if fFlagSquadAppChatRTNFix then Roact.createElement(squadAppChatEventReceiver) else nil
		v12.SquadAppChatEventReceiver = v13
		return createElement(provider, v5, {
			SocialTab = createElement2(module10, v10, v12)
		})
	end)
end

function extended.didMount(p2)
	logger:info("Initializing SocialTabUniversalAppWrapper")
end

function extended:didUpdate(p2, p3)
	if p2.isVisible ~= self.props.isVisible then
		self.androidBackButtonConnection.disconnect()

		if p2.isVisible then
			self._performanceTesting:Stop()
			self.props.setThrottleFramerateEnabled(false)
		else
			self._performanceTesting:Initialize()
			self.props.setThrottleFramerateEnabled(module4.General.PerformanceTestingMode == Enum.VirtualInputMode.None)
		end
	end
end

function extended.getDerivedStateFromProps(p2, p3)
	local v5 = p2.isVisible and true or nil

	return {
		wasChatEverTapped = p3.wasChatEverTapped == false and p2.isVisible == true or nil,
		wasEverVisible = v5
	}
end

function extended.willUnmount(p2)
	p2.androidBackButtonConnection.disconnect()
end

local v5 = module24((universalAppPolicy.connect(function(data)
	local v6 = {
		isContactImporterPolicyEnabled = data.getContactImporterEnabled(),
		shouldSystemBarUsuallyBePresent = data.getShouldSystemBarUsuallyBePresent(),
		useLuafiedReportFlow = 0,
		shouldShowPushUpsell = 0,
		notificationsCanReceivePush = 0
	}
	local v7 = if getFFlagLuafiedReportEntryPoints() then data.getUseLuafiedReportFlow() else nil
	v6.useLuafiedReportFlow = v7
	v6.shouldShowPushUpsell = data.getPushNotificationsUpsell()
	v6.notificationsCanReceivePush = data.getNotificationsCanReceivePush()
	return v6
end)(extended)))

local v6 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.SocialFriendsLayer, appUserLayers.PushNotificationPrompt },
	function(p2, p3)
		local v7 = p2[appUserLayers.SocialFriendsLayer] or {}
		local v8 = p2[appUserLayers.PushNotificationPrompt] or {}
		local fStringPushUpsellVariantName = getFStringPushUpsellVariantName()
		return {
			luaAddFriendsPageEnabled = v7.show_lua_add_friends_page == "True",
			pushUpsellVariant = getFFlagEnablePushNotificationsUpsellModal() and (v8[fStringPushUpsellVariantName] or -1) or nil
		}
	end
)(v5)

local function SocialTabUniversalAppWrapperContainer(p2)
	local v7 = useNavBarPlacement()

	local v8 = useAppPolicy(function(p3)
		return p3.getStickyShortcutBarEnabled()
	end)
	local v9

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v9 = useSignalState(getShortcutBarStatusStore(false).getShortcutBarVisible)
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v8 = v8 or v9
	end

	return createElement(v6, join(p2, { navBarPlacement = v7, useFullScalePage = v8 }))
end

return SocialTabUniversalAppWrapperContainer
