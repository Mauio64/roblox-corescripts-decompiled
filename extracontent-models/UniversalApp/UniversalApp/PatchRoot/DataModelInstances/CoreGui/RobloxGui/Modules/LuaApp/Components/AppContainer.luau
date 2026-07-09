local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local memoize = require(Modules.Common.memoize)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Constants = require(Modules.LuaApp.Constants)
local LuaAppEvents = require(Modules.LuaApp.LuaAppEvents)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local withStyle = UIBlox.Core.Style.withStyle
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local NavigationRodux = require(CorePackages.Workspace.Packages.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local useOverlay = require(CorePackages.Packages.Foundation).Hooks.useOverlay
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local ToastV2 = require(Modules.LuaApp.Components.ToastV2)
local CentralOverlay = require(Modules.LuaApp.Components.CentralOverlay)
local AppNavContainer = require(Modules.LuaApp.Components.AppNav.AppNavContainer)
local AppSystemBar = require(Modules.LuaApp.Components.AppNav.AppSystemBar)
local AppTopBannerContainer = require(Modules.LuaApp.Components.AppTopBannerContainer)
local BadgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalyticsBottomBar = require(Modules.LuaApp.Services.RoactAnalyticsBottomBar)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local partyTabBadgeImpression = require(Modules.LuaApp.Analytics.Events.partyTabBadgeImpression)
local partyTabBadgeClick = require(Modules.LuaApp.Analytics.Events.partyTabBadgeClick)
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local SystemBarVisibility = require(Modules.LuaApp.Enum.SystemBarVisibility)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AppPage = require(Modules.LuaApp.AppPage)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AppChatNetworking = require(CorePackages.Workspace.Packages.AppChatNetworking)
local FullscreenTitleBar = require(Modules.LuaApp.Components.FullscreenTitleBar)
local GamepadBottomBar = require(Modules.AvatarExperience.Common.Components.GamepadBottomBar)
local withIsGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).withIsGamepadInput
local RootNavigator = require(Modules.LuaApp.Navigation.RootNavigator)
local VrCompatibility = require(CorePackages.Workspace.Packages.VrCompatibility)
local VRReadyWrapper = VrCompatibility.VRReadyWrapper
local VRConstants = VrCompatibility.VRConstants
local VRPanelWidthIXP = VrCompatibility.VRPanelWidthIXP
local RouterAnalyticsReporterForRoactNav = require(Modules.LuaApp.Components.Analytics.RouterAnalyticsReporterForRoactNav)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local SetTabBarVisible = require(CorePackages.Workspace.Packages.AppTabBarRodux).Actions.SetTabBarVisible
local useGamepadBumperNavigationBindings = require(CorePackages.Workspace.Packages.BumperNavigation).useGamepadBumperNavigationBindings
local EnteredChatFromEntryPoint = require(CorePackages.Workspace.Packages.AppChat.EnteredChatFromEntryPoint)
local ChatEntryPointNames = require(CorePackages.Workspace.Packages.SocialCommon).Enums.ChatEntryPointNames
local NavigateToRoute = require(Modules.LuaApp.Thunks.NavigateToRoute)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v60 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local SetNavigationLocked = require(Modules.LuaApp.Thunks.SetNavigationLocked)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local SetPlatform = require(Modules.LuaApp.Actions.SetPlatform)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local VRAppPointer = require(Modules.LuaApp.Components.CrossPlatformCompatibility.VRAppPointer)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GetIABottomBarItems = require(Modules.LuaApp.Components.AppNav.GetIABottomBarItems)
local AppToastNotificationContainer = require(CorePackages.Workspace.Packages.ToastNotification).AppToastNotificationContainer
local AppLoadingSplashScreen = require(Modules.LuaApp.Components.Common.AppLoadingSplashScreen)
local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModal = GameInvite.GameInviteModal
local GameInviteConstants = GameInvite.GameInviteConstants
local ShellEventsContainer = require(Modules.LuaApp.Components.Shell.ShellEventsContainer)
local AppShortcutBar = require(CorePackages.Workspace.Packages.AppShortcutBar)
local AppShortcutBarContainer = AppShortcutBar.AppShortcutBarContainer
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local HardwareSafeAreaInsets = Responsive.HardwareSafeAreaInsets
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local CatalogTilesLatencyTracker = require(Modules.AvatarExperience.Catalog.Actions.CatalogTilesLatencyTracker)
local AvatarExperienceTTIPerformance = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance)
local TTIPerformanceManager = AvatarExperienceTTIPerformance.TTIPerformanceManager
local WidgetsPercievedTTIManager = AvatarExperienceTTIPerformance.WidgetsPercievedTTIManager
local AppMusicPlayer = require(CorePackages.Workspace.Packages.AppMusicPlayer)
local sendBuildExperienceEvent = require(CorePackages.Workspace.Packages.BuildExperience.sendBuildExperienceEvent)
local NativeCloseEventConnector = require(Modules.LuaApp.Components.NativeCloseEventConnector)
local CheckSystemTrayModal = require(Modules.LuaApp.Thunks.CheckSystemTrayModal)
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local v97 = if not FFlagEnableLeftNavOnConsole then nil else require(CorePackages.Workspace.Packages.TenFootUiShell).TenFootUiGlobalEffects
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local FFlagSignalsNavP3bTopBar = SharedFlags.FFlagSignalsNavP3bTopBar
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagAppChatRenameGuacPolicyEnabled = SharedFlags.FFlagAppChatRenameGuacPolicyEnabled
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v104 = if not FFlagSignalsNavP3bTopBar then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local v105 = game:DefineFastFlag("EnableProgressLoadingAssetsAppContainer", false)
local ProgressLoadingAssetsScreenGui = nil

