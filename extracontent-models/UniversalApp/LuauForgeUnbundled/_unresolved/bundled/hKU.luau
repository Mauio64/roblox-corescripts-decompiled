local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/bundled/eer")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/edx")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local withStyle = UIBlox.Core.Style.withStyle
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module4 = require("@luauforge/bundled/eeo")
local focusNavigableSurfaceWrapper = module4.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors
local Foundation = require(CorePackages.Packages.Foundation)
local useOverlay = Foundation.Hooks.useOverlay
local getTokens = Foundation.Utility.getTokens
local appearanceContext = require("@game/CorePackages/Workspace/Packages/Style").AppearanceContext

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module6 = require("@luauforge/bundled/hKV")
local module7 = require("@luauforge/bundled/hKY")
local module8 = require("@luauforge/bundled/hPE")
local module9 = require("@luauforge/bundled/hPF")
local module10 = require("@luauforge/bundled/hRl")
local badgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local module11 = require("@luauforge/bundled/eda")
local module12 = require("@luauforge/bundled/hRp")
local module13 = require("@luauforge/bundled/dYT")
local module14 = require("@luauforge/bundled/hRq")
local module15 = require("@luauforge/bundled/hRr")
local module16 = require("@luauforge/bundled/fBQ")
local module17 = require("@luauforge/bundled/dDF")
local module18 = require("@luauforge/bundled/dCp")
local module19 = require("@luauforge/bundled/hRs")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@luauforge/bundled/hMr").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local module21 = require("@luauforge/bundled/hRt")
local module22 = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Components/FullscreenTitleBar")
local module23 = require("@luauforge/bundled/dCv")
local memo = React.memo(module23)
local module24 = require("@luauforge/bundled/fye")
local vrReadyWrapper = module24.VRReadyWrapper
local vrConstants = module24.VRConstants

local module25 = require("@luauforge/bundled/hRx")
local module26 = require("@luauforge/bundled/dDE")
local setTabBarVisible = require("@luauforge/bundled/dwN").Actions.SetTabBarVisible

local useGamepadBumperNavigationBindings = require("@luauforge/bundled/hQP").useGamepadBumperNavigationBindings
local module27 = require("@luauforge/bundled/hRB")

local module28 = require("@luauforge/bundled/hMc")
local chatEntryPointNames = require("@luauforge/bundled/elx").Enums.ChatEntryPointNames
local module29 = require("@luauforge/bundled/fDv")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module30 = require("@luauforge/bundled/dHr")
local module31 = require("@luauforge/bundled/dHq")
local module32 = require("@luauforge/bundled/hJC")
local fFlagUseSignalsForPlatform = SharedFlags.FFlagUseSignalsForPlatform

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fyv") else nil

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

local module33 = require("@luauforge/bundled/edO")
local module34 = require("@luauforge/bundled/edP")
local module35 = require("@luauforge/bundled/hSw")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module36 = require("@luauforge/bundled/dHt")
local appToastNotificationContainer = require("@luauforge/bundled/hSz").AppToastNotificationContainer
local module37 = require("@luauforge/bundled/hSA")
local module38 = require("@luauforge/bundled/hJs")
local gameInviteModal = module38.GameInviteModal
local gameInviteConstants = module38.GameInviteConstants
local module39 = require("@luauforge/bundled/hSB")
local module40 = require("@luauforge/bundled/eev")
local appShortcutBarContainer = module40.AppShortcutBarContainer
local appShortcutBarContext = module40.AppShortcutBarContext
local stickyShortcutBarExposureLogger = module40.StickyShortcutBarExposureLogger
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useIsSpatial = Responsive.useIsSpatial
local hardwareSafeAreaInsets = Responsive.HardwareSafeAreaInsets
local module42 = require("@luauforge/bundled/dHu")
local visibilityControl = module42.VisibilityControl
local useNavBarSize = module42.useNavBarSize
local useNavBarPlacement = module42.useNavBarPlacement
local module43 = require("@luauforge/bundled/dSV")
local module44 = require("@luauforge/bundled/ggZ")
local ttiPerformanceManager = module44.TTIPerformanceManager
local widgetsPercievedTTIManager = module44.WidgetsPercievedTTIManager
local module45 = require("@luauforge/bundled/dHv")
local module46 = require("@luauforge/bundled/hSD")
local module47 = require("@luauforge/bundled/hSE")
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagUnifyShortcutBarUnifiedIXPExposure = SharedFlags.FFlagUnifyShortcutBarUnifiedIXPExposure
local fFlagLuaAppEnableDeviceInsetBackground = SharedFlags.FFlagLuaAppEnableDeviceInsetBackground
local module48 = require("@luauforge/bundled/hSF")
local hasPageInCurrentRoute = require("@luauforge/bundled/fXq").hasPageInCurrentRoute
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local tenFootUiGlobalEffects = require("@luauforge/bundled/hSI").TenFootUiGlobalEffects
local fFlagAppContainerReadyToRender = SharedFlags.FFlagAppContainerReadyToRender
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module49 = require("@luauforge/bundled/hSY")
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local defineFastFlag = game:DefineFastFlag("EnableProgressLoadingAssetsAppContainer", false)
local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet

local universalShareSheetHost = if fFlagEnableShareSheet then require("@luauforge/bundled/hSZ").UniversalShareSheetHost else nil
local progressLoadingAssetsScreenGui, preGameLoadingScreen, getDeferredAssetStore

if defineFastFlag then
	local module50 = require("@luauforge/bundled/hTa")
	progressLoadingAssetsScreenGui = module50.ProgressLoadingAssetsScreenGui
	preGameLoadingScreen = module50.PreGameLoadingScreen
	getDeferredAssetStore = module50.GetDeferredAssetStore
else
	getDeferredAssetStore = nil
	preGameLoadingScreen = nil
	progressLoadingAssetsScreenGui = nil
end

