local CorePackages = game:GetService("CorePackages")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local NotificationService = game:GetService("NotificationService")
local LocalizationService = game:GetService("LocalizationService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SessionService = game:GetService("SessionService")
local EventIngestService = game:GetService("EventIngestService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local AppUpdateService = game:GetService("AppUpdateService")
local IXPService = game:GetService("IXPService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local ContentProvider = game:GetService("ContentProvider")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local StartupMessageService = game:GetService("StartupMessageService")
local GamepadService = game:GetService("GamepadService")

require("@luauforge/bundled/o")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local success, result = pcall(function()
	return game:GetEngineFeature("PinShortcutServiceEnabled") and game:GetService("PinShortcutService")
		or nil
end)

local v5 = success and result or nil

local module2 = require("@luauforge/bundled/vR")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local v6 = if require("@luauforge/bundled/wd") then require("@luauforge/bundled/wf") else nil

require("@luauforge/bundled/AK")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local systemInfoProtocol = require("@luauforge/bundled/bZd").SystemInfoProtocol
local linkingProtocol = require("@luauforge/bundled/bZe").LinkingProtocol
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local gameProtocol = require("@luauforge/bundled/bZg").GameProtocol
local permissionsProtocol = require("@luauforge/bundled/bZh").PermissionsProtocol
local prefetchProtocol = require("@luauforge/bundled/bZi").PrefetchProtocol
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local externalContentSharingProtocol = require("@luauforge/bundled/bZp").ExternalContentSharingProtocol

local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")
local module6 = require("@luauforge/bundled/bZs")
local module7 = require("@luauforge/bundled/bZu")
local useUserAgreements = require("@luauforge/bundled/gsy").useUserAgreements
local isPioneerLaunch = require("@luauforge/bundled/gid").isPioneerLaunch
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local module8 = require("@luauforge/bundled/hUU")
local module9 = require("@luauforge/bundled/ifj")
local module10 = require("@luauforge/bundled/ifo")
local module11 = require("@luauforge/bundled/ifs")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local providerContainer = RoactUtils.Components.ProviderContainer
local reactProfiler = RoactUtils.Profiling.ReactProfiler
local reactProfilerContext = RoactUtils.Profiling.ReactProfilerContext
local module13 = require("@luauforge/bundled/icb")
local module14 = require("@luauforge/bundled/ift")
local module15 = require("@luauforge/bundled/AL")
local module16 = require("@luauforge/bundled/ifu")
local module17 = require("@luauforge/bundled/igD")
local module18 = require("@luauforge/bundled/igE")
local module19 = require("@luauforge/bundled/igG")
local module20 = require("@luauforge/bundled/igK")
local module21 = require("@luauforge/bundled/igL")
local module22 = require("@luauforge/bundled/igM")
local module23 = require("@luauforge/bundled/B")
local module24 = require("@luauforge/bundled/igN")
local module25 = require("@luauforge/bundled/igP")
local module26 = require("@luauforge/bundled/igQ")
local UIBlox = require(CorePackages.Packages.UIBlox)
local module27 = require("@luauforge/bundled/dFs")
local module28 = require("@luauforge/bundled/igU")
local module29 = require("@luauforge/bundled/igZ")
local inAppAchievementManager = require("@luauforge/bundled/dBS").InAppAchievementManager

local provider = require("@luauforge/bundled/ehL").FocusNavigableSurfaceRegistry.Provider
local appReadyHandler = require("@luauforge/bundled/dFB").AppReadyHandler
local rnBypassAdapter = require("@luauforge/bundled/dFB").RnBypassAdapter
local resolveNavigationTarget = require("@luauforge/bundled/dFz").resolveNavigationTarget
local fFlagImportVirtualCursorToUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagImportVirtualCursorToUA

local fFlagVirtualCursorModularization = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagVirtualCursorModularization

if fFlagImportVirtualCursorToUA then
	if fFlagVirtualCursorModularization then
		require("@luauforge/bundled/iha")
	else
		require("@luauforge/bundled/ihy")
	end
end

local LocalizationProvider = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Localization/LocalizationProvider")
local designTokenProvider = require("@game/CorePackages/Workspace/Packages/Style").DesignTokenProvider
local module31 = require("@luauforge/bundled/ihL")
local module32 = require("@luauforge/bundled/iia")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local cursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local module33 = require("@luauforge/bundled/iic")
local module34 = require("@luauforge/bundled/hRI")

local ApolloClient = require(CorePackages.Packages.ApolloClient)
local apolloProvider = ApolloClient.ApolloProvider

local squadExternalContractProvider = require("@luauforge/bundled/iig").SquadExternalContractProvider
local squadLocationEnum = require("@luauforge/bundled/cAW").SquadLocationEnum
local module35 = require("@luauforge/bundled/iih")

local module36 = require("@luauforge/bundled/ily")

local module37 = require("@luauforge/bundled/ilz")
local module38 = require("@luauforge/bundled/ilA")
local module39 = require("@luauforge/bundled/ilG")

local module40 = require("@luauforge/bundled/ilM")
local module41 = require("@luauforge/bundled/ilO")

local module42 = require("@luauforge/bundled/ilP")
local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableUnifiedWebViews
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module43 = require("@luauforge/bundled/ecq")
local module44 = require("@luauforge/bundled/egY")
local module45 = require("@luauforge/bundled/egx")
local appBrowserService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppBrowserService
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local appPinShortcutService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPinShortcutService
local appSystemInfo = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSystemInfo

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService
local appLinking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLinking
local appLogging = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppLogging
local appGame = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGame
local appPermissions = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPermissions
local appPrefetch = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppPrefetch
local appRunService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppRunService
local appContentProvider = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppContentProvider
local appUserInputService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserInputService
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local module46 = require("@luauforge/bundled/ilQ")
local module47 = require("@luauforge/bundled/ecr")
local module48 = require("@luauforge/bundled/ilR")
local appUserGameSettings = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserGameSettings
local appUpdateService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUpdateService
local eventIngest = require("@luauforge/bundled/bZt").AnalyticsReporters.EventIngest
local module49 = require("@luauforge/bundled/fAc")
local module50 = require("@luauforge/bundled/gZE")
local appUpdateServiceWrapper = require("@luauforge/bundled/hWQ").AppUpdateServiceWrapper
local module51 = require("@luauforge/bundled/ime")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local requestInternalWrapper = require("@game/CorePackages/Workspace/Packages/Http").NetworkLayers.requestInternalWrapper
local module52 = require("@luauforge/bundled/imf")
local module53 = require("@luauforge/bundled/img")
local module54 = require("@luauforge/bundled/imh")
local module55 = require("@luauforge/bundled/imi")

local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module56 = require("@luauforge/bundled/imj")
local appStartupSequenceTag = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupSequenceTag
local createPerformFetchMiddleware = require("@game/CorePackages/Workspace/Packages/Http").createPerformFetchMiddleware
local appStartupMessageService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupMessageService

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local appFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").AppFeaturePolicies
local chatPolicies = require("@luauforge/bundled/imt").ChatPolicies
local avatarPolicies = require("@luauforge/bundled/imu").AvatarPolicies
local sharePolicies = require("@luauforge/bundled/imt").SharePolicies
local shareTargetGamePolicies = require("@luauforge/bundled/imt").ShareTargetGamePolicies

local fVariable = tonumber(settings():GetFVariable("LuaAnalyticsReleasePeriod"))
local module57 = require("@luauforge/bundled/imv")

local module58 = require("@luauforge/bundled/imw")

local module59 = require("@luauforge/bundled/dKx")
local homePageLoadTracker = require("@luauforge/bundled/hQG").HomePageLoadTracker
local module60 = require("@luauforge/bundled/dzN")
local module61 = require("@luauforge/bundled/imx")

local getLegacyRouteFromRoactNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Utils.getLegacyRouteFromRoactNavigationState
local startupMessageContainer = require("@luauforge/bundled/cBa").StartupMessageContainer
local socialGraphSyncManager = require("@luauforge/bundled/imy").SocialGraphSyncManager

local feedbackManagerInjectionContextProvider = require("@luauforge/bundled/gKs").FeedbackManagerInjectionContextProvider

local appInteractionFeedbackProvider = require("@luauforge/bundled/imQ").AppInteractionFeedbackProvider

local discoveryAppLaunchTracker = require("@luauforge/bundled/hPY").DiscoveryAppLaunchTracker
local bugReporterEventReceiver = require("@luauforge/bundled/hYR").BugReporterEventReceiver

local module62 = require("@luauforge/bundled/imR")
local appGamepadDisconnectHandler

if SharedFlags.FFlagMoveGamepadDisconnectHandlerToUniversalApp then
	appGamepadDisconnectHandler = require("@luauforge/bundled/imT").AppGamepadDisconnectHandler
else
	appGamepadDisconnectHandler = nil
end

if require("@luauforge/bundled/ind")() then
	local success2, result2 = pcall(function()
		return require("@luauforge/bundled/ine")
	end)

	if success2 then
		result2.runBootcamp()
	else
		warn("Failed to require Bootcamp modules.")
	end
end

local v7 = {
	FIntLuaAppBatchFetchingStatusDelayMs = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLuaAppBatchFetchingStatusDelayMs,
	GetFFlagInjectAnalyticsService = require("@luauforge/bundled/hRd"),
	GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled,
	FFlagUseSessionServiceWrapper = require("@luauforge/bundled/ioz"),
	FFlagLuaAppLaunchTrackThunks = require("@luauforge/bundled/hPY").Flags.FFlagLuaAppLaunchTrackThunks,
	GetFFlagEnableAndroidWidgetsLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAndroidWidgetsLuaIXP,
	GetFFlagEnableIOSUIRefactorLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableIOSUIRefactorLuaIXP,
	GetFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableInAppBugReporting,
	FFlagShareTargetGameCleanup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagShareTargetGameCleanup,
	FFlagEnableReadAloudInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableReadAloudInUA(),
	FFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUseAppHttpStore,
	GetFFlagEnableIosAuthServiceLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableIosAuthServiceLuaIXP,
	FFlagLuaAppHomePageLoadTracker = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHomePageLoadTracker,
	FFlagLuaAppDesignFoundationsBridge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesignFoundationsBridge,
	FFlagAppChatConversationStore = require("@luauforge/bundled/ioA"),
	FFlagLuaAppReactTreeUnmountCounter = game:DefineFastFlag("LuaAppReactTreeUnmountCounter", false),
	FFlagLuaAppRootUnmountQuitTiming = require("@luauforge/bundled/ioB"),
	FFlagDebugEnablePopLatencyOverlayForAdmins = game:DefineFastFlag(
		"DebugEnablePopLatencyOverlayForAdmins",
		false
	),
	trackStart = require("@luauforge/bundled/fCP").TimeToInteractiveTracker.trackStart,
	FFlagLuaAppEnableRoRumRouteTracker = require("@luauforge/bundled/ioC"),
	FFlagFocusNavigationRefocusSuppression = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFocusNavigationRefocusSuppression,
	FFlagLuaAppNavTTIMeasurementV2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppNavTTIMeasurementV2,
	markNavigationCommitted = require("@luauforge/bundled/ioD").markCommitted
}
local v8, v9

if v7.FFlagLuaAppUseAppHttpStore then
	v8 = require("@luauforge/bundled/ioE")
	v9 = require("@luauforge/bundled/ggg")
else
	v8 = nil
	v9 = nil
end

local v10 = if v7.FFlagLuaAppReactTreeUnmountCounter then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/CoreScriptsErrorBoundary/ReactTreeCrashedConfig") else nil

local v11 = {
	AvatarSceneInteractionProvider = require("@luauforge/bundled/ioG"),
	BodyDataProvider = require("@luauforge/bundled/ioJ"),
	AdjustmentDataProvider = require("@luauforge/bundled/ioL"),
	AppliedDescriptionProvider = require("@luauforge/bundled/ioN"),
	AvatarSaveContextProvider = require("@luauforge/bundled/gKz").Context.AvatarSaveContextProvider
}

local module63 = require("@luauforge/bundled/ioP")
local module64 = require("@game/CoreGui/RobloxGui/Modules/ApolloClient/ApolloClient")
local module65 = require("@luauforge/bundled/dFA")
local module66 = require("@luauforge/bundled/iqm")
local v12 = if SharedFlags.FFlagSignalsNavPendingLock then require("@luauforge/bundled/hTO") else nil

local module67 = require("@luauforge/bundled/gJs")
local module68 = require("@luauforge/bundled/iqn")
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local v13 = if SharedFlags.FFlagUseSignalsNavigation then require("@luauforge/bundled/dFy") else nil

local v14 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then require("@luauforge/bundled/dIW") else nil

local function createAppContainer(module70)
	local extended = Roact.PureComponent:extend("NavigationAppContainer")
	extended.router = module70.router
	function extended.render(p2)
		return p2.props.children
	end

	if SharedFlags.FFlagSignalsNavPendingLock then
		function extended:didMount()
			if self.props.connectActionEvents then
				self._disconnectActionEvents = self.props.connectActionEvents(self.props.navigation)
			end

			self._disconnectAppHide = v12.connect(game:GetService("AppLifecycleObserverService"))
		end
		function extended:willUnmount()
			if self._disconnectActionEvents then
				self._disconnectActionEvents()
				self._disconnectActionEvents = nil
			end

			self._disconnectAppHide()
			self._disconnectAppHide = nil
		end
	end

	return RoactNavigation.createAppContainer(extended)
end

local function UserAgreementsManager(): nil
	useUserAgreements()
	return nil
end

local v15

if SharedFlags.FFlagUseSignalsRoduxStore then
	v15 = require("@luauforge/bundled/dzk").createStore
else
	v15 = Rodux.Store.new
end

local extended = Roact.Component:extend("UniversalApp")

if not v7.GetFFlagInjectAnalyticsService() then
	RbxAnalyticsService = nil
end

local v17 = if v7.GetFFlagInjectAnalyticsService() then IXPService else nil
extended.defaultProps = {
	httpService = HttpService,
	rbxAnalyticsService = RbxAnalyticsService,
	ixpService = v17
}

function extended:init()
	LoggingProtocol.default:logEventOnce("universal_app_init_begin")

	self._pageObjectManager = module15.new()

	local v18 = {
		avatarEditorService = AvatarEditorService,
		pageObjectManager = self._pageObjectManager
	}

	local v20 = { if v7.FFlagLuaAppLaunchTrackThunks and discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then discoveryAppLaunchTracker.default.roduxTracker:makeThunkMiddleware(v18) else Rodux.makeThunkMiddleware(v18) }

	if not fFlagSignalsNavP2NavigationPrimitives then
		self._rnBypassActionSignal = selfViewVisibilityUpdatedSignal.new()
		table.insert(v20, (module59.middleware(function(p2)
			local navigationTarget = resolveNavigationTarget(p2)

			if navigationTarget then
				v7.trackStart("NavigateTo_" .. navigationTarget, true)
			end

			if v7.FFlagLuaAppHomePageLoadTracker and navigationTarget == "Home" then
				homePageLoadTracker.beginVisit()
			end

			self._rnBypassActionSignal:fire(p2)
		end)))
	end

	table.insert(v20, createPerformFetchMiddleware(v7.FIntLuaAppBatchFetchingStatusDelayMs / 1000))

	if module41 then
		table.insert(v20, module40)
	end

	if v7.FFlagAppChatConversationStore then
		table.insert(v20, require("@luauforge/bundled/iqO"))
	end

	if module42 then
		table.insert(v20, require("@luauforge/bundled/iqY"))
	end

	table.insert(v20, require("@luauforge/bundled/ira"))

	if fFlagUseSignalsForSquadExperienceInvite then
		table.insert(v20, require("@luauforge/bundled/irc").SignalsSquadMiddleware)
	end

	local module70 = require("@luauforge/bundled/irf")
	local module71 = require("@luauforge/bundled/irg")
	table.insert(v20, module70.createSignalsMiddleware(module71))

	local v21 = module28(module27)
	local v22

	if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
		v22 = _G.__RODUX_STORE_DEV_TOOLS__ or discoveryAppLaunchTracker.default.roduxTracker
	else
		v22 = _G.__RODUX_STORE_DEV_TOOLS__
	end

	self._store = v15(module7, nil, v20, v21, v22)

	local v23 = if not (SharedFlags.FFlagUseSignalsNavigation and not SharedFlags.FFlagSignalsNavProjected) then createAppContainer(module65) else nil
	self._appContainer = v23

	local v24 = if v7.GetFFlagInjectAnalyticsService() then module6.new(self.props.rbxAnalyticsService) else module6.new()
	self._analytics = v24

	self._systemInfo = systemInfoProtocol.default
	self._linking = linkingProtocol.default
	self._logging = LoggingProtocol.default
	self._game = gameProtocol.default
	self._permissions = permissionsProtocol.default
	self._prefetch = prefetchProtocol.default
	self._externalContentSharing = externalContentSharingProtocol.default
	self._localization = localization.new(LocalizationService.RobloxLocaleId)
	self._guiService = GuiService

	if v7.FFlagLuaAppUseAppHttpStore then
		self._appHttpStore = v8(
			self._store,
			requestInternalWrapper(self.props.httpService),
			self._guiService
		)
	end

	local v25 = if v7.FFlagUseSessionServiceWrapper then module46 else SessionService
	self._sessionService = v25
	self._startupMessage = StartupMessageService
	self._eventIngest = eventIngest.new(EventIngestService)
	self._appUpdate = appUpdateServiceWrapper.new(AppUpdateService)
	self._commonGameEvents = module56.get(SessionService, self._analytics, self._eventIngest)
	self._appStartupSequence = require("@luauforge/bundled/cBa").AppStartupSequence.default
	self._focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(
		ReactFocusNavigation.EngineInterface.CoreGui,
		{
			shouldSuppressContainerRefocus = v7.FFlagFocusNavigationRefocusSuppression and function()
				return GamepadService.GamepadCursorEnabled
			end or nil
		}
	)

	pcall(function()
		self._appLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	end)

	self.routeSignal = selfViewVisibilityUpdatedSignal.new()

	function self._updateRoute(p2)
		local legacyRouteFromRoactNavigationState = getLegacyRouteFromRoactNavigationState(p2)
		self.routeSignal:fire(legacyRouteFromRoactNavigationState)
	end

	function self._connectRouteSignal(p2)
		return self.routeSignal:connect(p2)
	end

	if v7.FFlagLuaAppNavTTIMeasurementV2 then
		local v26 = module67("UniversalApp")
		function self._onRoduxNavigationStateChange(p2, p3, p4)
			v7.markNavigationCommitted(p4)
			v26(p2, p3, p4)
		end
	end

	if SharedFlags.FFlagSignalsNavProjected then
		local v29 = if v7.FFlagLuaAppNavTTIMeasurementV2 then v7.markNavigationCommitted else nil
		self._navigationProjection = module66(v13, {
			onCommitted = v29,
			onStateChange = self._updateRoute
		})
	end

	self._handleSessionsUpdated = SharedFlags.FFlagEnableSplitPaneSessionL3 and function()
		v14.SplitL3SessionHelper.onSessionsUpdated()
	end or nil

	module23:connectToStore(self._store)

	self._appRequestService = module48(
		requestInternalWrapper(self.props.httpService),
		self._store,
		self._guiService
	)

	self._achievementManager = inAppAchievementManager.new(self._store)

	self._profilerContext = RoactUtils.Profiling.createReactProfilerContext()
	module13.createAppLaunchReactProfilerLogger(self._profilerContext, "home_page_interactive")

	module68()

	if v7.FFlagEnableReadAloudInUA then
		require("@luauforge/bundled/irt").ConnectReadAloudToSettings()
	end

	LoggingProtocol.default:logEventOnce("universal_app_init_end")
end

function extended:appendRoactServiceProviders(list)
	local v18 = { class = roactServices.ServiceProvider, props = 0 }

	local v20 = {
		[module43] = self._analytics,
		[module44] = self._localization,
		[module45] = self._appRequestService
	}
	local v22 = if not getFFlagEnableUnifiedWebViews() then BrowserService else nil
	v20[appBrowserService] = v22
	v20[appNotificationService] = NotificationService
	v20[appGuiService] = self._guiService
	v20[appPinShortcutService] = v5
	v20[appSystemInfo] = self._systemInfo
	v20[appLinking] = self._linking
	v20[appLogging] = self._logging
	v20[appGame] = self._game
	v20[appPermissions] = self._permissions
	v20[appPrefetch] = self._prefetch
	v20[appRunService] = RunService
	v20[appContentProvider] = ContentProvider
	v20[appUserInputService] = UserInputService
	v20[appAppLifecycleObserverService] = self._appLifecycleObserverService
	v20[appSessionService] = self._sessionService
	v20[module47] = self._eventIngest
	v20[appUserGameSettings] = UserGameSettings
	v20[appUpdateService] = self._appUpdate
	v20[roactAnalyticsCommonGameEvents] = self._commonGameEvents
	v20[appStartupSequenceTag] = self._appStartupSequence
	v20[appStartupMessageService] = self._startupMessage
	v18.props = { services = v20 }
	table.insert(list, v18)
end

function extended:render()
	local appName = self.props.appName

	local v19 = {}

	table.insert(v19, {
		class = reactProfilerContext.Provider,
		props = { value = self._profilerContext }
	})

	table.insert(v19, {
		class = reactProfiler,
		props = { id = "UniversalApp" }
	})

	if SharedFlags.FFlagSignalsNavProjected then
		table.insert(v19, {
			class = self._appContainer,
			props = self._navigationProjection.containerProps
		})
	elseif SharedFlags.FFlagUseSignalsNavigation then
		table.insert(v19, {
			class = Navigation.SignalsNavigationContainer,
			props = { navigation = v13 }
		})
	else
		local v20 = { class = self._appContainer, props = 0 }

		local v22 = if v7.FFlagLuaAppNavTTIMeasurementV2 then self._onRoduxNavigationStateChange else module67("UniversalApp")
		v20.props = { onNavigationStateChange = v22 }
		table.insert(v19, v20)
	end

	local v20 = { class = RoactAppExperiment.Provider, props = 0 }

	local v22 = if v7.GetFFlagInjectAnalyticsService() then self.props.ixpService else IXPService
	v20.props = { value = v22 }
	table.insert(v19, v20)

	table.insert(v19, {
		class = RoactRodux.StoreProvider,
		props = { store = self._store }
	})

	local v23 = { class = roactAppPolicy.Provider, props = 0 }

	local v30 = if not v7.FFlagShareTargetGameCleanup then shareTargetGamePolicies else nil
	local v24 = {
		policy = {
			appFeaturePolicies,
			chatPolicies,
			avatarPolicies,
			sharePolicies,
			v30
		},
		policyData = 0
	}

	local v31 = if v7.GetFFlagInjectAnalyticsService() then self.props.policyData else nil
	v24.policyData = v31
	v23.props = v24
	table.insert(v19, v23)

	self:appendRoactServiceProviders(v19)

	table.insert(v19, {
		class = module10,
		props = {
			style = { themeName = "dark", fontName = "gotham" }
		}
	})

	if v7.FFlagLuaAppDesignFoundationsBridge then
		table.insert(v19, { class = module11 })
	end

	table.insert(v19, {
		class = designTokenProvider,
		props = { tokenMappers = module31 }
	})

	table.insert(v19, { class = module32 })

	table.insert(v19, {
		class = module33,
		props = { theme = module34, themeName = "dark" }
	})

	table.insert(v19, {
		class = LocalizationProvider,
		props = { localization = self._localization }
	})

	table.insert(v19, {
		class = ReactFocusNavigation.FocusNavigationContext.Provider,
		props = { value = self._focusNavigationService }
	})

	table.insert(v19, { class = provider })

	if SharedFlags.FFlagEnableSplitPane then
		local v32 = { class = require("@luauforge/bundled/irL"), props = 0 }

		local v34 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then self._connectRouteSignal else nil
		v32.props = { connectRouteSignal = v34 }
		table.insert(v19, v32)
	end

	table.insert(v19, { class = v11.AvatarSceneInteractionProvider })

	table.insert(v19, { class = v11.BodyDataProvider })

	table.insert(v19, { class = v11.AdjustmentDataProvider })

	table.insert(v19, { class = v11.AppliedDescriptionProvider })

	table.insert(v19, { class = v11.AvatarSaveContextProvider })

	table.insert(v19, { class = module49.Provider })

	table.insert(v19, {
		class = module50.Provider,
		props = { pageObjectManager = self._pageObjectManager }
	})

	table.insert(v19, {
		class = apolloProvider,
		props = { client = module64 }
	})

	table.insert(v19, { class = appInteractionFeedbackProvider })

	table.insert(v19, { class = feedbackManagerInjectionContextProvider })

	table.insert(v19, { class = Responsive.ResponsiveProvider })

	if v7.GetFFlagIsSquadEnabled() then
		table.insert(v19, {
			class = squadExternalContractProvider,
			props = {
				contract = module38,
				squadLocation = squadLocationEnum.UniversalApp
			}
		})
	end

	table.insert(v19, { class = module36 })

	local modules = {}

	table.insert(modules, module58)

	table.insert(modules, module52)

	if v7.GetFFlagEnableAndroidWidgetsLuaIXP() then
		table.insert(modules, module53)
	end

	if v7.GetFFlagEnableIOSUIRefactorLuaIXP() then
		table.insert(modules, module54)
	end

	if v7.GetFFlagEnableIosAuthServiceLuaIXP() then
		table.insert(modules, module55)
	end

	local children = {
		EventReceivers = Roact.createElement(module35),
		MemStorageSubscribers = next(modules) and Roact.createElement(module17, {
			receiverComponents = modules
		}) or nil,
		LocalPlayerManager = Roact.createElement(module18),
		ViewportManager = Roact.createElement(module19),
		FrameRateManager = Roact.createElement(module20),
		LocaleManager = Roact.createElement(module21, {
			localization = self._localization
		}),
		EventStreamUpdater = Roact.createElement(module14, { releasePeriod = fVariable }),
		LocalStorageListener = Roact.createElement(module22),
		MutedErrorReporter = Roact.createElement(module16, { appName = appName }),
		BacktraceReporterAdaptor = Roact.createElement(module37),
		SessionManager = 0,
		RoRumRouteTracker = 0,
		UserHeartbeatsManager = 0,
		SiteAlertManager = 0,
		AppBackgroundSoundManager = 0,
		AppUpdateManager = 0,
		UserAgreementsManager = 0,
		AppReadyHandler = 0,
		RnBypassAdapter = 0,
		AppChatToastManagerUA = 0,
		AppFriendsCallingCallPip = 0,
		AppConfigurer = 0,
		MonolithSduiRegister = 0,
		StartupMessageContainer = 0,
		BugReporterEventReceiver = 0,
		SocialGraphSyncManager = 0,
		MouseCursorHandler = 0,
		AppGamepadDisconnectHandler = 0,
		PostAppInteractiveLoader = 0,
		PopLatencyOverlay = 0
	}
	local createElement = Roact.createElement
	local v33 = {
		connectRouteSignal = self._connectRouteSignal,
		onSessionsUpdated = self._handleSessionsUpdated,
		getL2Exclusions = 0
	}
	local v34 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then v14.SplitL3SessionHelper.createGetL2Exclusions(module65.router) else nil
	v33.getL2Exclusions = v34
	children.SessionManager = createElement(module24, v33)

	local v35 = if v7.FFlagLuaAppEnableRoRumRouteTracker then Roact.createElement(module25) else nil
	children.RoRumRouteTracker = v35

	children.UserHeartbeatsManager = Roact.createElement(module26)
	children.SiteAlertManager = Roact.createElement(module29)
	local v36 = if module61() then Roact.createElement(module57) else nil
	children.AppBackgroundSoundManager = v36

	children.AppUpdateManager = Roact.createElement(module51)

	local v37 = if not (fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()) then Roact.createElement(UserAgreementsManager) else nil
	children.UserAgreementsManager = v37

	children.AppReadyHandler = Roact.createElement(appReadyHandler)

	local v38 = if not fFlagSignalsNavP2NavigationPrimitives then Roact.createElement(rnBypassAdapter, {
		rnBypassActionSignal = self._rnBypassActionSignal,
		ApplyRoactNavigationHistory = module60,
		updateRoute = self._updateRoute
	}) else nil
	children.RnBypassAdapter = v38

	children.AppChatToastManagerUA = Roact.createElement(module39)

	local v39 = if v6 then Roact.createElement(v6) else nil
	children.AppFriendsCallingCallPip = v39

	children.AppConfigurer = Roact.createElement(module8, { store = self._store })

	local v40 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(module9) else nil
	children.MonolithSduiRegister = v40

	children.StartupMessageContainer = Roact.createElement(startupMessageContainer)
	local v41 = if v7.GetFFlagEnableInAppBugReporting() then Roact.createElement(bugReporterEventReceiver) else nil
	children.BugReporterEventReceiver = v41

	children.SocialGraphSyncManager = Roact.createElement(socialGraphSyncManager)
	children.MouseCursorHandler = Roact.createElement(module62)

	local v42 = if appGamepadDisconnectHandler then Roact.createElement(appGamepadDisconnectHandler) else nil
	children.AppGamepadDisconnectHandler = v42

	children.PostAppInteractiveLoader = Roact.createElement(module63)
	local v43

	if SharedFlags.FFlagEnablePopLatencyOverlay then
		v43 = Roact.createElement(module2.default)
	elseif v7.FFlagDebugEnablePopLatencyOverlayForAdmins then
		v43 = Roact.createElement(module2.adminOnly)
	end

	children.PopLatencyOverlay = v43

	return Roact.createElement(providerContainer, { providers = v19 }, {
		CursorProvider = Roact.createElement(selectionCursorProvider, {}, {
			NewCursorProvider = Roact.createElement(cursorProvider, {}, children)
		})
	})
end

function extended.didMount(p2)
	if v7.FFlagLuaAppRootUnmountQuitTiming then
		pcall(function()
			require("@luauforge/bundled/irO").reportPreviousUnmount()
		end)
	end
end

function extended:willUnmount()
	if v7.FFlagLuaAppRootUnmountQuitTiming then
		pcall(function()
			require("@luauforge/bundled/irO").recordUnmount()
		end)
	end

	if SharedFlags.FFlagSignalsNavDeferProjection then
		self._navigationProjection.invalidate()
	end

	if v7.FFlagLuaAppReactTreeUnmountCounter then
		LoggingProtocol.default:logRobloxTelemetryCounter(v10, 1)
	end

	if v7.FFlagLuaAppUseAppHttpStore then
		v9.Instance._dispose()
	end
end

return extended