if v105 then
	ProgressLoadingAssetsScreenGui = require(CorePackages.Workspace.Packages.ProgressLoading).ProgressLoadingAssetsScreenGui
end

local SduiDiscoveryDependencyUpdater = require(CorePackages.Workspace.Packages.ServerDrivenUi).SduiDiscoveryDependencyUpdater
local SduiAvatarExperienceRegister = require(CorePackages.Workspace.Packages.AvatarExperienceServerDrivenUi).SduiAvatarExperienceRegister
local SduiSharedRegister = require(CorePackages.Workspace.Packages.SduiSharedContent).SduiSharedRegister
local SduiSocialRegister = require(CorePackages.Workspace.Packages.SocialServerDrivenUi).SduiSocialRegister
local SduiOpenSearchResultsWithQueryReceiver = require(Modules.LuaApp.Components.Search.SduiOpenSearchResultsWithQueryReceiver)
local SduiExperienceStoreRegister = require(CorePackages.Workspace.Packages.ExperienceStoreServerDrivenUi).SduiExperienceStoreRegister
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FlyoutSidePanelWrapper = nil
local FlyoutScrollAwayControl = nil

if FFlagEnableFlyoutSidePanel then
	FlyoutSidePanelWrapper = require(Modules.LuaApp.Components.FlyoutSidePanel.FlyoutSidePanelWrapper)
	FlyoutScrollAwayControl = require(CorePackages.Workspace.Packages.FlyoutSidePanel).FlyoutScrollAwayControl
end

local t1 = {
	GetFFlagUseUpdatedVNGAgreementsWorkflow = SharedFlags.GetFFlagUseUpdatedVNGAgreementsWorkflow,
	GetFFlagEnableAccessBlockAtAppContainerLevel = SharedFlags.GetFFlagEnableAccessBlockAtAppContainerLevel,
	GetFFlagLuaAppFixStudioNotchSupport = require(Modules.LuaApp.Flags.GetFFlagLuaAppFixStudioNotchSupport),
	GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled,
	GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner,
	FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway,
	GetFFlagLuaAppPersistentMusicPlayer = SharedFlags.GetFFlagLuaAppPersistentMusicPlayer,
	FFlagEnableSystemTrayModals = SharedFlags.FFlagEnableSystemTrayModals,
	FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab,
	FFlagEnableAvatarExperienceSdui = SharedFlags.FFlagEnableAvatarExperienceSdui,
	FFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction,
	FFlagLuaAppSduiOpenSearchResultsWithQueryAction = SharedFlags.FFlagLuaAppSduiOpenSearchResultsWithQueryAction,
	FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport,
	FFlagLuaAppUseOverlayInAppContainer = SharedFlags.FFlagLuaAppUseOverlayInAppContainer,
	FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout,
	FFlagLuaAppChartsAppPage = SharedFlags.FFlagLuaAppChartsAppPage,
	FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
}
local v118 = game:DefineFastFlag("LuaAppEnableToastNotifications4", false)
local v119 = game:DefineFastFlag("AXEnablePercievedTTIForAX", false)
local v120 = game:DefineFastInt("PartyTabBadgeMaxCount", 49)
local v121 = SharedFlags.FFlagLuaAppUseDeviceSafeInsetsForAppContainer and t1.GetFFlagLuaAppFixStudioNotchSupport()
local FFlagFixNavigationInsetsOnHiddenTabBar = SharedFlags.FFlagFixNavigationInsetsOnHiddenTabBar
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local FFlagAXFixTryOnItemVR = AvatarExperienceFlags.FFlagAXFixTryOnItemVR
local FFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local FFlagAppDebugPanel = SharedFlags.FFlagAppDebugPanel
local FFlagAppDebugTagAnnotation = SharedFlags.FFlagAppDebugTagAnnotation
local FFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local DebugPanel = nil
local AppDebug = nil

if FFlagAppDebugPanel then
	DebugPanel = require(CorePackages.Workspace.Packages.DebugPanel).DebugPanel

	if FFlagAppDebugTagAnnotation then
		AppDebug = require(CorePackages.Workspace.Packages.AppDebug)
	end
end

local v134 = game:DefineFastFlag("AppNavAppContainerBottomBarIndexFromNav", false)
local v135 = game:DefineFastFlag("AppNavAppContainerCurrentPageFromNav", false)

local function getDevicePlatform() -- line: 203
	-- upvalues: UserInputService (copy)
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Enum.Platform.None
	end

	return UserInputService:GetPlatform()
end

local v137 = getDevicePlatform()
local v138 = GuiService:IsTenFootInterface() and not FFlagEnableLeftNavOnConsole
local u139, u140 = GetIABottomBarItems()
local v141 = Roact.Component:extend("AppContainer")