local function getPregameLoadingScreenOnly(p2)
	local deferredAssetStore = getDeferredAssetStore(p2)

	if deferredAssetStore then
		return deferredAssetStore.getPregameLoadingScreenOnly(p2)
	end

	return false
end

local sduiDiscoveryDependencyUpdater = require("@luauforge/bundled/dAU").SduiDiscoveryDependencyUpdater

local sduiAvatarExperienceRegister = require("@luauforge/bundled/dPP").SduiAvatarExperienceRegister
local sduiGroupsRegister = require("@luauforge/bundled/hTb").SduiGroupsRegister
local sduiSharedRegister = require("@luauforge/bundled/hTw").SduiSharedRegister
local sduiCustomFormsRegister = require("@luauforge/bundled/hTx").SduiCustomFormsRegister
local sduiPromptsRegister = require("@luauforge/bundled/hTy").SduiPromptsRegister

local sduiVerificationUpsellRegister = require("@luauforge/bundled/hTz").SduiVerificationUpsellRegister
local sduiSocialRegister = require("@luauforge/bundled/hTS").SduiSocialRegister
local sduiAdsRegister = require("@luauforge/bundled/hTT").SduiAdsRegister
local sduiUserSettingsRegister = require("@luauforge/bundled/hIR").SduiUserSettingsRegister

local module50 = require("@luauforge/bundled/hUx")

local sduiExperienceStoreRegister = require("@luauforge/bundled/fXn").SduiExperienceStoreRegister
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy")

local module52 = require("@luauforge/bundled/dHC")
local v6, flyoutScrollAwayControl

if module52 then
	v6 = require("@luauforge/bundled/hUy")
	flyoutScrollAwayControl = require("@luauforge/bundled/fsS").FlyoutScrollAwayControl
else
	flyoutScrollAwayControl = nil
	v6 = nil
end

local v7 = {
	GetFFlagUseUpdatedVNGAgreementsWorkflow = SharedFlags.GetFFlagUseUpdatedVNGAgreementsWorkflow,
	GetFFlagEnableAccessBlockAtAppContainerLevel = SharedFlags.GetFFlagEnableAccessBlockAtAppContainerLevel,
	GetFFlagLuaAppEnableTopBanner = SharedFlags.GetFFlagLuaAppEnableTopBanner,
	FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway,
	FFlagEnableSystemTrayModals = SharedFlags.FFlagEnableSystemTrayModals,
	FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab,
	FFlagEnableAvatarExperienceSdui = SharedFlags.FFlagEnableAvatarExperienceSdui,
	FFlagEnableGroupsSdui = SharedFlags.FFlagEnableGroupsSdui,
	FFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction,
	FFlagLuaAppSduiSponsoredTwoByOneTile = SharedFlags.FFlagLuaAppSduiSponsoredTwoByOneTile,
	FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback,
	FFlagSduiPlayWithRewardRefactor = SharedFlags.FFlagSduiPlayWithRewardRefactor,
	FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport,
	FFlagSduiGameItemsComponent = SharedFlags.FFlagSduiGameItemsComponent,
	FFlagLuaAppUseOverlayInAppContainer = SharedFlags.FFlagLuaAppUseOverlayInAppContainer,
	FFlagSduiOpenIncomingTransferUpsellAction = SharedFlags.FFlagSduiOpenIncomingTransferUpsellAction,
	FFlagLuaAppSduiUpdateUserSettingsAction = SharedFlags.FFlagLuaAppSduiUpdateUserSettingsAction,
	FFlagMoveSduiUpdateUserSettingsToAccountManagement = SharedFlags.FFlagMoveSduiUpdateUserSettingsToAccountManagement
}

local defineFastFlag2 = game:DefineFastFlag("LuaAppEnableToastNotifications4", false)

local module53 = require("@luauforge/bundled/hSH")
local defineFastInt = game:DefineFastInt("PartyTabBadgeMaxCount", 49)
local fFlagLuaAppSupportDeviceSafeInsets = SharedFlags.FFlagLuaAppSupportDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dUd").shouldUseDeviceSafeInsets
local fFlagFixNavigationInsetsOnHiddenTabBar = SharedFlags.FFlagFixNavigationInsetsOnHiddenTabBar
local defineFastFlag3 = game:DefineFastFlag("FixScrollAwayNavBarRevealFlicker", false)
local fFlagAXMoveAllTabToWidgetOnly = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMoveAllTabToWidgetOnly
local fFlagAddGamepadBumperNavigation = SharedFlags.FFlagAddGamepadBumperNavigation
local fFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation
local fFlagAppDebugPanel = SharedFlags.FFlagAppDebugPanel
local fFlagAppDebugTagAnnotation = SharedFlags.FFlagAppDebugTagAnnotation
local defineFastFlag4 = game:DefineFastFlag("GroupsDebugPanel", false)
local fFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local fFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local fFlagMomentsDarkAppNavBar = SharedFlags.FFlagMomentsDarkAppNavBar
local module54 = require("@luauforge/bundled/fsR")
local module55 = require("@luauforge/bundled/hUE")
local v8 = next(module55) ~= nil

local v9 = if module54 and v8 then require("@luauforge/bundled/hUG") else nil

local module56 = require("@luauforge/bundled/fun")

local fFlagCustomTitleBarM1Enabled = SharedFlags.FFlagCustomTitleBarM1Enabled

local customTitleBarPortal = if fFlagCustomTitleBarM1Enabled then require("@luauforge/bundled/hUM").CustomTitleBarPortal else nil

local v10 = nil
local debugPanel

if fFlagAppDebugPanel then
	debugPanel = require("@luauforge/bundled/hVi").DebugPanel

	if fFlagAppDebugTagAnnotation then
		v10 = require("@game/CorePackages/Workspace/Packages/AppDebug")
	end
else
	debugPanel = nil
end

