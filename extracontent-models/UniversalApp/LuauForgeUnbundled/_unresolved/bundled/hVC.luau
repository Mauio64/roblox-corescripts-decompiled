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
local module = require("@luauforge/bundled/ehO")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/dzD")
local module3 = require("@luauforge/bundled/egU")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local withStyle = UIBlox.Core.Style.withStyle
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module4 = require("@luauforge/bundled/ehL")
local focusNavigableSurfaceWrapper = module4.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local selectors = NavigationRodux.Selectors
local getLegacyHistoryFromRoactNavigationState = NavigationRodux.Utils.getLegacyHistoryFromRoactNavigationState
local Foundation = require(CorePackages.Packages.Foundation)
local useOverlay = Foundation.Hooks.useOverlay
local getTokens = Foundation.Utility.getTokens
local appearanceContext = require("@game/CorePackages/Workspace/Packages/Style").AppearanceContext

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module6 = require("@luauforge/bundled/hVD")
local module7 = require("@luauforge/bundled/hVG")
local module8 = require("@luauforge/bundled/ial")
local module9 = require("@luauforge/bundled/iam")
local module10 = require("@luauforge/bundled/iaL")
local badgeVariant = UIBlox.App.Indicator.Enum.BadgeVariant
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local module11 = require("@luauforge/bundled/egx")
local module12 = require("@luauforge/bundled/iaP")
local module13 = require("@luauforge/bundled/ecq")
local module14 = require("@luauforge/bundled/iaQ")
local module15 = require("@luauforge/bundled/iaR")
local module16 = require("@luauforge/bundled/ggj")
local module17 = require("@luauforge/bundled/dGK")
local module18 = require("@luauforge/bundled/dFu")
local module19 = require("@luauforge/bundled/iaS")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagUseSignalsForDeviceOrientation = SharedFlags.FFlagUseSignalsForDeviceOrientation
local getDeviceOrientationStore

if fFlagUseSignalsForDeviceOrientation then
	getDeviceOrientationStore = require("@luauforge/bundled/hWZ").GetDeviceOrientationStore
else
	getDeviceOrientationStore = nil
end

local module21 = require("@luauforge/bundled/fId")
local module22 = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Components/FullscreenTitleBar")
local module23 = require("@luauforge/bundled/dFA")
local memo = React.memo(module23)
local module24 = require("@luauforge/bundled/fFV")
local vrReadyWrapper = module24.VRReadyWrapper
local vrConstants = module24.VRConstants

local module25 = require("@luauforge/bundled/iaW")
local module26 = require("@luauforge/bundled/dGJ")
local setTabBarVisible = require("@luauforge/bundled/dzQ").Actions.SetTabBarVisible

local useGamepadBumperNavigationBindings = require("@luauforge/bundled/iap").useGamepadBumperNavigationBindings
local module27 = require("@luauforge/bundled/iba")

local module28 = require("@luauforge/bundled/hWK")
local chatEntryPointNames = require("@luauforge/bundled/eoT").Enums.ChatEntryPointNames
local module29 = require("@luauforge/bundled/ghP")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local module30 = require("@luauforge/bundled/dKw")
local module31 = require("@luauforge/bundled/dKv")
local module32 = require("@luauforge/bundled/hUk")
local fFlagUseSignalsForPlatform = SharedFlags.FFlagUseSignalsForPlatform

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fGm") else nil

local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers

local module33 = require("@luauforge/bundled/ehl")
local module34 = require("@luauforge/bundled/ehm")
local module35 = require("@luauforge/bundled/ibV")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module36 = require("@luauforge/bundled/dKy")
local appToastNotificationContainer = require("@luauforge/bundled/ibY").AppToastNotificationContainer
local module37 = require("@luauforge/bundled/ibZ")
local module38 = require("@luauforge/bundled/hUa")
local gameInviteModal = module38.GameInviteModal
local gameInviteConstants = module38.GameInviteConstants
local module39 = require("@luauforge/bundled/ica")
local module40 = require("@luauforge/bundled/ehS")
local appShortcutBarContainer = module40.AppShortcutBarContainer
local appShortcutBarContext = module40.AppShortcutBarContext
local stickyShortcutBarExposureLogger = module40.StickyShortcutBarExposureLogger
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useIsSpatial = Responsive.useIsSpatial
local hardwareSafeAreaInsets = Responsive.HardwareSafeAreaInsets
local module42 = require("@luauforge/bundled/dKz")
local visibilityControl = module42.VisibilityControl
local useNavBarSize = module42.useNavBarSize
local useNavBarPlacement = module42.useNavBarPlacement
local module43 = require("@luauforge/bundled/dWq")
local module44 = require("@luauforge/bundled/gLF")
local ttiPerformanceManager = module44.TTIPerformanceManager
local widgetsPercievedTTIManager = module44.WidgetsPercievedTTIManager
local module45 = require("@luauforge/bundled/dKA")
local module46 = require("@luauforge/bundled/icc")
local module47 = require("@luauforge/bundled/icd")
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagUnifyShortcutBarUnifiedIXPExposure = SharedFlags.FFlagUnifyShortcutBarUnifiedIXPExposure
local fFlagLuaAppEnableDeviceInsetBackground = SharedFlags.FFlagLuaAppEnableDeviceInsetBackground
local module48 = require("@luauforge/bundled/ice")
local hasPageInCurrentRoute = require("@luauforge/bundled/gCm").hasPageInCurrentRoute
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local tenFootUiGlobalEffects = require("@luauforge/bundled/ich").TenFootUiGlobalEffects
local fFlagAppContainerReadyToRender = SharedFlags.FFlagAppContainerReadyToRender
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3dRouteGated = SharedFlags.FFlagSignalsNavP3dRouteGated
local fFlagSignalsNavProjected = SharedFlags.FFlagSignalsNavProjected
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module49 = require("@luauforge/bundled/icx")
local getLegacyNavigationStore

if fFlagSignalsNavP3dRouteGated then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local defineFastFlag = game:DefineFastFlag("EnableProgressLoadingAssetsAppContainer", false)
local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet

local universalShareSheetHost = if fFlagEnableShareSheet then require("@luauforge/bundled/icy").UniversalShareSheetHost else nil

local module50 = require("@luauforge/bundled/fJk")

local v6 = if module50 then require("@luauforge/bundled/icz") else nil
local progressLoadingAssetsScreenGui, preGameLoadingScreen, getDeferredAssetStore

if defineFastFlag then
	local module51 = require("@luauforge/bundled/icY")
	progressLoadingAssetsScreenGui = module51.ProgressLoadingAssetsScreenGui
	preGameLoadingScreen = module51.PreGameLoadingScreen
	getDeferredAssetStore = module51.GetDeferredAssetStore
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

local sduiDiscoveryDependencyUpdater = require("@luauforge/bundled/dDZ").SduiDiscoveryDependencyUpdater

local sduiAvatarExperienceRegister = require("@luauforge/bundled/dTf").SduiAvatarExperienceRegister
local sduiGroupsRegister = require("@luauforge/bundled/icZ").SduiGroupsRegister
local sduiSharedRegister = require("@luauforge/bundled/idu").SduiSharedRegister
local sduiCustomFormsRegister = require("@luauforge/bundled/idv").SduiCustomFormsRegister
local sduiPromptsRegister = require("@luauforge/bundled/idw").SduiPromptsRegister

local sduiVerificationUpsellRegister = require("@luauforge/bundled/idx").SduiVerificationUpsellRegister
local sduiSocialRegister = require("@luauforge/bundled/idQ").SduiSocialRegister
local sduiAdsRegister = require("@luauforge/bundled/idR").SduiAdsRegister
local sduiUserSettingsRegister = require("@luauforge/bundled/hTy").SduiUserSettingsRegister

local module51 = require("@luauforge/bundled/iev")

local sduiExperienceStoreRegister = require("@luauforge/bundled/gCj").SduiExperienceStoreRegister
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy")

local module53 = require("@luauforge/bundled/dKL")
local v7, flyoutScrollAwayControl

if module53 then
	v7 = require("@luauforge/bundled/iew")
	flyoutScrollAwayControl = require("@luauforge/bundled/fAm").FlyoutScrollAwayControl
else
	flyoutScrollAwayControl = nil
	v7 = nil
end