function v141.init(p1) -- line: 219
	-- upvalues: Logger (copy), SetPlatform (copy), v137 (copy), v135 (copy), v134 (copy), t1 (copy), AppPage (copy), LuaAppEvents (copy), NavigationRodux (copy), FFlagLuaAppsDefaultSelection (copy), v138 (copy), AvatarScreen (copy), v119 (copy), CatalogTilesLatencyTracker (copy), FFlagAXMoveAllTabToWidgetOnly (copy), WidgetsPercievedTTIManager (copy), TTIPerformanceManager (copy), FFlagAppNavMyStatsTab (copy), sendBuildExperienceEvent (copy), ChatEntryPointNames (copy), partyTabBadgeClick (copy), AppChatNetworking (copy), AppNavBar (copy), memoize (copy), Constants (copy)
	p1.props.loggingProtocol:logEventOnce("app_container_init_begin")
	Logger:info("Initializing App Container")

	local store = p1.props.store
	local bottomBarAnalytics = p1.props.bottomBarAnalytics

	store:dispatch(SetPlatform(v137))

	function p1.bottomBarButtonActivated(p2, p3) -- line: 229
		-- upvalues: v135 (copy), p1 (copy), v134 (copy), t1 (copy), AppPage (copy), LuaAppEvents (copy), NavigationRodux (copy), FFlagLuaAppsDefaultSelection (copy), v138 (copy), AvatarScreen (copy), v119 (copy), store (copy), CatalogTilesLatencyTracker (copy), FFlagAXMoveAllTabToWidgetOnly (copy), WidgetsPercievedTTIManager (copy), TTIPerformanceManager (copy), FFlagAppNavMyStatsTab (copy), sendBuildExperienceEvent (copy), ChatEntryPointNames (copy), partyTabBadgeClick (copy), AppChatNetworking (copy), Logger (copy), AppNavBar (copy), bottomBarAnalytics (copy)
		local v227 = if not v135 then p1.props.currentPage else p1:getCurrentPage()
		local v228 = if not v134 then p1.props.selectedBottomBarItemIndex else p1:getSelectedBottomBarItemIndex()

		if not v228 then
			return
		end

		local page = p1.props.bottomBarItems[v228].page

		if t1.FFlagMomentsWatchSessionalization and p2 == AppPage.Moments then
			if p2 ~= page then
				p1.props.navigateToPage(p2)

				if p3 then
					p1.props.notificationService:ActionTaken(p3)
				end
			end
		elseif p2 == v227 then
			LuaAppEvents.ReloadPage:fire(p2)
		elseif t1.FFlagAppIaHomeSubTab and p2 == NavigationRodux.Constants.HomeContainerName then
			if v227 == AppPage.Home then
				LuaAppEvents.ReloadPage:fire(AppPage.Home)
			else
				p1.props.navigateToPage(AppPage.Home)

				if p3 then
					p1.props.notificationService:ActionTaken(p3)
				end
			end
		elseif p2 == AppPage.AvatarExperienceRoot then
			local v230 = if not FFlagLuaAppsDefaultSelection then if not v138 then AvatarScreen.Catalog else AppPage.AvatarExperienceRoot else AppPage.AvatarExperienceRoot

			if v119 then
				store:dispatch(CatalogTilesLatencyTracker.PercievedTrackingStarted())

				if FFlagAXMoveAllTabToWidgetOnly then
					WidgetsPercievedTTIManager.startPerceivedTracking()
				else
					TTIPerformanceManager.Surface.Marketplace.Root.startPerceivedTracking()
				end
			end

			p1.props.navigateToPage(v230)

			if p3 then
				p1.props.notificationService:ActionTaken(p3)
			end
		elseif FFlagAppNavMyStatsTab and p2 == AppPage.MyStats then
			sendBuildExperienceEvent("TAB_CLICK", {})
			p1.props.navigateToPage(p2)

			if p3 then
				p1.props.notificationService:ActionTaken(p3)
			end
		elseif p2 == AppPage.Chat then
			p1.props.enteredChatFromEntryPoint(ChatEntryPointNames.SystemBar)
			partyTabBadgeClick(p1.props.analytics.EventStream, "AppContainer", p1.props.chatBadgeCount)
			store:dispatch(AppChatNetworking.rodux.ClearGlobalUnreadCount.API()):catch(function(p4) -- line: 295
				-- upvalues: Logger (copy)
				Logger:error("Error in ClearGlobalUnreadCount request. Error: {}", (tostring(p4)))
			end)
			p1.props.navigateToPage(p2)

			if p3 then
				p1.props.notificationService:ActionTaken(p3)
			end
		else
			p1.props.navigateToPage(p2)

			if p3 then
				p1.props.notificationService:ActionTaken(p3)
			end
		end

		if p2 ~= page then
			AppNavBar.AppNavTelemetry.logSwitchTabStart(page, p2)
		end

		bottomBarAnalytics.ButtonActivated(p2, page)
	end

	p1.getBottomBarLayoutInfo = memoize(function(vector2: Vector2, p5, _) -- line: 315
		-- upvalues: Constants (copy)
		local v234 = math.max(vector2.X - p5.left - p5.right - 600, 0)
		local BOTTOM_BAR_SIZE = Constants.BOTTOM_BAR_SIZE
		local v236 = math.max(p5.bottom - BOTTOM_BAR_SIZE, 0)

		return {
			Background = {
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, -p5.left, 1, 0),
				Size = UDim2.new(0, vector2.X, 0, p5.bottom)
			},
			Padding = {
				PaddingLeft = UDim.new(0, p5.left + v234 / 2),
				PaddingRight = UDim.new(0, p5.right + v234 / 2),
				PaddingBottom = UDim.new(0, v236)
			}
		}
	end)
	p1.props.loggingProtocol:logEventOnce("app_container_init_end")
end
function v141.didMount(p7) -- line: 339
	-- upvalues: SetNavigationLocked (copy), FFlagAppDebugPanel (copy), FFlagAppDebugTagAnnotation (copy), AppDebug (ref), t1 (copy)
	p7.props.store:dispatch(SetNavigationLocked(false))

	if FFlagAppDebugPanel and FFlagAppDebugTagAnnotation then
		AppDebug.register()
	end

	if t1.GetFFlagEnableAccessBlockAtAppContainerLevel() and (p7.props.userLoggedIn and p7.props.policyShouldBlockUAppAccess) then
		p7.props.resetNavigationHistoryToBlockPage()
	end