local defineFastFlag5 = game:DefineFastFlag("AppNavAppContainerBottomBarIndexFromNav", false)
local defineFastFlag6 = game:DefineFastFlag("AppNavAppContainerCurrentPageFromNav", false)
local fn

if fFlagMomentsDarkAppNavBar then
	local tokens = getTokens(Foundation.Enums.ColorMode.Dark)
	local name = string.lower(tokens.Config.ColorMode.Name)

	fn = function(p2): nil
		local v11 = React.useContext(appearanceContext)
		local v12 = module56(false)
		local ref = React.useRef(nil)

		React.useLayoutEffect(function()
			v12.setSuppressAccountTheme(p2.shouldForceDarkColorMode)

			if p2.shouldForceDarkColorMode then
				ref.current = ref.current or v11.theme
				v11.setTheme(name)
			elseif ref.current ~= nil then
				v11.setTheme(ref.current)
				ref.current = nil
			end
		end, { p2.shouldForceDarkColorMode, v11, v12 })

		return nil
	end
else
	fn = nil
end

local function getDevicePlatform()
	if _G.__TESTEZ_RUNNING_TEST__ then
		return Enum.Platform.None
	end

	return UserInputService:GetPlatform()
end

local devicePlatform = getDevicePlatform()

local v11, v12 = module36()

local extended = Roact.Component:extend("AppContainer")

function extended:init()
	self.props.loggingProtocol:logEventOnce("app_container_init_begin")
	logger:info("Initializing App Container")

	local store = self.props.store
	local bottomBarAnalytics = self.props.bottomBarAnalytics

	if fFlagUseSignalsForPlatform then
		v5(false).setPlatform(devicePlatform)
	else
		store:dispatch(module32(devicePlatform))
	end

	function self.bottomBarButtonActivated(p2, p3)
		local v13 = if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage
		local v14

		if defineFastFlag5 then
			v14 = self:getSelectedBottomBarItemIndex()
		else
			v14 = self.props.selectedBottomBarItemIndex
		end

		if not v14 then
			return
		end

		local page = self.props.bottomBarItems[v14].page

		if p2 == module18.Moments then
			if p2 ~= page then
				self.props.navigateToPage(p2)

				if p3 then
					self.props.notificationService:ActionTaken(p3)
				end
			end
		elseif p2 == v13 then
			module3.ReloadPage:fire(p2)
		elseif v7.FFlagAppIaHomeSubTab and p2 == NavigationRodux.Constants.HomeContainerName then
			if v13 == module18.Home then
				module3.ReloadPage:fire(module18.Home)
			else
				self.props.navigateToPage(module18.Home)

				if p3 then
					self.props.notificationService:ActionTaken(p3)
				end
			end
		elseif p2 == module18.AvatarExperienceRoot then
			local avatarExperienceRoot = module18.AvatarExperienceRoot
			store:dispatch(module43.PercievedTrackingStarted())

			if fFlagAXMoveAllTabToWidgetOnly then
				widgetsPercievedTTIManager.startPerceivedTracking()
			else
				ttiPerformanceManager.Surface.Marketplace.Root.startPerceivedTracking()
			end

			self.props.navigateToPage(avatarExperienceRoot)

			if p3 then
				self.props.notificationService:ActionTaken(p3)
			end
		else
			if fFlagAppNavMyStatsTab and p2 == module18.Build then
				module45("TAB_CLICK", {})
			elseif p2 == module18.Chat then
				self.props.enteredChatFromEntryPoint(chatEntryPointNames.SystemBar)
				module15(self.props.analytics.EventStream, "AppContainer", self.props.chatBadgeCount)

				store:dispatch(module21.rodux.ClearGlobalUnreadCount.API()):catch(function(p4)
					logger:error("Error in ClearGlobalUnreadCount request. Error: {}", (tostring(p4)))
				end)
			end

			self.props.navigateToPage(p2)

			if p3 then
				self.props.notificationService:ActionTaken(p3)
			end
		end

		if p2 ~= page then
			module42.AppNavTelemetry.logSwitchTabStart(page, p2)
		end

		bottomBarAnalytics.ButtonActivated(p2, page)
	end

	self.getBottomBarLayoutInfo = module(function(p2, data, p3)
		local v13 = math.max(p2.X - data.left - data.right - 600, 0)

		local BOTTOM_BAR_SIZE = module2.BOTTOM_BAR_SIZE
		local v14 = math.max(data.bottom - BOTTOM_BAR_SIZE, 0)

		return {
			Background = {
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, -data.left, 1, 0),
				Size = UDim2.new(0, p2.X, 0, data.bottom)
			},
			Padding = {
				PaddingLeft = UDim.new(0, data.left + v13 / 2),
				PaddingRight = UDim.new(0, data.right + v13 / 2),
				PaddingBottom = UDim.new(0, v14)
			}
		}
	end)

	self.props.loggingProtocol:logEventOnce("app_container_init_end")
end

function extended:didMount()
	local store = self.props.store

	if not fFlagSignalsNavP3dRouteGated then
		store:dispatch(module30(false))
	end

	if fFlagAppDebugPanel and fFlagAppDebugTagAnnotation then
		v10.register()
	end

	if fFlagAppDebugPanel and defineFastFlag4 then
		self.unregisterGroupDebugSections = require("@luauforge/bundled/hVj").register()
	end

	if
		v7.GetFFlagEnableAccessBlockAtAppContainerLevel()
		and self.props.userLoggedIn
		and self.props.policyShouldBlockUAppAccess
	then
		self.props.resetNavigationHistoryToBlockPage()
	end

	if
		fFlagAppContainerReadyToRender
		and game:GetEngineFeature("SlowDownRendering")
		and self.props.appLifecycleObserverService
	then
		self.props.appLifecycleObserverService:TriggerOnLuaAppReadyToRender()
	end
end