local v8 = {
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

local module54 = require("@luauforge/bundled/icg")
local defineFastInt = game:DefineFastInt("PartyTabBadgeMaxCount", 49)
local fFlagLuaAppSupportDeviceSafeInsets = SharedFlags.FFlagLuaAppSupportDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@luauforge/bundled/dXA").shouldUseDeviceSafeInsets
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
local module55 = require("@luauforge/bundled/fAl")
local module56 = require("@luauforge/bundled/ieC")
local v9 = next(module56) ~= nil

local v10 = if module55 and v9 then require("@luauforge/bundled/ieE") else nil

local module57 = require("@luauforge/bundled/fBO")

local fFlagCustomTitleBarM1Enabled = SharedFlags.FFlagCustomTitleBarM1Enabled

local customTitleBarPortal = if fFlagCustomTitleBarM1Enabled then require("@luauforge/bundled/ieK").CustomTitleBarPortal else nil

local v11 = nil
local debugPanel

if fFlagAppDebugPanel then
	debugPanel = require("@luauforge/bundled/ifg").DebugPanel

	if fFlagAppDebugTagAnnotation then
		v11 = require("@game/CorePackages/Workspace/Packages/AppDebug")
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
		local v12 = React.useContext(appearanceContext)
		local v13 = module57(false)
		local ref = React.useRef(nil)

		React.useLayoutEffect(function()
			v13.setSuppressAccountTheme(p2.shouldForceDarkColorMode)

			if p2.shouldForceDarkColorMode then
				ref.current = ref.current or v12.theme
				v12.setTheme(name)
			elseif ref.current ~= nil then
				v12.setTheme(ref.current)
				ref.current = nil
			end
		end, { p2.shouldForceDarkColorMode, v12, v13 })

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

local v12, v13 = module36()

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
		local v14 = if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage
		local v15

		if defineFastFlag5 then
			v15 = self:getSelectedBottomBarItemIndex()
		else
			v15 = self.props.selectedBottomBarItemIndex
		end

		if not v15 then
			return
		end

		local page = self.props.bottomBarItems[v15].page

		if p2 == module18.Moments then
			if p2 ~= page then
				self.props.navigateToPage(p2)

				if p3 then
					self.props.notificationService:ActionTaken(p3)
				end
			end
		elseif p2 == v14 then
			module3.ReloadPage:fire(p2)
		elseif v8.FFlagAppIaHomeSubTab and p2 == NavigationRodux.Constants.HomeContainerName then
			if v14 == module18.Home then
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
		local v14 = math.max(p2.X - data.left - data.right - 600, 0)

		local BOTTOM_BAR_SIZE = module2.BOTTOM_BAR_SIZE
		local v15 = math.max(data.bottom - BOTTOM_BAR_SIZE, 0)

		return {
			Background = {
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, -data.left, 1, 0),
				Size = UDim2.new(0, p2.X, 0, data.bottom)
			},
			Padding = {
				PaddingLeft = UDim.new(0, data.left + v14 / 2),
				PaddingRight = UDim.new(0, data.right + v14 / 2),
				PaddingBottom = UDim.new(0, v15)
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
		v11.register()
	end

	if fFlagAppDebugPanel and defineFastFlag4 then
		self.unregisterGroupDebugSections = require("@luauforge/bundled/ifh").register()
	end

	if
		v8.GetFFlagEnableAccessBlockAtAppContainerLevel()
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
	local v14 = module26[data.currentPage] or {}

	local v15 = data.tabBarVisibility

	if typeof(v15) == "function" then
		local v16 = {
			formFactor = data.formFactor,
			screenSize = 0,
			deviceOrientation = 0
		}
		local v17 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then data.screenSize else nil
		v16.screenSize = v17

		local v18 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then data.deviceOrientation else nil
		v16.deviceOrientation = v18
		v15 = v15(v16)
	end

	local v16

	if v15 == module17.PolicyDependent then
		v16 = self.props.shouldSystemBarUsuallyBePresent
	else
		v16 = v15 ~= module17.Hidden
	end

	if not v14.overridesAppRouterTabBarControl and v16 ~= data.bottomBarVisible then
		self.props.setTabBarVisible(v16)
	end

	if v8.FFlagAppIaScrollAway and module42.getScrollAwayEnabled() then
		if v14.overridesAppRouterTabBarControl then
			v16 = data.bottomBarVisible
		end

		local v17 = v14.enableScrollAway and v16

		if data.currentPage == self.props.currentPage or defineFastFlag3 and not v16 then
			if v16 and v17 ~= visibilityControl.isEnabled() then
				visibilityControl.show()
			end
		else
			visibilityControl.show()
		end

		if module53 then
			flyoutScrollAwayControl.setScrollAwayEnabled(v17)
		else
			visibilityControl.setEnabled(v17)
		end

		if fFlagAppIaScrollAwayPinHeader then
			visibilityControl.setHeaderScrollAwayDisabled(v14.disableHeaderScrollAway)
		end

		if fFlagAppIaScopedScrollAway then
			visibilityControl.setGlobalTouchEnabled(not v14.disableGlobalScrollAwayTouch)
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
		local v14 = module26[currentPage] or {}

		local v15 = self.props.tabBarVisibility

		if typeof(v15) == "function" then
			local v16 = {
				formFactor = self.props.formFactor,
				screenSize = 0,
				deviceOrientation = 0
			}
			local v17 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then self.props.screenSize else nil
			v16.screenSize = v17

			local v18 = if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then self.props.deviceOrientation else nil
			v16.deviceOrientation = v18
			v15 = v15(v16)
		end

		local v16

		if v15 == module17.PolicyDependent then
			v16 = self.props.shouldSystemBarUsuallyBePresent
		else
			v16 = v15 ~= module17.Hidden
		end

		if not v14.overridesAppRouterTabBarControl and v16 ~= self.props.bottomBarVisible then
			self.props.setTabBarVisible(v16)
		end

		if v8.FFlagAppIaScrollAway and module42.getScrollAwayEnabled() then
			if v14.overridesAppRouterTabBarControl then
				v16 = self.props.bottomBarVisible
			end

			local v17 = v14.enableScrollAway and v16

			if currentPage == currentPage2 or defineFastFlag3 and not v16 then
				if v16 and v17 ~= visibilityControl.isEnabled() then
					visibilityControl.show()
				end
			else
				visibilityControl.show()
			end

			if module53 then
				flyoutScrollAwayControl.setScrollAwayEnabled(v17)
			else
				visibilityControl.setEnabled(v17)
			end

			if fFlagAppIaScrollAwayPinHeader then
				visibilityControl.setHeaderScrollAwayDisabled(v14.disableHeaderScrollAway)
			end

			if fFlagAppIaScopedScrollAway then
				visibilityControl.setGlobalTouchEnabled(not v14.disableGlobalScrollAwayTouch)
			end
		end
	end

	if
		self.props.userLoggedIn
		and self.props.appPolicy.getVNGFormRequired()
		and not v8.GetFFlagUseUpdatedVNGAgreementsWorkflow()
	then
		self.props.showVngForm()
	end

	if v8.GetFFlagEnableAccessBlockAtAppContainerLevel() then
		local userLoggedIn = self.props.policyShouldBlockUAppAccess and self.props.userLoggedIn

		local v15 = (if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage) == module18.UAppBlock

		if userLoggedIn and not v15 then
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
	local v14

	if defineFastFlag5 then
		v14 = self:getSelectedBottomBarItemIndex()
	else
		v14 = self.props.selectedBottomBarItemIndex
	end

	local v15 = if defineFastFlag6 then self:getCurrentPage() else self.props.currentPage

	local bottomBarItems = self.props.bottomBarItems
	local v16

	if fFlagMomentsDarkAppNavBar then
		local v17 = v14 and bottomBarItems[v14]
		v16 = (v17 and v17.page) == module18.Moments or v15 == module18.Moments
	else
		v16 = false
	end

	local element = Roact.createElement(module35)

	local deviceInsets = hardwareSafeAreaInsets.deviceInsets()

	local v17 = withStyle(function(p2)
		local v18 = nil

		if shouldUseDeviceSafeInsets or not fFlagLuaAppSupportDeviceSafeInsets then
			if shouldUseDeviceSafeInsets and SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets then
				v18 = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, globalGuiInset.top)
				})
			end
		else
			local createElement = Roact.createElement
			local v21 = if v8.GetFFlagLuaAppEnableTopBanner() then UDim.new(0, globalGuiInset.top) else nil
			v18 = createElement("UIPadding", {
				PaddingTop = v21,
				PaddingBottom = UDim.new(0, globalGuiInset.bottom),
				PaddingLeft = UDim.new(0, globalGuiInset.left)
			})
		end

		local udim = UDim2.fromOffset(0, 0)
		local v19

		if fFlagLuaAppEnableDeviceInsetBackground then
			v19 = false
		else
			local v20

			if module54 then
				v20 = module19(self.props.currentPage)
			else
				v20 = self.props.currentPage == module18.AvatarExperienceRoot
			end

			v19 = shouldUseDeviceSafeInsets

			if v19 then
				if
					deviceInsets.top > 0
					or deviceInsets.bottom > 0
					or deviceInsets.left > 0
					or deviceInsets.right > 0
					or self.props.usePreferredInput == Responsive.Input.Touch
				then
					v19 = not v20 or self.props.navBarPlacement == module42.Placement.Left
				else
					v19 = false
				end
			end

			local experienceDetailInNavTree = fFlagEnableStickyShortcutBarOnAllPlatforms
				and self.props.experienceDetailInNavTree

			if bottomBarVisible or experienceDetailInNavTree then
				if v20 then
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

		local v20

		if fFlagFixNavigationInsetsOnHiddenTabBar or fFlagEnableStickyShortcutBarOnAllPlatforms then
			v20 = { isTabBarVisible = 0, currentPage = 0 }
			v20.isTabBarVisible = if fFlagFixNavigationInsetsOnHiddenTabBar then bottomBarVisible else nil
			v20.currentPage = if fFlagEnableStickyShortcutBarOnAllPlatforms then v15 else nil
		end

		local v21 = if fFlagMomentsDarkAppNavBar then React.createElement(fn, {
			shouldForceDarkColorMode = v16
		}) else nil

		local createElement = Roact.createElement

		local v23 = {
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.RouterView,
			shouldRestoreFocus = false,
			customEventMap = 0,
			customEventHandlers = 0
		}

		local v24 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventMap else nil
		v23.customEventMap = v24

		local v25 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventHandlerMap else nil
		v23.customEventHandlers = v25

		local createElement2 = Roact.createElement
		local createElement3 = Roact.createElement
		local v28 = if fFlagSignalsNavP3dRouteGated then memo else module23
		local children = {
			ThemeOverrideController = v21,
			RNAppContainer = createElement(focusNavigableSurfaceWrapper, v23, createElement2(module8, v20, {
				RootNavigator = createElement3(v28, {
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
		local v30 = {
			isVisible = bottomBarVisible,
			displayOrder = module2.DisplayOrder.SystemBar,
			layoutInfo = self.getBottomBarLayoutInfo(screenSize, globalGuiInset),
			selectedIndex = v14,
			items = bottomBarItems,
			onActivated = self.bottomBarButtonActivated,
			customEventMap = 0,
			customEventHandlers = 0,
			isBumperNavigationEnabled = 0
		}

		local v31 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventMap else nil
		v30.customEventMap = v31

		local v32 = if fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay then self.props.globalShortcutEventHandlerMap else nil
		v30.customEventHandlers = v32

		local v33 = if fFlagAddGamepadBumperNavigation then self.props.isBumperNavigationEnabled else nil
		v30.isBumperNavigationEnabled = v33
		children.SystemBar = createElement4(module9, v30)

		children.Reporter = Roact.createElement(module25)

		local v34 = if fFlagUnifyShortcutBarUnifiedIXPExposure then Roact.createElement(stickyShortcutBarExposureLogger, {
			currentPage = v15
		}) else nil
		children.StickyShortcutBarExposureLogger = v34

		children.SafePadding = v18

		local v35 = if not fFlagEnableStickyShortcutBarOnAllPlatforms then Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
			{
				ShortcutBarContext = Roact.createElement(appShortcutBarContext.Provider, {}, {
					ShortcutBar = Roact.createElement(appShortcutBarContainer)
				})
			}
		) else nil
		children.AppShortcutBar = v35

		local v36 = if v8.FFlagEnableSystemTrayModals then Roact.createElement(module46, {
			onNativeCloseEvent = module47
		}) else nil
		children.NativeCloseEventConnector = v36

		children.TenFootUiGlobalEffects = Roact.createElement(tenFootUiGlobalEffects)
		local v37

		if fFlagLuaAppEnableDeviceInsetBackground then
			local createElement5 = Roact.createElement
			local v39 = {
				backgroundColor = p2.Theme.BackgroundDefault.Color,
				backgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
				bottomBarVisible = bottomBarVisible,
				currentPage = v15,
				experienceDetailInNavTree = 0,
				navBarPlacement = 0,
				navBarSize = 0,
				screenSize = 0
			}

			local v40 = if fFlagEnableStickyShortcutBarOnAllPlatforms then self.props.experienceDetailInNavTree else nil
			v39.experienceDetailInNavTree = v40

			v39.navBarPlacement = self.props.navBarPlacement
			v39.navBarSize = self.props.navBarSize
			v39.screenSize = screenSize
			v37 = createElement5(module48, v39)
		elseif v19 then
			v37 = Roact.createElement("Frame", {
				Position = UDim2.new(0, -deviceInsets.left, 0, -deviceInsets.top),
				Size = udim,
				BackgroundColor3 = p2.Theme.BackgroundDefault.Color,
				BackgroundTransparency = p2.Theme.BackgroundDefault.Transparency,
				BorderSizePixel = 0,
				ZIndex = 0
			})
		end

		children.DeviceInsetBackground = v37

		if module55 and v9 then
			children.AppThemeBackgroundLayer = React.createElement(
				v10,
				{
					currentPage = v15,
					deviceInsetBackground = children.DeviceInsetBackground
				},
				{ RNAppContainer = children.RNAppContainer }
			)

			children.RNAppContainer = nil
			children.DeviceInsetBackground = nil
		end

		local v38

		if fFlagLuaAppSupportDeviceSafeInsets then
			if shouldUseDeviceSafeInsets then
				v38 = Enum.ScreenInsets.DeviceSafeInsets
			else
				v38 = Enum.ScreenInsets.None
			end
		end

		return Roact.createElement(vrReadyWrapper, {
			component = "ScreenGui",
			props = {
				Enabled = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 1,
				ScreenInsets = v38,
				ClipToDeviceSafeArea = if shouldUseDeviceSafeInsets then false else nil
			},
			vrProps = {
				partSize = vrConstants.MainScreenSize,
				offset = CFrame.new(vrConstants.MainScreenPosition) * CFrame.fromEulerAnglesXYZ(0, -3.141592653589793, 0),
				virtualScreenSize = vrConstants.MainScreenResolution,
				panelName = "MainAppScreen",
				curvature = vrConstants.MainScreenCurvature,
				hidden = isVRAppBuild() and (v15 == module18.AvatarExperienceRoot or v15 == module18.AvatarExperienceWrapper),
				roundedCornersFrameColor = p2.Theme.BackgroundDefault.Color
			}
		}, children)
	end)

	local element2 = Roact.createElement(Roact.Portal, { target = CoreGui }, {
		LuaAppScreenGui = v17
	})
	local v18

	if fFlagCustomTitleBarM1Enabled and customTitleBarPortal then
		v18 = Roact.createElement(customTitleBarPortal, {
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
		RobloxSubscriptionOnboardingSheet = 0,
		DebugPanel = 0
	}

	local v19 = if defineFastFlag2 then Roact.createElement(appToastNotificationContainer, {
		displayOrder = module2.DisplayOrder.Toast
	}) else nil
	children.ToastNotification = v19

	children.GameInviteModal = Roact.createElement(gameInviteModal, {
		displayOrder = module2.DisplayOrder.GameInviteModal,
		renderLocation = gameInviteConstants.RenderLocation.UniversalApp
	})

	children.CentralOverlay = Roact.createElement(module7, {
		includeStatusBar = bottomBarVisible,
		displayOrder = module2.DisplayOrder.CentralOverlay
	})

	children.RNBypassTree = element2
	local v20 = if v8.GetFFlagLuaAppEnableTopBanner() then Roact.createElement(module10, {
		displayOrder = module2.DisplayOrder.TopBanner
	}) else nil
	children.TopBanner = v20

	local v21 = if module53 then Roact.createElement(v7, {
		displayOrder = module2.DisplayOrder.FlyoutSidePanel
	}) else nil
	children.FlyoutSidePanel = v21

	children.FullscreenTitleBar = Roact.createElement(module22, {
		displayOrder = module2.DisplayOrder.FullscreenTitleBar
	})

	children.CustomTitleBar = v18

	if not self.props.use3DPanels then
		element = nil
	end

	children.VRPointer = element
	children.AppLoadingSplashScreen = Roact.createElement(module37)

	children.ShellEventsContainer = Roact.createElement(module39, { currentPage = v15 })

	local v22 = if defineFastFlag then Roact.createElement(progressLoadingAssetsScreenGui, {
		displayOrder = module2.DisplayOrder.ProgressLoadingAssets
	}) else nil
	children.ProgressLoadingAssetsScreenGui = v22

	children.SduiDiscoveryDependencyUpdater = Roact.createElement(sduiDiscoveryDependencyUpdater)

	local v23 = if not (SharedFlags.FFlagInitializeSduiForApp or not v8.FFlagEnableAvatarExperienceSdui) then Roact.createElement(sduiAvatarExperienceRegister) else nil
	children.SduiAvatarExperienceRegister = v23

	local v24 = if not (SharedFlags.FFlagInitializeSduiForApp or not v8.FFlagEnableGroupsSdui) then Roact.createElement(sduiGroupsRegister) else nil
	children.SduiGroupsRegister = v24

	local v25 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiSharedRegister) else nil
	children.SduiSharedRegister = v25

	local v26 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiCustomFormsRegister) else nil
	children.SduiCustomFormsRegister = v26

	local v27 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiPromptsRegister) else nil
	children.SduiPromptsRegister = v27

	local v28 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiVerificationUpsellRegister) else nil
	children.SduiVerificationUpsellRegister = v28

	local v29 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(sduiSocialRegister) else nil
	children.SduiSocialRegister = v29

	local v30 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v8.FFlagLuaAppSduiSponsoredTwoByOneTile or v8.FFlagLuaAppSduiGameTileFeedback or v8.FFlagSduiPlayWithRewardRefactor)) then Roact.createElement(sduiAdsRegister) else nil
	children.SduiAdsRegister = v30

	local v31 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v8.FFlagLuaAppSduiUpdateUserSettingsAction and v8.FFlagMoveSduiUpdateUserSettingsToAccountManagement)) then Roact.createElement(sduiUserSettingsRegister) else nil
	children.SduiUserSettingsRegister = v31

	children.SduiOpenSearchResultsWithQueryReceiver = Roact.createElement(module51)

	local v32 = if not (SharedFlags.FFlagInitializeSduiForApp or not (v8.FFlagSduiDevStoreSeeAllSupport or v8.FFlagSduiGameItemsComponent)) then Roact.createElement(sduiExperienceStoreRegister) else nil
	children.SduiExperienceStoreRegister = v32

	local v33 = if not (SharedFlags.FFlagInitializeSduiForApp or not v8.FFlagSduiOpenIncomingTransferUpsellAction) then Roact.createElement(require("@luauforge/bundled/fdz").getSduiEconomyRegister()) else nil
	children.SduiEconomyRegister = v33

	local v34 = if fFlagEnableShareSheet then Roact.createElement(universalShareSheetHost) else nil
	children.UniversalShareSheet = v34

	local v35 = if module50 then Roact.createElement(v6) else nil
	children.RobloxSubscriptionOnboardingSheet = v35

	local v36 = if fFlagAppDebugPanel then Roact.createElement(debugPanel) else nil
	children.DebugPanel = v36

	return Roact.createElement("Folder", {}, children)