end
function v141.willUpdate_DEPRECATED(p8, p9) -- line: 359
	-- upvalues: AppPageProperties (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), SystemBarVisibility (copy), t1 (copy), AppNavBar (copy), VisibilityControl (copy), FFlagEnableFlyoutSidePanel (copy), FlyoutScrollAwayControl (ref), FFlagAppIaScrollAwayPinHeader (copy), FFlagAppIaScopedScrollAway (copy)
	local v155 = AppPageProperties[p9.currentPage] or {}
	local tabBarVisibility = p9.tabBarVisibility

	if typeof(tabBarVisibility) == "function" then
		tabBarVisibility = tabBarVisibility({
			formFactor = p9.formFactor,
			screenSize = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else p9.screenSize,
			deviceOrientation = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else p9.deviceOrientation
		})
	end

	local v157 = if tabBarVisibility ~= SystemBarVisibility.PolicyDependent then tabBarVisibility ~= SystemBarVisibility.Hidden else p8.props.shouldSystemBarUsuallyBePresent

	if not v155.overridesAppRouterTabBarControl and v157 ~= p9.bottomBarVisible then
		p8.props.setTabBarVisible(v157)
	end

	if t1.FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
		local v158 = if not v155.overridesAppRouterTabBarControl then v157 else p9.bottomBarVisible
		local v159 = v155.enableScrollAway and v158

		if p9.currentPage ~= p8.props.currentPage then
			VisibilityControl.show()
		elseif v158 and v159 ~= VisibilityControl.isEnabled() then
			VisibilityControl.show()
		end

		if FFlagEnableFlyoutSidePanel then
			FlyoutScrollAwayControl.setScrollAwayEnabled(v159)
		else
			VisibilityControl.setEnabled(v159)
		end

		if FFlagAppIaScrollAwayPinHeader then
			VisibilityControl.setHeaderScrollAwayDisabled(v155.disableHeaderScrollAway)
		end

		if FFlagAppIaScopedScrollAway then
			VisibilityControl.setGlobalTouchEnabled(not v155.disableGlobalScrollAwayTouch)
		end
	end
end

if not v135 then
	function v141.willUpdate(p10, p11) -- line: 417
		p10:willUpdate_DEPRECATED(p11)
	end
end

function v141.didUpdate(p12, p13, _) -- line: 422
	-- upvalues: v135 (copy), AppPageProperties (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), SystemBarVisibility (copy), t1 (copy), AppNavBar (copy), VisibilityControl (copy), FFlagEnableFlyoutSidePanel (copy), FlyoutScrollAwayControl (ref), FFlagAppIaScrollAwayPinHeader (copy), FFlagAppIaScopedScrollAway (copy), AppPage (copy)
	if v135 then
		local v165 = p12:getCurrentPage()
		local v166 = p12:getCurrentPage(p13)
		local v167 = AppPageProperties[v165] or {}
		local tabBarVisibility = p12.props.tabBarVisibility

		if typeof(tabBarVisibility) == "function" then
			tabBarVisibility = tabBarVisibility({
				formFactor = p12.props.formFactor,
				screenSize = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else p12.props.screenSize,
				deviceOrientation = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else p12.props.deviceOrientation
			})
		end

		local v169 = if tabBarVisibility ~= SystemBarVisibility.PolicyDependent then tabBarVisibility ~= SystemBarVisibility.Hidden else p12.props.shouldSystemBarUsuallyBePresent

		if not v167.overridesAppRouterTabBarControl and v169 ~= p12.props.bottomBarVisible then
			p12.props.setTabBarVisible(v169)
		end

		if t1.FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
			local v170 = if not v167.overridesAppRouterTabBarControl then v169 else p12.props.bottomBarVisible
			local v171 = v167.enableScrollAway and v170

			if v165 ~= v166 then
				VisibilityControl.show()
			elseif v170 and v171 ~= VisibilityControl.isEnabled() then
				VisibilityControl.show()
			end

			if FFlagEnableFlyoutSidePanel then
				FlyoutScrollAwayControl.setScrollAwayEnabled(v171)
			else
				VisibilityControl.setEnabled(v171)
			end

			if FFlagAppIaScrollAwayPinHeader then
				VisibilityControl.setHeaderScrollAwayDisabled(v167.disableHeaderScrollAway)
			end

			if FFlagAppIaScopedScrollAway then
				VisibilityControl.setGlobalTouchEnabled(not v167.disableGlobalScrollAwayTouch)
			end
		end
	end

	if p12.props.userLoggedIn and p12.props.appPolicy.getVNGFormRequired() and not t1.GetFFlagUseUpdatedVNGAgreementsWorkflow() then
		p12.props.showVngForm()
	end

	if t1.GetFFlagEnableAccessBlockAtAppContainerLevel() then
		local v172 = p12.props.policyShouldBlockUAppAccess and p12.props.userLoggedIn
		local v173 = ((if not v135 then p12.props.currentPage else p12:getCurrentPage())) == AppPage.UAppBlock

		if v172 and not v173 then
			p12.props.resetNavigationHistoryToBlockPage()
		end
	end