function extended:willUnmount()
	if fFlagAppDebugPanel and defineFastFlag4 and self.unregisterGroupDebugSections then
		self.unregisterGroupDebugSections()
		self.unregisterGroupDebugSections = nil
	end
end

function extended:willUpdate_DEPRECATED(data)
	local v13 = module26[data.currentPage] or {}

	local v14 = data.tabBarVisibility

	if typeof(v14) == "function" then
		local v15 = {
			formFactor = data.formFactor,
			screenSize = 0,
			deviceOrientation = 0
		}
		local v16 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then data.screenSize else nil
		v15.screenSize = v16

		local v17 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then data.deviceOrientation else nil
		v15.deviceOrientation = v17
		v14 = v14(v15)
	end

	local v15

	if v14 == module17.PolicyDependent then
		v15 = self.props.shouldSystemBarUsuallyBePresent
	else
		v15 = v14 ~= module17.Hidden
	end

	if not v13.overridesAppRouterTabBarControl and v15 ~= data.bottomBarVisible then
		self.props.setTabBarVisible(v15)
	end

	if v7.FFlagAppIaScrollAway and module42.getScrollAwayEnabled() then
		if v13.overridesAppRouterTabBarControl then
			v15 = data.bottomBarVisible
		end

		local v16 = v13.enableScrollAway and v15

		if data.currentPage == self.props.currentPage or defineFastFlag3 and not v15 then
			if v15 and v16 ~= visibilityControl.isEnabled() then
				visibilityControl.show()
			end
		else
			visibilityControl.show()
		end

		if module52 then
			flyoutScrollAwayControl.setScrollAwayEnabled(v16)
		else
			visibilityControl.setEnabled(v16)
		end

		if fFlagAppIaScrollAwayPinHeader then
			visibilityControl.setHeaderScrollAwayDisabled(v13.disableHeaderScrollAway)
		end

		if fFlagAppIaScopedScrollAway then
			visibilityControl.setGlobalTouchEnabled(not v13.disableGlobalScrollAwayTouch)
		end
	end
end

if not defineFastFlag6 then
	function extended:willUpdate(p2)
		self:willUpdate_DEPRECATED(p2)
	end
end

function extended:didUpdate(p2, p3)
	if defineFastFlag6 then
		local currentPage = self:getCurrentPage()
		local currentPage2 = self:getCurrentPage(p2)
		local v13 = module26[currentPage] or {}

		local v14 = self.props.tabBarVisibility

		if typeof(v14) == "function" then
			local v15 = {
				formFactor = self.props.formFactor,
				screenSize = 0,
				deviceOrientation = 0
			}
			local v16 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then self.props.screenSize else nil
			v15.screenSize = v16

			local v17 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then self.props.deviceOrientation else nil
			v15.deviceOrientation = v17
			v14 = v14(v15)
		end

		local v15

		if v14 == module17.PolicyDependent then
			v15 = self.props.shouldSystemBarUsuallyBePresent
		else
			v15 = v14 ~= module17.Hidden
		end

		if not v13.overridesAppRouterTabBarControl and v15 ~= self.props.bottomBarVisible then
			self.props.setTabBarVisible(v15)
		end

		if v7.FFlagAppIaScrollAway and module42.getScrollAwayEnabled() then
			if v13.overridesAppRouterTabBarControl then
				v15 = self.props.bottomBarVisible
			end

			local v16 = v13.enableScrollAway and v15

			if currentPage == currentPage2 or defineFastFlag3 and not v15 then
				if v15 and v16 ~= visibilityControl.isEnabled() then
					visibilityControl.show()
				end
			else
				visibilityControl.show()
			end

			if module52 then
				flyoutScrollAwayControl.setScrollAwayEnabled(v16)
			else
				visibilityControl.setEnabled(v16)
			end

			if fFlagAppIaScrollAwayPinHeader then
				visibilityControl.setHeaderScrollAwayDisabled(v13.disableHeaderScrollAway)
			end

			if fFlagAppIaScopedScrollAway then
				visibilityControl.setGlobalTouchEnabled(not v13.disableGlobalScrollAwayTouch)
			end
		end
	end

	if
		self.props.userLoggedIn
		and self.props.appPolicy.getVNGFormRequired()
		and not v7.GetFFlagUseUpdatedVNGAgreementsWorkflow()
	then
		self.props.showVngForm()
	end

	if v7.GetFFlagEnableAccessBlockAtAppContainerLevel() then
		local userLoggedIn = self.props.policyShouldBlockUAppAccess and self.props.userLoggedIn

		local v14 = (if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage) == module18.UAppBlock

		if userLoggedIn and not v14 then
			self.props.resetNavigationHistoryToBlockPage()
		end
	end
end