end

function extended:getSelectedBottomBarItemIndex()
	local navigation = self.props.navigation
	local v14 = navigation and navigation.state and module42.getAppNavRootName(navigation.state)

	if v14 then
		return v13[v14]
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

local v14 = module(function(badgeCount, p2, p3, p4, p5, p6)
	if fFlagEnableArgus then
		v12, v13 = module36((require("@luauforge/bundled/gev")(p6 == true)))
	else
		v12, v13 = module36()
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

	local v15 = v12
	local v16 = v13[module18.Chat]

	if v16 ~= nil then
		v15 = Cryo.List.join(v12)
		v15[v16].badgeCount = badgeCount
		v15[v16].badgeVariant = alert
	end

	return v15
end)

local function computeAppContainerNavPropsFromRouteHistory(list)
	local item = list[#list]
	local v15 = (function(list2)
		for i = #list2, 1, -1 do
			local v16 = module26[item[i].name] or {}

			if v16.tabBarHidden then
				return v16.tabBarHidden
			end
		end

		return module17.Visible
	end)(item)

	local v16 = if not defineFastFlag5 then v13[item[1].name] else nil
	local v17 = if not defineFastFlag6 then item[#item].name else nil

	local v18 = if fFlagEnableStickyShortcutBarOnAllPlatforms then hasPageInCurrentRoute(item, module18.ExperienceDetail) else nil
	return {
		selectedBottomBarItemIndex = v16,
		currentPage = v17,
		tabBarVisibility = v15,
		experienceDetailInNavTree = v18
	}
end

local v15 = RoactRodux.connect(function(data, data2)
	local unreadConversationCount = data.SocialTab.UnreadConversationCount or 0
	local v16

	if fFlagSignalsNavP3dRouteGated then
		v16 = {}
	else
		local v17

		if fFlagUseNavigationSelectors then
			v17 = selectors.selectLegacyHistory(data)
		else
			v17 = data.Navigation.history
		end

		v16 = computeAppContainerNavPropsFromRouteHistory(v17)
	end

	local join = Cryo.Dictionary.join
	local v17 = {
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
	local v19 = if fFlagEnableArgus then data2.displayMomentsTab else nil
	v17.bottomBarItems = v14(
		unreadConversationCount,
		canSeeChatTab,
		analytics,
		canSeeChatTerminology,
		canViewBuild,
		v19
	)

	v17.chatBadgeCount = unreadConversationCount

	local v20 = if not fFlagUseSignalsForAuthenticationStatus then data.AuthenticationStatus.status == module16.LOGGED_IN else nil
	v17.userLoggedIn = v20

	v17.formFactor = data.FormFactor

	local v21 = if not (fFlagUseSignalsForDeviceOrientation or not fFlagLuaAppEdpKeepFullPageOnPortraitRotation) then data.DeviceOrientation else nil
	v17.deviceOrientation = v21

	v17.localUserId = data.LocalUserId
	return join(v16, v17)
end, function(callback)
	return {
		navigateToPage = function(p2)
			if p2 == module18.Games then
				require("@luauforge/bundled/gfF").navigateToChartsPage({
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
	local v16 = {}

	if fFlagSignalsNavProjected then
		local state = p2.navigation.state
		local v17 = React.useMemo(function()
			return computeAppContainerNavPropsFromRouteHistory(getLegacyHistoryFromRoactNavigationState(state))
		end, { state })

		for k, v18 in v17 do
			v16[k] = v18
		end
	elseif fFlagSignalsNavP3dRouteGated then
		local legacyNavigationStore = getLegacyNavigationStore(false)

		for k, v18 in useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3)
				return computeAppContainerNavPropsFromRouteHistory(legacyNavigationStore.getHistory(p3))
			end, tutils.shallowEqual)
		end, { legacyNavigationStore }))) do
			v16[k] = v18
		end
	end

	local v17 = if fFlagUseSignalsForAuthenticationStatus then useSignalState(getAuthenticationStatusStore(false).getStatus) == module16.LOGGED_IN else nil
	v16.userLoggedIn = v17

	local v18 = if fFlagEnableArgus then module49().isAmpPolicyEnabled else nil
	v16.displayMomentsTab = v18

	local v19 = if fFlagUseSignalsForDeviceOrientation and fFlagLuaAppEdpKeepFullPageOnPortraitRotation then useSignalState(getDeviceOrientationStore(false).getDeviceOrientation) else nil
	v16.deviceOrientation = v19

	return React.createElement(v15, Cryo.Dictionary.union(p2, v16))
end

local memo2 = React.memo(AppContainerWithSignals)

local connect = roactServices.connect

if not fFlagAppContainerReadyToRender then
	appAppLifecycleObserverService = nil
end

local v17 = connect({
	notificationService = appNotificationService,
	networking = module11,
	bottomBarAnalytics = module12,
	analytics = module13,
	loggingProtocol = appLogging,
	appLifecycleObserverService = appAppLifecycleObserverService
})(memo2)

local v18 = roactAppPolicy.connect(function(data)
	local v20 = if v8.GetFFlagEnableAccessBlockAtAppContainerLevel() then data.getEnableUAppAccessBlock() or data.getEnableHomePageAgeBlock() else nil
	local v19 = {
		appPolicy = data,
		policyShouldBlockUAppAccess = v20,
		shouldSystemBarUsuallyBePresent = data.getShouldSystemBarUsuallyBePresent(),
		canSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab(),
		canSeeChatTerminology = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology(),
		canViewBuild = 0
	}
	local v21 = if fFlagAppNavMyStatsTab then data.getCanViewBuild() else nil
	v19.canViewBuild = v21
	return v19
end)(v17)

local v19 = RoactNavigation.withNavigation(v18)

local v20 = RoactAppExperiment.connectUserLayer(
	{ appUserLayers.SocialFriendsLayer, "PlatformExcellence.QualityImprovement.App" },
	function(p2, p3)
		return {
			luaAddFriendsPageEnabled = (p2[appUserLayers.SocialFriendsLayer] or {}).show_lua_add_friends_page == "True"
		}
	end
)(v19)

return function(p2)
	if v8.FFlagLuaAppUseOverlayInAppContainer then
		useOverlay()
	end

	local v21 = useIsSpatial()
	local eventMap = nil
	local eventHandlerMap = nil
	local isBumperNavigationEnabled = nil

	if fFlagEnableSplitPaneAvatarOverlay then
		local v22 = module27(v12)
		eventMap = v22.eventMap
		eventHandlerMap = v22.eventHandlerMap
		isBumperNavigationEnabled = v22.isBumperNavigationEnabled
	elseif fFlagAddGamepadBumperNavigation then
		local v22 = useGamepadBumperNavigationBindings(v12)
		eventMap = v22.eventMap
		eventHandlerMap = v22.eventHandlerMap
		isBumperNavigationEnabled = v22.isBumperNavigationEnabled
	end

	local v22 = useNavBarSize()
	local v23 = useNavBarPlacement()

	local v24 = if defineFastFlag then useSignalState(getPregameLoadingScreenOnly) else false

	local join = Cryo.Dictionary.join
	local v25 = {
		use3DPanels = v21,
		pregameLoadingScreenOnly = v24,
		globalShortcutEventMap = not (fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay) and {} or eventMap,
		globalShortcutEventHandlerMap = not (fFlagAddGamepadBumperNavigation or fFlagEnableSplitPaneAvatarOverlay) and {} or eventHandlerMap,
		isBumperNavigationEnabled = 0,
		navBarSize = 0,
		navBarPlacement = 0
	}

	if not fFlagAddGamepadBumperNavigation then
		isBumperNavigationEnabled = nil
	end

	v25.isBumperNavigationEnabled = isBumperNavigationEnabled
	v25.navBarSize = v22
	v25.navBarPlacement = v23
	local v26 = join(p2, v25)

	return Roact.createElement(v20, v26)
end