end
function v141.render(p15) -- line: 502
	-- upvalues: v134 (copy), v135 (copy), v138 (copy), Roact (copy), VRAppPointer (copy), HardwareSafeAreaInsets (copy), withStyle (copy), v121 (copy), t1 (copy), Responsive (copy), AppPage (copy), FFlagEnableLeftNavOnConsole (copy), AppNavBar (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAddGamepadBumperNavigation (copy), AppNavContainer (copy), FFlagFixNavigationInsetsOnHiddenTabBar (copy), RootNavigator (copy), AppMusicPlayer (copy), AppSystemBar (copy), Constants (copy), RouterAnalyticsReporterForRoactNav (copy), AppShortcutBarContext (copy), AppShortcutBarContainer (copy), NativeCloseEventConnector (copy), CheckSystemTrayModal (copy), v97 (copy), VRReadyWrapper (copy), VRConstants (copy), IsVRAppBuild (copy), FFlagAXFixTryOnItemVR (copy), CoreGui (copy), ToastV2 (copy), v118 (copy), AppToastNotificationContainer (copy), GameInviteModal (copy), GameInviteConstants (copy), CentralOverlay (copy), GamepadBottomBar (copy), AppTopBannerContainer (copy), FFlagEnableFlyoutSidePanel (copy), FlyoutSidePanelWrapper (ref), FullscreenTitleBar (copy), AppLoadingSplashScreen (copy), ShellEventsContainer (copy), v105 (copy), ProgressLoadingAssetsScreenGui (ref), SduiDiscoveryDependencyUpdater (copy), SduiAvatarExperienceRegister (copy), SduiSharedRegister (copy), SduiSocialRegister (copy), SduiOpenSearchResultsWithQueryReceiver (copy), SduiExperienceStoreRegister (copy), FFlagAppDebugPanel (copy), DebugPanel (ref)
	local screenSize = p15.props.screenSize
	local globalGuiInset = p15.props.globalGuiInset
	local bottomBarVisible = p15.props.bottomBarVisible
	local v178 = if not v134 then p15.props.selectedBottomBarItemIndex else p15:getSelectedBottomBarItemIndex()
	local v179 = if not v135 then p15.props.currentPage else p15:getCurrentPage()
	local bottomBarItems = p15.props.bottomBarItems
	local isGamepadInput = p15.props.isGamepadInput
	local v182 = v138 and isGamepadInput
	local v183 = Roact.createElement(VRAppPointer)
	local v184 = HardwareSafeAreaInsets.deviceInsets()
	local v185 = withStyle(function(p16) -- line: 525
		-- upvalues: v121 (copy), t1 (copy), Roact (copy), globalGuiInset (copy), v184 (copy), p15 (copy), Responsive (copy), AppPage (copy), FFlagEnableLeftNavOnConsole (copy), AppNavBar (copy), bottomBarVisible (copy), screenSize (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagAddGamepadBumperNavigation (copy), AppNavContainer (copy), FFlagFixNavigationInsetsOnHiddenTabBar (copy), RootNavigator (copy), AppMusicPlayer (copy), AppSystemBar (copy), Constants (copy), v178 (copy), bottomBarItems (copy), RouterAnalyticsReporterForRoactNav (copy), AppShortcutBarContext (copy), AppShortcutBarContainer (copy), NativeCloseEventConnector (copy), CheckSystemTrayModal (copy), v97 (copy), VRReadyWrapper (copy), VRConstants (copy), IsVRAppBuild (copy), v179 (copy), FFlagAXFixTryOnItemVR (copy)
		local v238 = nil

		if not v121 and t1.GetFFlagLuaAppFixStudioNotchSupport() then
			v238 = Roact.createElement("UIPadding", {
				PaddingTop = if not t1.GetFFlagLuaAppEnableTopBanner() then nil else UDim.new(0, globalGuiInset.top),
				PaddingBottom = UDim.new(0, globalGuiInset.bottom),
				PaddingLeft = UDim.new(0, globalGuiInset.left)
			})
		end

		local v239 = v121 and ((v184.top > 0 or (v184.bottom > 0 or (v184.left > 0 or (v184.right > 0 or p15.props.usePreferredInput == Responsive.Input.Touch)))) and (p15.props.currentPage ~= AppPage.AvatarExperienceRoot or FFlagEnableLeftNavOnConsole and p15.props.navBarPlacement == AppNavBar.Placement.Left))
		local v240 = if not FFlagEnableLeftNavOnConsole then UDim2.new(0, screenSize.X + v184.left + v184.right, 0, screenSize.Y + v184.top + v184.bottom) else if bottomBarVisible then if p15.props.currentPage ~= AppPage.AvatarExperienceRoot then UDim2.fromOffset(screenSize.X + v184.left + v184.right, screenSize.Y + v184.top + v184.bottom) else UDim2.fromOffset(v184.left + p15.props.navBarSize, screenSize.Y + v184.top + v184.bottom) else UDim2.fromOffset(0, 0)
		local t2 = {
			RNAppContainer = Roact.createElement(FocusNavigableSurfaceWrapper, {
				shouldRestoreFocus = false,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
				customEventMap = if not FFlagAddGamepadBumperNavigation then nil else p15.props.bumperNavigationEventMap,
				customEventHandlers = if not FFlagAddGamepadBumperNavigation then nil else p15.props.bumperNavigationEventHandlerMap
			}, Roact.createElement(AppNavContainer, if not FFlagFixNavigationInsetsOnHiddenTabBar then nil else {
				isTabBarVisible = bottomBarVisible
			}, {
				RootNavigator = Roact.createElement(RootNavigator, {
					navigation = p15.props.navigation
				})
			})),
			MusicPlayer = if not t1.GetFFlagLuaAppPersistentMusicPlayer() then nil else Roact.createElement(AppMusicPlayer.AppMusicPlayer),
			SystemBar = Roact.createElement(AppSystemBar, {
				isVisible = bottomBarVisible,
				displayOrder = Constants.DisplayOrder.SystemBar,
				layoutInfo = p15.getBottomBarLayoutInfo(screenSize, globalGuiInset),
				selectedIndex = v178,
				items = bottomBarItems,
				onActivated = p15.bottomBarButtonActivated,
				customEventMap = if not FFlagAddGamepadBumperNavigation then nil else p15.props.bumperNavigationEventMap,
				customEventHandlers = if not FFlagAddGamepadBumperNavigation then nil else p15.props.bumperNavigationEventHandlerMap,
				isBumperNavigationEnabled = if not FFlagAddGamepadBumperNavigation then nil else p15.props.isBumperNavigationEnabled
			}),
			Reporter = Roact.createElement(RouterAnalyticsReporterForRoactNav),
			SafePadding = v238,
			AppShortcutBar = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				ShortcutBarContext = Roact.createElement(AppShortcutBarContext.Provider, {}, {
					ShortcutBar = Roact.createElement(AppShortcutBarContainer)
				})
			}),
			NativeCloseEventConnector = if not t1.FFlagEnableSystemTrayModals then nil else Roact.createElement(NativeCloseEventConnector, {
				onNativeCloseEvent = CheckSystemTrayModal
			}),
			TenFootUiGlobalEffects = if not FFlagEnableLeftNavOnConsole then nil else Roact.createElement(v97),
			DeviceInsetBackground = if not v239 then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				Position = UDim2.new(0, -v184.left, 0, -v184.top),
				Size = v240,
				BackgroundColor3 = p16.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p16.Theme.BackgroundDefault.Transparency
			})
		}
		local v242 = nil

		if t1.GetFFlagLuaAppFixStudioNotchSupport() then
			v242 = if not v121 then Enum.ScreenInsets.None else Enum.ScreenInsets.DeviceSafeInsets
		end

		return Roact.createElement(VRReadyWrapper, {
			component = "ScreenGui",
			props = {
				Enabled = true,
				DisplayOrder = 1,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ScreenInsets = v242,
				ClipToDeviceSafeArea = not v121 and nil
			},
			vrProps = {
				panelName = "MainAppScreen",
				partSize = if t1.FFlagLuaAppForceVrAppPanelWidthRollout or not p15.props.vrPanelWidthMultiplier then VRConstants.MainScreenSize else Vector2.new(VRConstants.MainScreenSize.X * p15.props.vrPanelWidthMultiplier, VRConstants.MainScreenSize.Y),
				offset = if not t1.FFlagLuaAppForceVrAppPanelWidthRollout and (not t1.GetFFlagVRPanelWidthIXPEnabled() or p15.props.vrPanelCurvature ~= 0) then CFrame.lookAt(VRConstants.MainScreenPosition, VRConstants.DefaultCameraPosition) else CFrame.new(VRConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = if t1.FFlagLuaAppForceVrAppPanelWidthRollout or not p15.props.vrPanelWidthMultiplier then VRConstants.MainScreenResolution else Vector2.new(VRConstants.MainScreenResolution.X * p15.props.vrPanelWidthMultiplier, VRConstants.MainScreenResolution.Y),
				curvature = if t1.FFlagLuaAppForceVrAppPanelWidthRollout or not p15.props.vrPanelCurvature then VRConstants.MainScreenCurvature else p15.props.vrPanelCurvature,
				hidden = IsVRAppBuild() and (v179 == AppPage.AvatarExperienceRoot or FFlagAXFixTryOnItemVR and v179 == AppPage.AvatarExperienceWrapper),
				roundedCornersFrameColor = p16.Theme.BackgroundDefault.Color
			}
		}, t2)
	end)
	local v186 = Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		LuaAppScreenGui = v185
	})
	local t3 = {
		Toast = Roact.createElement(ToastV2, {
			displayOrder = Constants.DisplayOrder.Toast
		}),
		ToastNotification = if not v118 then nil else Roact.createElement(AppToastNotificationContainer, {
			displayOrder = Constants.DisplayOrder.Toast
		}),
		GameInviteModal = Roact.createElement(GameInviteModal, {
			displayOrder = Constants.DisplayOrder.GameInviteModal,
			renderLocation = GameInviteConstants.RenderLocation.UniversalApp
		}),
		CentralOverlay = Roact.createElement(CentralOverlay, {
			includeStatusBar = bottomBarVisible,
			displayOrder = Constants.DisplayOrder.CentralOverlay
		}),
		GamepadBottomBar = v182 and Roact.createElement(GamepadBottomBar, {
			displayOrder = Constants.DisplayOrder.GamepadBottomBar
		}),
		RNBypassTree = v186,
		TopBanner = if not t1.GetFFlagLuaAppEnableTopBanner() then nil else Roact.createElement(AppTopBannerContainer, {
			displayOrder = Constants.DisplayOrder.TopBanner
		}),
		FlyoutSidePanel = if not FFlagEnableFlyoutSidePanel then nil else Roact.createElement(FlyoutSidePanelWrapper, {
			displayOrder = Constants.DisplayOrder.FlyoutSidePanel
		}),
		FullscreenTitleBar = Roact.createElement(FullscreenTitleBar, {
			displayOrder = Constants.DisplayOrder.FullscreenTitleBar
		}),
		VRPointer = if not p15.props.use3DPanels then nil else v183,
		AppLoadingSplashScreen = Roact.createElement(AppLoadingSplashScreen),
		ShellEventsContainer = Roact.createElement(ShellEventsContainer, {
			currentPage = v179
		}),
		ProgressLoadingAssetsScreenGui = if not v105 then nil else Roact.createElement(ProgressLoadingAssetsScreenGui, {
			displayOrder = Constants.DisplayOrder.ProgressLoadingAssets
		}),
		SduiDiscoveryDependencyUpdater = Roact.createElement(SduiDiscoveryDependencyUpdater),
		SduiAvatarExperienceRegister = if not t1.FFlagEnableAvatarExperienceSdui then nil else Roact.createElement(SduiAvatarExperienceRegister),
		SduiSharedRegister = Roact.createElement(SduiSharedRegister),
		SduiSocialRegister = if not t1.FFlagSduiRequestFriendshipAction then nil else Roact.createElement(SduiSocialRegister),
		SduiOpenSearchResultsWithQueryReceiver = if not t1.FFlagLuaAppSduiOpenSearchResultsWithQueryAction then nil else Roact.createElement(SduiOpenSearchResultsWithQueryReceiver),
		SduiExperienceStoreRegister = if not t1.FFlagSduiDevStoreSeeAllSupport then nil else Roact.createElement(SduiExperienceStoreRegister),
		DebugPanel = if not FFlagAppDebugPanel then nil else Roact.createElement(DebugPanel)
	}

	return Roact.createElement("Folder", {}, t3)