function extended:render()
	if defineFastFlag and self.props.pregameLoadingScreenOnly then
		return Roact.createElement("Folder", {}, {
			PreGameLoadingScreen = Roact.createElement(preGameLoadingScreen)
		})
	end

	local screenSize = self.props.screenSize
	local globalGuiInset = self.props.globalGuiInset
	local bottomBarVisible = self.props.bottomBarVisible
	local v13

	if defineFastFlag5 then
		v13 = self:getSelectedBottomBarItemIndex()
	else
		v13 = self.props.selectedBottomBarItemIndex
	end

	local v14 = if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage

	local bottomBarItems = self.props.bottomBarItems
	local v15

	if fFlagMomentsDarkAppNavBar then
		local v16 = v13 and bottomBarItems[v13]
		v15 = (v16 and v16.page) == module18.Moments or v14 == module18.Moments
	else
		v15 = false
	end

	local element = Roact.createElement(module35)

	local deviceInsets = hardwareSafeAreaInsets.deviceInsets()

	local v16 = withStyle(function(p2)
		local v17 = nil

		if shouldUseDeviceSafeInsets or not fFlagLuaAppSupportDeviceSafeInsets then
			if shouldUseDeviceSafeInsets and SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets then
				v17 = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, globalGuiInset.top)
				})
			end
		else
			local createElement = Roact.createElement
			local v20 = if v7.GetFFlagLuaAppEnableTopBanner() then UDim.new(0, globalGuiInset.top) else nil
			v17 = createElement("UIPadding", {
				PaddingTop = v20,
				PaddingBottom = UDim.new(0, globalGuiInset.bottom),
				PaddingLeft = UDim.new(0, globalGuiInset.left)
			})
		end

		local udim = UDim2.fromOffset(0, 0)
		local v18

		if fFlagLuaAppEnableDeviceInsetBackground then
			v18 = false
		else
			local v19

			if module53 then
				v19 = module19(self.props.currentPage)
			else
				v19 = self.props.currentPage == module18.AvatarExperienceRoot
			end

			v18 = shouldUseDeviceSafeInsets

			if v18 then
				if
					deviceInsets.top > 0
					or deviceInsets.bottom > 0
					or deviceInsets.left > 0
					or deviceInsets.right > 0
					or self.props.usePreferredInput == Responsive.Input.Touch
				then
					v18 = not v19 or self.props.navBarPlacement == module42.Placement.Left
				else
					v18 = false
				end
			end

			local experienceDetailInNavTree = fFlagEnableStickyShortcutBarOnAllPlatforms
				and self.props.experienceDetailInNavTree

			if bottomBarVisible or experienceDetailInNavTree then
				if v19 then
					udim = UDim2.fromOffset(
						deviceInsets.left + self.props.navBarSize,
						screenSize.Y + deviceInsets.top + deviceInsets.bottom
					)
				else
					udim = UDim2.fromOffset(
						screenSize.X + deviceInsets.left + deviceInsets.right,
						screenSize.Y + deviceInsets.top + deviceInsets.bottom
					)
				end
			else
				udim = UDim2.fromOffset(0, 0)
			end
		end

		local v19

		if fFlagFixNavigationInsetsOnHiddenTabBar or fFlagEnableStickyShortcutBarOnAllPlatforms then
			v19 = { isTabBarVisible = 0, currentPage = 0 }
			v19.isTabBarVisible = if fFlagFixNavigationInsetsOnHiddenTabBar then bottomBarVisible else nil
			v19.currentPage = if fFlagEnableStickyShortcutBarOnAllPlatforms then v14 else nil
		end

		local v20 = if fFlagMomentsDarkAppNavBar then React.createElement(fn, {
			shouldForceDarkColorMode = v15
		}) else nil

		local createElement = Roact.createElement

		local v22 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.RouterView,
			shouldRestoreFocus = false,
			customEventMap = 0,
			customEventHandlers = 0
		}

		local v23 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventMap else nil
		v22.customEventMap = v23

		local v24 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventHandlerMap else nil
		v22.customEventHandlers = v24

		local createElement2 = Roact.createElement
		local createElement3 = Roact.createElement
		local v27 = if fFlagSignalsNavP3dRouteGated then memo else module23
		local children = {
			ThemeOverrideController = v20,
			RNAppContainer = createElement(focusNavigableSurfaceWrapper, v22, createElement2(module8, v19, {
				RootNavigator = createElement3(v27, {
					navigation = self.props.navigation
				})
			})),
			SystemBar = 0,
			Reporter = 0,
			StickyShortcutBarExposureLogger = 0,
			SafePadding = 0,
			AppShortcutBar = 0,
			NativeCloseEventConnector = 0,
			TenFootUiGlobalEffects = 0,
			DeviceInsetBackground = 0
		}

		local createElement4 = Roact.createElement
		local v29 = {
			isVisible = bottomBarVisible,
			displayOrder = module2.DisplayOrder.SystemBar,
			layoutInfo = self.getBottomBarLayoutInfo(screenSize, globalGuiInset),
			selectedIndex = v13,
			items = bottomBarItems,
			onActivated = self.bottomBarButtonActivated,
			customEventMap = 0,
			customEventHandlers = 0,
			isBumperNavigationEnabled = 0
		}

		local v30 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventMap else nil
		v29.customEventMap = v30

		local v31 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventHandlerMap else nil
		v29.customEventHandlers = v31

		local v32 = if fFlagAddGamepadBumperNavigation then self.props.isBumperNavigationEnabled else nil
		v29.isBumperNavigationEnabled = v32
		children.SystemBar = createElement4(module9, v29)

		children.Reporter = Roact.createElement(module25)

		local v33 = if fFlagUnifyShortcutBarUnifiedIXPExposure then Roact.createElement(stickyShortcutBarExposureLogger, {
			currentPage = v14
		}) else nil
		children.StickyShortcutBarExposureLogger = v33

		children.SafePadding = v17

		local v34 = if not fFlagEnableStickyShortcutBarOnAllPlatforms then Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
			{
				ShortcutBarContext = Roact.createElement(appShortcutBarContext.Provider, {}, {
					ShortcutBar = Roact.createElement(appShortcutBarContainer)
				})
			}
		) else nil
		children.AppShortcutBar = v34

		local v35 = if v7.FFlagEnableSystemTrayModals then Roact.createElement(module46, {
			onNativeCloseEvent = module47
		}) else nil
		children.NativeCloseEventConnector = v35

		children.TenFootUiGlobalEffects = Roact.createElement(tenFootUiGlobalEffects)
		local v36

		if fFlagLuaAppEnableDeviceInsetBackground then
			local createElement5 = Roact.createElement
			local v38 = {
				backgroundColor = p2.Theme.BackgroundDefault.Color,
				backgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
				bottomBarVisible = bottomBarVisible,
				currentPage = v14,
				experienceDetailInNavTree = 0,
				navBarPlacement = 0,
				navBarSize = 0,
				screenSize = 0
			}

			local v39 = if fFlagEnableStickyShortcutBarOnAllPlatforms then self.props.experienceDetailInNavTree else nil
			v38.experienceDetailInNavTree = v39

			v38.navBarPlacement = self.props.navBarPlacement
			v38.navBarSize = self.props.navBarSize
			v38.screenSize = screenSize
			v36 = createElement5(module48, v38)
		elseif v18 then
			v36 = Roact.createElement("Frame", {
				Position = UDim2.new(0, -deviceInsets.left, 0, -deviceInsets.top),
				Size = udim,
				BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				ZIndex = 0
			})
		end

		children.DeviceInsetBackground = v36

		if module54 and v8 then
			children.AppThemeBackgroundLayer = React.createElement(
				v9,
				{
					currentPage = v14,
					deviceInsetBackground = children.DeviceInsetBackground
				},
				{ RNAppContainer = children.RNAppContainer }
			)

			children.RNAppContainer = nil
			children.DeviceInsetBackground = nil
		end

		local v37

		if fFlagLuaAppSupportDeviceSafeInsets then
			if shouldUseDeviceSafeInsets then
				v37 = Enum.ScreenInsets.DeviceSafeInsets
			else
				v37 = Enum.ScreenInsets.None
			end
		end

		return Roact.createElement(vrReadyWrapper, {
			component = "ScreenGui",
			props = {
				Enabled = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 1,
				ScreenInsets = v37,
				ClipToDeviceSafeArea = if shouldUseDeviceSafeInsets then false else nil
			},
			vrProps = {
				partSize = vrConstants.MainScreenSize,
				offset = CFrame.new(vrConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = vrConstants.MainScreenResolution,
				panelName = "MainAppScreen",
				curvature = vrConstants.MainScreenCurvature,
				hidden = isVRAppBuild() and (v14 == module18.AvatarExperienceRoot or v14 == module18.AvatarExperienceWrapper),
				roundedCornersFrameColor = p2.Theme.BackgroundDefault.Color
			}
		}, children)
	end)

	local element2 = Roact.createElement(Roact.Portal, { target = CoreGui }, {
		LuaAppScreenGui = v16
	})
	local v17

	if fFlagCustomTitleBarM1Enabled and customTitleBarPortal then
		v17 = Roact.createElement(customTitleBarPortal, {
			displayOrder = module2.DisplayOrder.CustomTitleBar,
			title = "Roblox"
		})
	end

	local children = {
		Toast = Roact.createElement(module6, {
			displayOrder = module2.DisplayOrder.Toast
		}),
		ToastNotification = 0,
		GameInviteModal = 0,
		CentralOverlay = 0,
		RNBypassTree = 0,
		TopBanner = 0,
		FlyoutSidePanel = 0,
		FullscreenTitleBar = 0,
		CustomTitleBar = 0,
		VRPointer = 0,
		AppLoadingSplashScreen = 0,
		ShellEventsContainer = 0,
		ProgressLoadingAssetsScreenGui = 0,
		SduiDiscoveryDependencyUpdater = 0,
		SduiAvatarExperienceRegister = 0,
		SduiGroupsRegister = 0,
		SduiSharedRegister = 0,
		SduiCustomFormsRegister = 0,
		SduiPromptsRegister = 0,
		SduiVerificationUpsellRegister = 0,
		SduiSocialRegister = 0,
		SduiAdsRegister = 0,
		SduiUserSettingsRegister = 0,
		SduiOpenSearchResultsWithQueryReceiver = 0,
		SduiExperienceStoreRegister = 0,
		SduiEconomyRegister = 0,
		UniversalShareSheet = 0,
		DebugPanel = 0
	}

	local v18 = if defineFastFlag2 then Roact.createElement(appToastNotificationContainer, {
		displayOrder = module2.DisplayOrder.Toast
	}) else nil
	children.ToastNotification = v18

	children.GameInviteModal = Roact.createElement(gameInviteModal, {
		displayOrder = module2.DisplayOrder.GameInviteModal,
		renderLocation = gameInviteConstants.RenderLocation.UniversalApp
	})

	children.CentralOverlay = Roact.createElement(module7, {
		includeStatusBar = bottomBarVisible,
		displayOrder = module2.DisplayOrder.CentralOverlay
	})

	children.RNBypassTree = element2
	local v19 = if v7.GetFFlagLuaAppEnableTopBanner() then Roact.createElement(module10, {
		displayOrder = module2.DisplayOrder.TopBanner
	}) else nil
	children.TopBanner = v19

	local v20 = if module52 then Roact.createElement(v6, {
		displayOrder = module2.DisplayOrder.FlyoutSidePanel
	}) else nil
	children.FlyoutSidePanel = v20

	children.FullscreenTitleBar = Roact.createElement(module22, {
		displayOrder = module2.DisplayOrder.FullscreenTitleBar
	})

	children.CustomTitleBar = v17

	if not self.props.use3DPanels then
		element = nil
	end

	children.VRPointer = element
	children.AppLoadingSplashScreen = Roact.createElement(module37)

	children.ShellEventsContainer = Roact.createElement(module39, { currentPage = v14 })

	local v21 = if defineFastFlag then Roact.createElement(progressLoadingAssetsScreenGui, {
		displayOrder = module2.DisplayOrder.ProgressLoadingAssets
	}) else nil
	children.ProgressLoadingAssetsScreenGui = v21

	children.SduiDiscoveryDependencyUpdater = Roact.createElement(sduiDiscoveryDependencyUpdater)

	local v22 = if not (SharedFlags.FFlagInitializeSduiForApp or not v7.FFlagEnableAvatarExperienceSdui) then Roact.createElement(sduiAvatarExperienceRegister) else nil
	children.SduiAvatarExperienceRegister = v22

	local v23 = if not (SharedFlags.FFlagInitializeSduiForApp or not v7.FFlagEnableGroupsSdui) then Roact.createElement(sduiGroupsRegister) else nil
	children.SduiGroupsRegister = v23

	local v24 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiSharedRegister) else nil
	children.SduiSharedRegister = v24

	local v25 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiCustomFormsRegister) else nil
	children.SduiCustomFormsRegister = v25

	local v26 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiPromptsRegister) else nil
	children.SduiPromptsRegister = v26

	local v27 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiVerificationUpsellRegister) else nil
	children.SduiVerificationUpsellRegister = v27

	local v28 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiSocialRegister) else nil
	children.SduiSocialRegister = v28

	local v29 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v7.FFlagLuaAppSduiSponsoredTwoByOneTile or v7.FFlagLuaAppSduiGameTileFeedback or v7.FFlagSduiPlayWithRewardRefactor)) then Roact.createElement(sduiAdsRegister) else nil
	children.SduiAdsRegister = v29

	local v30 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v7.FFlagLuaAppSduiUpdateUserSettingsAction and v7.FFlagMoveSduiUpdateUserSettingsToAccountManagement)) then Roact.createElement(sduiUserSettingsRegister) else nil
	children.SduiUserSettingsRegister = v30

	children.SduiOpenSearchResultsWithQueryReceiver = Roact.createElement(module50)

	local v31 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v7.FFlagSduiDevStoreSeeAllSupport or v7.FFlagSduiGameItemsComponent)) then Roact.createElement(sduiExperienceStoreRegister) else nil
	children.SduiExperienceStoreRegister = v31

	local v32 = if not (SharedFlags.FFlagInitializeSduiForApp or not v7.FFlagSduiOpenIncomingTransferUpsellAction) then Roact.createElement(require("@luauforge/bundled/eWA").getSduiEconomyRegister()) else nil
	children.SduiEconomyRegister = v32

	local v33 = if fFlagEnableShareSheet then Roact.createElement(universalShareSheetHost) else nil
	children.UniversalShareSheet = v33
	local v34 = if fFlagAppDebugPanel then Roact.createElement(debugPanel) else nil
	children.DebugPanel = v34

	return Roact.createElement("Folder", {}, children)
end

function extended:getSelectedBottomBarItemIndex()
	local navigation = self.props.navigation
	local v13 = navigation and navigation.state and module42.getAppNavRootName(navigation.state)

	if v13 then
		return v12[v13]
	end

	return nil
end

function extended.getCurrentPage(p2, p3)
	local navigation = (p3 or p2.props).navigation

	if navigation and navigation.state then
		return module42.getAppNavCurrentPage(navigation.state)
	end

	return nil
end

local v13 = module(function(badgeCount, p2, p3, p4, p5, p6)
	if fFlagEnableArgus then
		v11, v12 = module36((require("@luauforge/bundled/hVl")(p6 == true)))
	else
		v11, v12 = module36()
	end

	local alert

	if typeof(badgeCount) == "number" and badgeCount > 0 then
		if p3 and p3.EventStream then
			module14(p3.EventStream, "AppContainer", badgeCount)
		end

		if defineFastInt < badgeCount then
			badgeCount = tostring(defineFastInt) .. "+"
		else
			badgeCount = tostring(badgeCount)
		end

		alert = badgeVariant.Alert
	end

	local v14 = v11
	local v15 = v12[module18.Chat]

	if v15 ~= nil then
		v14 = Cryo.List.join(v11)
		v14[v15].badgeCount = badgeCount
		v14[v15].badgeVariant = alert
	end

	return v14
end)