end
function v141.getSelectedBottomBarItemIndex(p17) -- line: 774
	-- upvalues: AppNavBar (copy), u140 (ref)
	local navigation = p17.props.navigation

	if navigation and navigation.state then
		local v190 = AppNavBar.getAppNavRootName(navigation.state)

		if v190 then
			return u140[v190]
		end
	end

	return nil
end
function v141.getCurrentPage(p18, p19) -- line: 785
	-- upvalues: AppNavBar (copy)
	local navigation = (p19 or p18.props).navigation

	if navigation and navigation.state then
		return AppNavBar.getAppNavCurrentPage(navigation.state)
	end

	return nil
end

local v142 = memoize(function(p20, _, p22, _) -- line: 793
	-- upvalues: u139 (ref), u140 (ref), GetIABottomBarItems (copy), partyTabBadgeImpression (copy), v120 (copy), BadgeVariant (copy), AppPage (copy), Cryo (copy)
	local v198, v199 = GetIABottomBarItems()

	u139 = v198
	u140 = v199

	local Alert = nil

	if typeof(p20) == "number" and p20 > 0 then
		if p22 and p22.EventStream then
			partyTabBadgeImpression(p22.EventStream, "AppContainer", p20)
		end

		p20 = if not (p20 > v120) then tostring(p20) else tostring(v120) .. "+"
		Alert = BadgeVariant.Alert
	end

	local v201 = u139
	local v202 = u140[AppPage.Chat]

	if v202 ~= nil then
		v201 = Cryo.List.join(u139)
		v201[v202].badgeCount = p20
		v201[v202].badgeVariant = Alert
	end

	return v201
end)

local function computeAppContainerNavPropsFromRouteHistory(p24) -- line: 821
	-- upvalues: AppPageProperties (copy), SystemBarVisibility (copy), v134 (copy), u140 (ref), v135 (copy)
	local v204 = p24[#p24]
	local v205 = (function(p25) -- line: 823
		-- upvalues: AppPageProperties (copy), v204 (copy), SystemBarVisibility (copy)
		for i = #p25, 1, -1 do
			local v245 = AppPageProperties[v204[i].name] or {}

			if v245.tabBarHidden then
				return v245.tabBarHidden
			end
		end

		return SystemBarVisibility.Visible
	end)(v204)

	return {
		selectedBottomBarItemIndex = if not v134 then u140[v204[1].name] else nil,
		currentPage = if not v135 then v204[#v204].name else nil,
		tabBarVisibility = v205
	}
end

local v144 = RoactRodux.connect(function(p26, p27) -- line: 846
	-- upvalues: FFlagSignalsNavP3bTopBar (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), computeAppContainerNavPropsFromRouteHistory (copy), Cryo (copy), v142 (copy), FFlagAppChatRenameGuacPolicyEnabled (copy), LoginStatus (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy)
	local v208 = p26.SocialTab.UnreadConversationCount or 0
	local t4 = {}

	if not FFlagSignalsNavP3bTopBar then
		local v210 = if not FFlagUseNavigationSelectors then p26.Navigation.history else Selectors.selectLegacyHistory(p26)

		t4 = computeAppContainerNavPropsFromRouteHistory(v210)
	end

	return Cryo.Dictionary.join(t4, {
		screenSize = p26.ScreenSize,
		globalGuiInset = p26.GlobalGuiInset,
		bottomBarVisible = p26.TabBarVisible,
		bottomBarItems = v142(v208, p27.canSeeChatTab, p27.analytics, if not FFlagAppChatRenameGuacPolicyEnabled then nil else p27.canSeeChatTerminology),
		chatBadgeCount = v208,
		userLoggedIn = p26.AuthenticationStatus.status == LoginStatus.LOGGED_IN,
		formFactor = p26.FormFactor,
		deviceOrientation = if not FFlagLuaAppEdpKeepFullPageOnPortraitRotation then nil else p26.DeviceOrientation,
		localUserId = p26.LocalUserId
	})
end, function(p28) -- line: 873
	-- upvalues: t1 (copy), AppPage (copy), CorePackages (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), Cryo (copy), NavigateToRoute (copy), ResetNavigationHistory (copy), AppNavBar (copy), SetTabBarVisible (copy), SetCentralOverlay (copy), OverlayType (copy), EnteredChatFromEntryPoint (copy)
	return {
		navigateToPage = function(p29) -- line: 875
			-- upvalues: t1 (copy), AppPage (copy), CorePackages (copy), FFlagSignalsNavP3Dispatch (copy), v60 (copy), Cryo (copy), p28 (copy), NavigateToRoute (copy)
			if t1.FFlagLuaAppChartsAppPage and p29 == AppPage.Games then
				require(CorePackages.Workspace.Packages.Charts).navigateToChartsPage({
					navigate = function(s1: string, t5: {[any]: any}?) -- line: 879
						-- upvalues: FFlagSignalsNavP3Dispatch (copy), v60 (copy), Cryo (copy), p28 (copy), NavigateToRoute (copy)
						if FFlagSignalsNavP3Dispatch then
							v60.to(v60.fromLegacyPage(Cryo.Dictionary.join({
								name = s1
							}, t5 or {})))

							return
						end

						p28(NavigateToRoute({ Cryo.Dictionary.join({
							name = s1
						}, t5 or {}) }))
					end
				})

				return
			end

			if FFlagSignalsNavP3Dispatch then
				v60.to(v60.fromLegacyPage({
					name = p29
				}))

				return
			end

			p28(NavigateToRoute({{
				name = p29
			}}))
		end,
		resetNavigationHistoryToBlockPage = function() -- line: 897
			-- upvalues: p28 (copy), ResetNavigationHistory (copy), AppPage (copy)
			p28(ResetNavigationHistory({{
				name = AppPage.UAppBlock
			}}))
		end,
		setTabBarVisible = function(p30) -- line: 900
			-- upvalues: AppNavBar (copy), p28 (copy), SetTabBarVisible (copy)
			AppNavBar.AppNavTelemetry.logVisibilityStart(p30)
			p28(SetTabBarVisible(p30))
		end,
		showVngForm = function() -- line: 904
			-- upvalues: p28 (copy), SetCentralOverlay (copy), OverlayType (copy)
			p28(SetCentralOverlay(OverlayType.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end,
		enteredChatFromEntryPoint = function(p31) -- line: 909
			-- upvalues: p28 (copy), EnteredChatFromEntryPoint (copy)
			p28(EnteredChatFromEntryPoint(p31))
		end
	}
end)(v141)

if FFlagSignalsNavP3bTopBar then
	v144 = (function(p32) -- line: 916
		-- upvalues: v104 (copy), useSignalState (copy), computeAppContainerNavPropsFromRouteHistory (copy), React (copy), Cryo (copy)
		return function(p33) -- line: 917
			-- upvalues: v104 (copy), useSignalState (copy), computeAppContainerNavPropsFromRouteHistory (copy), React (copy), p32 (copy), Cryo (copy)
			local v250 = v104(false)
			local v251 = useSignalState(v250.getHistory)
			local v252 = computeAppContainerNavPropsFromRouteHistory(v251)

			return React.createElement(p32, Cryo.Dictionary.union(p33, v252))
		end
	end)(v144)
end

local v145 = RoactServices.connect({
	notificationService = AppNotificationService,
	networking = RoactNetworking,
	bottomBarAnalytics = RoactAnalyticsBottomBar,
	analytics = RoactAnalytics,
	loggingProtocol = AppLogging
})(v144)
local v146 = withIsGamepadInput((RoactAppPolicy.connect(function(p34) -- line: 934
	-- upvalues: t1 (copy), UniversalAppPolicy (copy), FFlagAppChatRenameGuacPolicyEnabled (copy)
	return {
		appPolicy = p34,
		policyShouldBlockUAppAccess = if not t1.GetFFlagEnableAccessBlockAtAppContainerLevel() then nil else p34.getEnableUAppAccessBlock() or p34.getEnableHomePageAgeBlock(),
		shouldSystemBarUsuallyBePresent = p34.getShouldSystemBarUsuallyBePresent(),
		canSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab(),
		canSeeChatTerminology = if not FFlagAppChatRenameGuacPolicyEnabled then nil else UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
	}
end)(v145)))
local v147 = RoactNavigation.withNavigation(v146)
local u148 = RoactAppExperiment.connectUserLayer({
	AppUserLayers.SocialFriendsLayer,
	"PlatformExcellence.QualityImprovement.App"
}, function(p35, _) -- line: 955
	-- upvalues: AppUserLayers (copy)
	return {
		luaAddFriendsPageEnabled = (p35[AppUserLayers.SocialFriendsLayer] or {}).show_lua_add_friends_page == "True"
	}
end)(v147)

if not t1.FFlagLuaAppForceVrAppPanelWidthRollout then
	u148 = IxpUtils.connectTestVariables({
		vrPanelWidthMultiplier = VRPanelWidthIXP.VrAppPanelWidthMultiplier,
		vrPanelCurvature = VRPanelWidthIXP.VrAppPanelCurvature
	})(u148)
end

return function(p37) -- line: 969
	-- upvalues: t1 (copy), useOverlay (copy), useIsSpatial (copy), FFlagAddGamepadBumperNavigation (copy), useGamepadBumperNavigationBindings (copy), u139 (ref), FFlagEnableLeftNavOnConsole (copy), useNavBarSize (copy), useNavBarPlacement (copy), Cryo (copy), Roact (copy), u148 (ref)
	if t1.FFlagLuaAppUseOverlayInAppContainer then
		useOverlay()
	end

	local v217 = useIsSpatial()
	local eventMap = nil
	local eventHandlerMap = nil
	local isBumperNavigationEnabled = nil

	if FFlagAddGamepadBumperNavigation then
		local v221 = useGamepadBumperNavigationBindings(u139)

		eventMap = v221.eventMap
		eventHandlerMap = v221.eventHandlerMap
		isBumperNavigationEnabled = v221.isBumperNavigationEnabled
	end

	local v222 = if not FFlagEnableLeftNavOnConsole then nil else useNavBarSize()
	local v223 = if not FFlagEnableLeftNavOnConsole then nil else useNavBarPlacement()
	local v224 = Cryo.Dictionary.join(p37, {
		use3DPanels = v217,
		bumperNavigationEventMap = if not FFlagAddGamepadBumperNavigation then {} else eventMap,
		bumperNavigationEventHandlerMap = if not FFlagAddGamepadBumperNavigation then {} else eventHandlerMap,
		isBumperNavigationEnabled = if not FFlagAddGamepadBumperNavigation then nil else isBumperNavigationEnabled,
		navBarSize = if not FFlagEnableLeftNavOnConsole then nil else v222,
		navBarPlacement = if not FFlagEnableLeftNavOnConsole then nil else v223
	})

	return Roact.createElement(u148, v224)
end