local function computeAppContainerNavPropsFromRouteHistory(list)
	local item = list[#list]
	local v14 = (function(list2)
		for i = #list2, 1, -1 do
			local v15 = module26[item[i].name] or {}

			if v15.tabBarHidden then
				return v15.tabBarHidden
			end
		end

		return module17.Visible
	end)(item)

	local v15 = if not defineFastFlag5 then v12[item[1].name] else nil
	local v16 = if not defineFastFlag6 then item[#item].name else nil

	local v17 = if fFlagEnableStickyShortcutBarOnAllPlatforms then hasPageInCurrentRoute(item, module18.ExperienceDetail) else nil
	return {
		selectedBottomBarItemIndex = v15,
		currentPage = v16,
		tabBarVisibility = v14,
		experienceDetailInNavTree = v17
	}
end

local v14 = RoactRodux.connect(function(data, data2)
	local unreadConversationCount = data.SocialTab.UnreadConversationCount or 0
	local v15

	if fFlagSignalsNavP3dRouteGated then
		v15 = {}
	else
		local v16

		if fFlagUseNavigationSelectors then
			v16 = selectors.selectLegacyHistory(data)
		else
			v16 = data.Navigation.history
		end

		v15 = computeAppContainerNavPropsFromRouteHistory(v16)
	end

	local join = Cryo.Dictionary.join
	local v16 = {
		screenSize = data.ScreenSize,
		globalGuiInset = data.GlobalGuiInset,
		bottomBarVisible = data.TabBarVisible,
		bottomBarItems = 0,
		chatBadgeCount = 0,
		userLoggedIn = 0,
		formFactor = 0,
		deviceOrientation = 0,
		localUserId = 0
	}

	local canSeeChatTab = data2.canSeeChatTab
	local analytics = data2.analytics
	local canSeeChatTerminology = data2.canSeeChatTerminology
	local canViewBuild = if fFlagAppNavMyStatsTab then data2.canViewBuild else nil
	local v18 = if fFlagEnableArgus then data2.displayMomentsTab else nil
	v16.bottomBarItems = v13(
		unreadConversationCount,
		canSeeChatTab,
		analytics,
		canSeeChatTerminology,
		canViewBuild,
		v18
	)

	v16.chatBadgeCount = unreadConversationCount

	local v19 = if not fFlagUseSignalsForAuthenticationStatus then data.AuthenticationStatus.status == module16.LOGGED_IN else nil
	v16.userLoggedIn = v19

	v16.formFactor = data.FormFactor

	local v20 = if not (fFlagUseSignalsForDeviceOrientation or not fFlagLuaAppEdpKeepFullPageOnPortraitRotation) then data.DeviceOrientation else nil
	v16.deviceOrientation = v20

	v16.localUserId = data.LocalUserId
	return join(v15, v16)
end, function(callback)
	return {
		navigateToPage = function(p2)
			if p2 == module18.Games then
				require("@luauforge/bundled/fBm").navigateToChartsPage({
					navigate = function(p3, options)
						if fFlagSignalsNavP3Dispatch then
							navigationCommands.to(navigationCommands.fromLegacyPage(Cryo.Dictionary.join({
								name = p3
							}, options or {})))
						else
							callback(module29({ Cryo.Dictionary.join({ name = p3 }, options or {}) }))
						end
					end
				})
			elseif fFlagSignalsNavP3Dispatch then
				navigationCommands.to(navigationCommands.fromLegacyPage({ name = p2 }))
			else
				callback(module29({
					{ name = p2 }
				}))
			end
		end,
		resetNavigationHistoryToBlockPage = function()
			callback(module31({
				{ name = module18.UAppBlock }
			}))
		end,
		setTabBarVisible = function(p2)
			module42.AppNavTelemetry.logVisibilityStart(p2)
			callback(setTabBarVisible(p2))
		end,
		showVngForm = function()
			callback(module34(module33.VngContactInfoFormWebviewPopup, {}, {
				DisableBackButtonClose = true
			}))
		end,
		enteredChatFromEntryPoint = function(p2)
			callback(module28(p2))
		end
	}
end)(extended)
local function AppContainerWithSignals(p2)
	local v15 = {}

	if fFlagSignalsNavP3dRouteGated then
		local legacyNavigationStore = getLegacyNavigationStore(false)

		for k, v17 in useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3)
				return computeAppContainerNavPropsFromRouteHistory(legacyNavigationStore.getHistory(p3))
			end, tutils.shallowEqual)
		end, { legacyNavigationStore }))) do
			v15[k] = v17
		end
	end

	local v16 = if fFlagUseSignalsForAuthenticationStatus then useSignalState(getAuthenticationStatusStore(false).getStatus) == module16.LOGGED_IN else nil
	v15.userLoggedIn = v16

	local v17 = if fFlagEnableArgus then module49().isAmpPolicyEnabled else nil
	v15.displayMomentsTab = v17

	local v18 = if fFlagUseSignalsForDeviceOrientation and fFlagLuaAppEdpKeepFullPageOnPortraitRotation then useSignalState(getDeviceOrientationStore(false).getDeviceOrientation) else nil
	v15.deviceOrientation = v18

	return React.createElement(v14, Cryo.Dictionary.union(p2, v15))
end

local memo2 = React.memo(AppContainerWithSignals)

local connect = roactServices.connect

if not fFlagAppContainerReadyToRender then
	appAppLifecycleObserverService = nil
end

local v16 = connect({
	notificationService = appNotificationService,
	networking = module11,
	bottomBarAnalytics = module12,
	analytics = module13,
	loggingProtocol = appLogging,
	appLifecycleObserverService = appAppLifecycleObserverService
})(memo2)

local v17 = roactAppPolicy.connect(function(data)
	local v19 = if v7.GetFFlagEnableAccessBlockAtAppContainerLevel() then data.getEnableUAppAccessBlock() or data.getEnableHomePageAgeBlock() else nil
	local v18 = {
		appPolicy = data,
		policyShouldBlockUAppAccess = v19,
		shouldSystemBarUsuallyBePresent = data.getShouldSystemBarUsuallyBePresent(),
		canSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab(),
		canSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology(),
		canViewBuild = 0
	}
	local v20 = if fFlagAppNavMyStatsTab then data.getCanViewBuild() else nil
	v18.canViewBuild = v20
	return v18
end)(v16)

local v18 = RoactNavigation.withNavigation(v17)

local v19 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.SocialFriendsLayer, "PlatformExcellence.QualityImprovement.App" },
	function(p2, p3)
		return {
			luaAddFriendsPageEnabled = (p2[appUserLayers.SocialFriendsLayer] or {}).show_lua_add_friends_page == "True"
		}
	end
)(v18)

return function(p2)
	if v7.FFlagLuaAppUseOverlayInAppContainer then
		useOverlay()
	end

	local v20 = useIsSpatial()
	local eventMap = nil
	local eventHandlerMap = nil
	local isBumperNavigationEnabled = nil

	if fFlagEnableSplitPaneAvatarOverlay then
		local v21 = module27(v11)
		eventMap = v21.eventMap
		eventHandlerMap = v21.eventHandlerMap
		isBumperNavigationEnabled = v21.isBumperNavigationEnabled
	elseif fFlagAddGamepadBumperNavigation then
		local v21 = useGamepadBumperNavigationBindings(v11)
		eventMap = v21.eventMap
		eventHandlerMap = v21.eventHandlerMap
		isBumperNavigationEnabled = v21.isBumperNavigationEnabled
	end

	local v21 = useNavBarSize()
	local v22 = useNavBarPlacement()

	local v23 = if defineFastFlag then useSignalState(getPregameLoadingScreenOnly) else false

	local join = Cryo.Dictionary.join
	local v24 = {
		use3DPanels = v20,
		pregameLoadingScreenOnly = v23,
		globalShortcutEventMap = not (fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay) and {} or eventMap,
		globalShortcutEventHandlerMap = not (fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay) and {} or eventHandlerMap,
		isBumperNavigationEnabled = 0,
		navBarSize = 0,
		navBarPlacement = 0
	}

	if not fFlagAddGamepadBumperNavigation then
		isBumperNavigationEnabled = nil
	end

	v24.isBumperNavigationEnabled = isBumperNavigationEnabled
	v24.navBarSize = v21
	v24.navBarPlacement = v22
	local v25 = join(p2, v24)

	return Roact.createElement(v19, v25)
end
