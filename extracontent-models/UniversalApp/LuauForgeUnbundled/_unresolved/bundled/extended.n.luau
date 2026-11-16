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

local module2 = require("@luauforge/bundled/vQ")

local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local module3 = require("@luauforge/bundled/wc")
local module4 = require("@luauforge/bundled/AF")
require("@luauforge/bundled/AH")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local systemInfoProtocol = require("@luauforge/bundled/bXg").SystemInfoProtocol
local linkingProtocol = require("@luauforge/bundled/bXh").LinkingProtocol
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local gameProtocol = require("@luauforge/bundled/bXj").GameProtocol
local permissionsProtocol = require("@luauforge/bundled/bXk").PermissionsProtocol
local prefetchProtocol = require("@luauforge/bundled/bXl").PrefetchProtocol
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local externalContentSharingProtocol = require("@luauforge/bundled/bXs").ExternalContentSharingProtocol

local selfViewVisibilityUpdatedSignal = require("@game/CoreGui/RobloxGui/Modules/SelfView/selfViewVisibilityUpdatedSignal")
local module8 = require("@luauforge/bundled/bXv")
local module9 = require("@luauforge/bundled/bXx")
local useUserAgreements = require("@luauforge/bundled/fOd").useUserAgreements
local isPioneerLaunch = require("@luauforge/bundled/fDJ").isPioneerLaunch
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local module10 = require("@luauforge/bundled/hKm")
local module11 = require("@luauforge/bundled/hVm")
local module12 = require("@luauforge/bundled/hVr")
local module13 = require("@luauforge/bundled/hVv")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local providerContainer = RoactUtils.Components.ProviderContainer
local reactProfiler = RoactUtils.Profiling.ReactProfiler
local reactProfilerContext = RoactUtils.Profiling.ReactProfilerContext
local module15 = require("@luauforge/bundled/hSC")
local module16 = require("@luauforge/bundled/hVw")
local module17 = require("@luauforge/bundled/AI")
local module18 = require("@luauforge/bundled/hVx")
local module19 = require("@luauforge/bundled/hWG")
local module20 = require("@luauforge/bundled/hWH")
local module21 = require("@luauforge/bundled/hWJ")
local module22 = require("@luauforge/bundled/hWN")
local module23 = require("@luauforge/bundled/hWO")
local module24 = require("@luauforge/bundled/hWP")
local module25 = require("@luauforge/bundled/B")
local module26 = require("@luauforge/bundled/hWQ")
local module27 = require("@luauforge/bundled/hWS")
local module28 = require("@luauforge/bundled/hWT")
local UIBlox = require(CorePackages.Packages.UIBlox)
local module29 = require("@luauforge/bundled/dCn")
local module30 = require("@luauforge/bundled/hWX")
local module31 = require("@luauforge/bundled/hXc")
local inAppAchievementManager = require("@luauforge/bundled/dyP").InAppAchievementManager

local provider = require("@luauforge/bundled/eeo").FocusNavigableSurfaceRegistry.Provider
local appReadyHandler = require("@luauforge/bundled/dCw").AppReadyHandler
local rnBypassAdapter = require("@luauforge/bundled/dCw").RnBypassAdapter
local fFlagImportVirtualCursorToUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagImportVirtualCursorToUA

local fFlagVirtualCursorModularization = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagVirtualCursorModularization

if fFlagImportVirtualCursorToUA then
	if fFlagVirtualCursorModularization then
		require("@luauforge/bundled/hXd")
	else
		require("@luauforge/bundled/hXy")
	end
end

local LocalizationProvider = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Localization/LocalizationProvider")
local designTokenProvider = require("@game/CorePackages/Workspace/Packages/Style").DesignTokenProvider
local module33 = require("@luauforge/bundled/hXL")
local module34 = require("@luauforge/bundled/hYa")
local selectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local cursorProvider = UIBlox.App.SelectionCursor.CursorProvider

local module35 = require("@luauforge/bundled/hYc")
local module36 = require("@luauforge/bundled/hHb")

local ApolloClient = require(CorePackages.Packages.ApolloClient)
local apolloProvider = ApolloClient.ApolloProvider

local squadExternalContractProvider = require("@luauforge/bundled/hYg").SquadExternalContractProvider
local squadLocationEnum = require("@luauforge/bundled/cyI").SquadLocationEnum
local module37 = require("@luauforge/bundled/hYh")

local module38 = require("@luauforge/bundled/idd")

local module39 = require("@luauforge/bundled/ide")
local module40 = require("@luauforge/bundled/idf")
local module41 = require("@luauforge/bundled/idl")

local module42 = require("@luauforge/bundled/idr")
local module43 = require("@luauforge/bundled/idt")

local module44 = require("@luauforge/bundled/idu")
local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableUnifiedWebViews
local fFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local fFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module45 = require("@luauforge/bundled/dYT")
local module46 = require("@luauforge/bundled/edB")
local module47 = require("@luauforge/bundled/eda")
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
local module48 = require("@luauforge/bundled/idv")
local module49 = require("@luauforge/bundled/dYU")
local module50 = require("@luauforge/bundled/idw")
local appUserGameSettings = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUserGameSettings
local appUpdateService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppUpdateService
local eventIngest = require("@luauforge/bundled/bXw").AnalyticsReporters.EventIngest
local module51 = require("@luauforge/bundled/fsI")
local module52 = require("@luauforge/bundled/gNz")
local appUpdateServiceWrapper = require("@luauforge/bundled/hMi").AppUpdateServiceWrapper
local module53 = require("@luauforge/bundled/idJ")
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local requestInternalWrapper = require("@game/CorePackages/Workspace/Packages/Http").NetworkLayers.requestInternalWrapper
local module54 = require("@luauforge/bundled/idK")
local module55 = require("@luauforge/bundled/idL")
local module56 = require("@luauforge/bundled/idM")
local module57 = require("@luauforge/bundled/idN")

local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module58 = require("@luauforge/bundled/idO")
local appStartupSequenceTag = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupSequenceTag
local createPerformFetchMiddleware = require("@game/CorePackages/Workspace/Packages/Http").createPerformFetchMiddleware
local appStartupMessageService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppStartupMessageService

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local appFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").AppFeaturePolicies
local chatPolicies = require("@luauforge/bundled/idU").ChatPolicies
local avatarPolicies = require("@luauforge/bundled/idV").AvatarPolicies
local sharePolicies = require("@luauforge/bundled/idU").SharePolicies
local shareTargetGamePolicies = require("@luauforge/bundled/idU").ShareTargetGamePolicies

local fVariable = tonumber(settings():GetFVariable("LuaAnalyticsReleasePeriod"))
local module59 = require("@luauforge/bundled/idW")

local module60 = require("@luauforge/bundled/idX")

local module61 = require("@luauforge/bundled/dHs")
local homePageLoadTracker = require("@luauforge/bundled/hFF").HomePageLoadTracker
local module62 = require("@luauforge/bundled/dwK")
local module63 = require("@luauforge/bundled/idY")

local getLegacyRouteFromRoactNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Utils.getLegacyRouteFromRoactNavigationState
local startupMessageContainer = require("@luauforge/bundled/cyM").StartupMessageContainer
local socialGraphSyncManager = require("@luauforge/bundled/idZ").SocialGraphSyncManager

local feedbackManagerInjectionContextProvider = require("@luauforge/bundled/gfM").FeedbackManagerInjectionContextProvider

local appInteractionFeedbackProvider = require("@luauforge/bundled/ier").AppInteractionFeedbackProvider

local discoveryAppLaunchTracker = require("@luauforge/bundled/hEX").DiscoveryAppLaunchTracker
local bugReporterEventReceiver = require("@luauforge/bundled/hOk").BugReporterEventReceiver

local module64 = require("@luauforge/bundled/ies")
local appGamepadDisconnectHandler

if SharedFlags.FFlagMoveGamepadDisconnectHandlerToUniversalApp then
	appGamepadDisconnectHandler = require("@luauforge/bundled/ieu").AppGamepadDisconnectHandler
else
	appGamepadDisconnectHandler = nil
end

if require("@luauforge/bundled/ieE")() then
	local success2, result2 = pcall(function()
		return require("@luauforge/bundled/ieF")
	end)

	if success2 then
		result2.runBootcamp()
	else
		warn("Failed to require Bootcamp modules.")
	end
end

local v6 = {
	FIntLuaAppBatchFetchingStatusDelayMs = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLuaAppBatchFetchingStatusDelayMs,
	GetFFlagInjectAnalyticsService = require("@luauforge/bundled/hGh"),
	GetFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled,
	FFlagUseSessionServiceWrapper = require("@luauforge/bundled/igb"),
	FFlagLuaAppLaunchTrackThunks = require("@luauforge/bundled/hEX").Flags.FFlagLuaAppLaunchTrackThunks,
	GetFFlagEnableAndroidWidgetsLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableAndroidWidgetsLuaIXP,
	GetFFlagEnableIOSUIRefactorLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableIOSUIRefactorLuaIXP,
	GetFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableInAppBugReporting,
	FFlagShareTargetGameCleanup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagShareTargetGameCleanup,
	FFlagEnableReadAloudInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableReadAloudInUA(),
	FFlagLuaAppUseAppHttpStore = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppUseAppHttpStore,
	GetFFlagEnableIosAuthServiceLuaIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableIosAuthServiceLuaIXP,
	FFlagLuaAppHomePageLoadTracker = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHomePageLoadTracker,
	FFlagLuaAppDesignFoundationsBridge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDesignFoundationsBridge,
	FFlagAppChatConversationStore = require("@luauforge/bundled/igc"),
	FFlagLuaAppReactTreeUnmountCounter = game:DefineFastFlag("LuaAppReactTreeUnmountCounter", false),
	FFlagLuaAppRootUnmountQuitTiming = require("@luauforge/bundled/igd"),
	FFlagDebugEnablePopLatencyOverlayForAdmins = game:DefineFastFlag(
		"DebugEnablePopLatencyOverlayForAdmins",
		false
	),
	trackStart = require("@luauforge/bundled/fvo").TimeToInteractiveTracker.trackStart,
	FFlagLuaAppEnableRoRumRouteTracker = require("@luauforge/bundled/ige"),
	FFlagFocusNavigationRefocusSuppression = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFocusNavigationRefocusSuppression
}
local v7, v8

if v6.FFlagLuaAppUseAppHttpStore then
	v7 = require("@luauforge/bundled/igf")
	v8 = require("@luauforge/bundled/fBN")
else
	v7 = nil
	v8 = nil
end

local v9 = if v6.FFlagLuaAppReactTreeUnmountCounter then require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/CoreScriptsErrorBoundary/ReactTreeCrashedConfig") else nil

local v10 = {
	AvatarSceneInteractionProvider = require("@luauforge/bundled/igh"),
	BodyDataProvider = require("@luauforge/bundled/igk"),
	AdjustmentDataProvider = require("@luauforge/bundled/igm"),
	AppliedDescriptionProvider = require("@luauforge/bundled/igo"),
	AvatarSaveContextProvider = require("@luauforge/bundled/gfT").Context.AvatarSaveContextProvider
}

local module65 = require("@luauforge/bundled/igq")
local module66 = require("@game/CoreGui/RobloxGui/Modules/ApolloClient/ApolloClient")
local module67 = require("@luauforge/bundled/dCv")
local module68 = require("@luauforge/bundled/ihN")

local module69 = require("@luauforge/bundled/geM")
local module70 = require("@luauforge/bundled/ihO")
local Navigation = require("@game/CorePackages/Workspace/Packages/Navigation")
local v11 = if SharedFlags.FFlagUseSignalsNavigation then require("@luauforge/bundled/dCt") else nil

local v12 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then require("@luauforge/bundled/dFR") else nil
local function getTargetPage(data)
	if data and data.action and data.action.routeName then
		return data.action.routeName
	end

	if data and data.routeName then
		return data.routeName
	end

	local v13 = data
		and data.actions
		and typeof(data.actions) == "table"
		and data.index
		and data.actions[data.index]

	if v13 then
		return getTargetPage(v13)
	end

	return nil
end

local function createAppContainer(p2)
	local extended = Roact.PureComponent:extend("NavigationAppContainer")
	extended.router = p2.router
	function extended.render(p3)
		return p3.props.children
	end

	return RoactNavigation.createAppContainer(extended)
end

local function UserAgreementsManager(): nil
	useUserAgreements()
	return nil
end

local v13

if SharedFlags.FFlagUseSignalsRoduxStore then
	v13 = require("@luauforge/bundled/dwh").createStore
else
	v13 = Rodux.Store.new
end

local extended = Roact.Component:extend("UniversalApp")

if not v6.GetFFlagInjectAnalyticsService() then
	RbxAnalyticsService = nil
end

local v15 = if v6.GetFFlagInjectAnalyticsService() then IXPService else nil
extended.defaultProps = {
	httpService = HttpService,
	rbxAnalyticsService = RbxAnalyticsService,
	ixpService = v15
}

function extended:init()
	LoggingProtocol.default:logEventOnce("universal_app_init_begin")

	self._pageObjectManager = module17.new()

	local v16 = {
		avatarEditorService = AvatarEditorService,
		pageObjectManager = self._pageObjectManager
	}

	local v18 = { if v6.FFlagLuaAppLaunchTrackThunks and discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then discoveryAppLaunchTracker.default.roduxTracker:makeThunkMiddleware(v16) else Rodux.makeThunkMiddleware(v16) }

	if not fFlagSignalsNavP2NavigationPrimitives then
		self._rnBypassActionSignal = selfViewVisibilityUpdatedSignal.new()
		table.insert(v18, (module61.middleware(function(p2)
			local targetPage = getTargetPage(p2)

			if targetPage then
				v6.trackStart("NavigateTo_" .. targetPage, true)
			end

			if v6.FFlagLuaAppHomePageLoadTracker and targetPage == "Home" then
				homePageLoadTracker.beginVisit()
			end

			self._rnBypassActionSignal:fire(p2)
		end)))
	end

	table.insert(v18, createPerformFetchMiddleware(v6.FIntLuaAppBatchFetchingStatusDelayMs / 1000))

	if module43 then
		table.insert(v18, module42)
	end

	if v6.FFlagAppChatConversationStore then
		table.insert(v18, require("@luauforge/bundled/iio"))
	end

	if module44 then
		table.insert(v18, require("@luauforge/bundled/iiq"))
	end

	table.insert(v18, require("@luauforge/bundled/iis"))

	if fFlagUseSignalsForSquadExperienceInvite then
		table.insert(v18, require("@luauforge/bundled/iiu").SignalsSquadMiddleware)
	end

	local module72 = require("@luauforge/bundled/iix")
	local module73 = require("@luauforge/bundled/iiy")
	table.insert(v18, module72.createSignalsMiddleware(module73))

	local v19 = module30(module29)
	local v20

	if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
		v20 = _G.__RODUX_STORE_DEV_TOOLS__ or discoveryAppLaunchTracker.default.roduxTracker
	else
		v20 = _G.__RODUX_STORE_DEV_TOOLS__
	end

	self._store = v13(module9, nil, v18, v19, v20)
	local v21

	if not (SharedFlags.FFlagUseSignalsNavigation and not SharedFlags.FFlagSignalsNavProjected) then
		local extended2 = Roact.PureComponent:extend("NavigationAppContainer")
		extended2.router = module67.router
		function extended2.render(p2)
			return p2.props.children
		end

		v21 = RoactNavigation.createAppContainer(extended2)
	end

	self._appContainer = v21

	local v22 = if v6.GetFFlagInjectAnalyticsService() then module8.new(self.props.rbxAnalyticsService) else module8.new()
	self._analytics = v22

	self._systemInfo = systemInfoProtocol.default
	self._linking = linkingProtocol.default
	self._logging = LoggingProtocol.default
	self._game = gameProtocol.default
	self._permissions = permissionsProtocol.default
	self._prefetch = prefetchProtocol.default
	self._externalContentSharing = externalContentSharingProtocol.default
	self._localization = localization.new(LocalizationService.RobloxLocaleId)
	self._guiService = GuiService

	if v6.FFlagLuaAppUseAppHttpStore then
		self._appHttpStore = v7(
			self._store,
			requestInternalWrapper(self.props.httpService),
			self._guiService
		)
	end

	local v23 = if v6.FFlagUseSessionServiceWrapper then module48 else SessionService
	self._sessionService = v23
	self._startupMessage = StartupMessageService
	self._eventIngest = eventIngest.new(EventIngestService)
	self._appUpdate = appUpdateServiceWrapper.new(AppUpdateService)
	self._commonGameEvents = module58.get(SessionService, self._analytics, self._eventIngest)
	self._appStartupSequence = require("@luauforge/bundled/cyM").AppStartupSequence.default
	self._focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(
		ReactFocusNavigation.EngineInterface.CoreGui,
		{
			shouldSuppressContainerRefocus = v6.FFlagFocusNavigationRefocusSuppression and function()
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

	if SharedFlags.FFlagSignalsNavProjected then
		self._navigationProjection = module68(v11, { onStateChange = self._updateRoute })
	end

	self._handleSessionsUpdated = SharedFlags.FFlagEnableSplitPaneSessionL3 and function()
		v12.SplitL3SessionHelper.onSessionsUpdated()
	end or nil

	module25:connectToStore(self._store)

	self._appRequestService = module50(
		requestInternalWrapper(self.props.httpService),
		self._store,
		self._guiService
	)

	self._achievementManager = inAppAchievementManager.new(self._store)

	self._profilerContext = RoactUtils.Profiling.createReactProfilerContext()
	module15.createAppLaunchReactProfilerLogger(self._profilerContext, "home_page_interactive")

	module70()

	if v6.FFlagEnableReadAloudInUA then
		require("@luauforge/bundled/iiL").ConnectReadAloudToSettings()
	end

	LoggingProtocol.default:logEventOnce("universal_app_init_end")
end

function extended:appendRoactServiceProviders(list)
	local v16 = { class = roactServices.ServiceProvider, props = 0 }

	local v18 = {
		[module45] = self._analytics,
		[module46] = self._localization,
		[module47] = self._appRequestService
	}
	local v20 = if not getFFlagEnableUnifiedWebViews() then BrowserService else nil
	v18[appBrowserService] = v20
	v18[appNotificationService] = NotificationService
	v18[appGuiService] = self._guiService
	v18[appPinShortcutService] = v5
	v18[appSystemInfo] = self._systemInfo
	v18[appLinking] = self._linking
	v18[appLogging] = self._logging
	v18[appGame] = self._game
	v18[appPermissions] = self._permissions
	v18[appPrefetch] = self._prefetch
	v18[appRunService] = RunService
	v18[appContentProvider] = ContentProvider
	v18[appUserInputService] = UserInputService
	v18[appAppLifecycleObserverService] = self._appLifecycleObserverService
	v18[appSessionService] = self._sessionService
	v18[module49] = self._eventIngest
	v18[appUserGameSettings] = UserGameSettings
	v18[appUpdateService] = self._appUpdate
	v18[roactAnalyticsCommonGameEvents] = self._commonGameEvents
	v18[appStartupSequenceTag] = self._appStartupSequence
	v18[appStartupMessageService] = self._startupMessage
	v16.props = { services = v18 }
	table.insert(list, v16)
end

function extended:render()
	local appName = self.props.appName

	local v17 = {}

	table.insert(v17, {
		class = reactProfilerContext.Provider,
		props = { value = self._profilerContext }
	})

	table.insert(v17, {
		class = reactProfiler,
		props = { id = "UniversalApp" }
	})

	if SharedFlags.FFlagSignalsNavProjected then
		table.insert(v17, {
			class = self._appContainer,
			props = self._navigationProjection.containerProps
		})
	elseif SharedFlags.FFlagUseSignalsNavigation then
		table.insert(v17, {
			class = Navigation.SignalsNavigationContainer,
			props = { navigation = v11 }
		})
	else
		table.insert(v17, {
			class = self._appContainer,
			props = { onNavigationStateChange = module69("UniversalApp") }
		})
	end

	local v18 = { class = RoactAppExperiment.Provider, props = 0 }

	local v20 = if v6.GetFFlagInjectAnalyticsService() then self.props.ixpService else IXPService
	v18.props = { value = v20 }
	table.insert(v17, v18)

	table.insert(v17, {
		class = RoactRodux.StoreProvider,
		props = { store = self._store }
	})

	local v21 = { class = roactAppPolicy.Provider, props = 0 }

	local v28 = if not v6.FFlagShareTargetGameCleanup then shareTargetGamePolicies else nil
	local v22 = {
		policy = {
			appFeaturePolicies,
			chatPolicies,
			avatarPolicies,
			sharePolicies,
			v28
		},
		policyData = 0
	}

	local v29 = if v6.GetFFlagInjectAnalyticsService() then self.props.policyData else nil
	v22.policyData = v29
	v21.props = v22
	table.insert(v17, v21)

	self:appendRoactServiceProviders(v17)

	table.insert(v17, {
		class = module12,
		props = {
			style = { themeName = "dark", fontName = "gotham" }
		}
	})

	if v6.FFlagLuaAppDesignFoundationsBridge then
		table.insert(v17, { class = module13 })
	end

	table.insert(v17, {
		class = designTokenProvider,
		props = { tokenMappers = module33 }
	})

	table.insert(v17, { class = module34 })

	table.insert(v17, {
		class = module35,
		props = { theme = module36, themeName = "dark" }
	})

	table.insert(v17, {
		class = LocalizationProvider,
		props = { localization = self._localization }
	})

	table.insert(v17, {
		class = ReactFocusNavigation.FocusNavigationContext.Provider,
		props = { value = self._focusNavigationService }
	})

	table.insert(v17, { class = provider })

	if SharedFlags.FFlagEnableSplitPane then
		local v30 = { class = require("@luauforge/bundled/ijd"), props = 0 }

		local v32 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then self._connectRouteSignal else nil
		v30.props = { connectRouteSignal = v32 }
		table.insert(v17, v30)
	end

	table.insert(v17, { class = v10.AvatarSceneInteractionProvider })

	table.insert(v17, { class = v10.BodyDataProvider })

	table.insert(v17, { class = v10.AdjustmentDataProvider })

	table.insert(v17, { class = v10.AppliedDescriptionProvider })

	table.insert(v17, { class = v10.AvatarSaveContextProvider })

	table.insert(v17, { class = module51.Provider })

	table.insert(v17, {
		class = module52.Provider,
		props = { pageObjectManager = self._pageObjectManager }
	})

	table.insert(v17, {
		class = apolloProvider,
		props = { client = module66 }
	})

	table.insert(v17, { class = appInteractionFeedbackProvider })

	table.insert(v17, { class = feedbackManagerInjectionContextProvider })

	table.insert(v17, { class = Responsive.ResponsiveProvider })

	if v6.GetFFlagIsSquadEnabled() then
		table.insert(v17, {
			class = squadExternalContractProvider,
			props = {
				contract = module40,
				squadLocation = squadLocationEnum.UniversalApp
			}
		})
	end

	table.insert(v17, { class = module38 })

	local modules = {}

	table.insert(modules, module60)

	table.insert(modules, module54)

	if v6.GetFFlagEnableAndroidWidgetsLuaIXP() then
		table.insert(modules, module55)
	end

	if v6.GetFFlagEnableIOSUIRefactorLuaIXP() then
		table.insert(modules, module56)
	end

	if v6.GetFFlagEnableIosAuthServiceLuaIXP() then
		table.insert(modules, module57)
	end

	local children = {
		EventReceivers = Roact.createElement(module37),
		MemStorageSubscribers = next(modules) and Roact.createElement(module19, {
			receiverComponents = modules
		}) or nil,
		LocalPlayerManager = Roact.createElement(module20),
		ViewportManager = Roact.createElement(module21),
		FrameRateManager = Roact.createElement(module22),
		LocaleManager = Roact.createElement(module23, {
			localization = self._localization
		}),
		EventStreamUpdater = Roact.createElement(module16, { releasePeriod = fVariable }),
		LocalStorageListener = Roact.createElement(module24),
		MutedErrorReporter = Roact.createElement(module18, { appName = appName }),
		BacktraceReporterAdaptor = Roact.createElement(module39),
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
	local v31 = {
		connectRouteSignal = self._connectRouteSignal,
		onSessionsUpdated = self._handleSessionsUpdated,
		getL2Exclusions = 0
	}
	local v32 = if SharedFlags.FFlagEnableSplitPaneSessionL3 then v12.SplitL3SessionHelper.createGetL2Exclusions(module67.router) else nil
	v31.getL2Exclusions = v32
	children.SessionManager = createElement(module26, v31)

	local v33 = if v6.FFlagLuaAppEnableRoRumRouteTracker then Roact.createElement(module27) else nil
	children.RoRumRouteTracker = v33

	children.UserHeartbeatsManager = Roact.createElement(module28)
	children.SiteAlertManager = Roact.createElement(module31)
	local v34 = if module63() then Roact.createElement(module59) else nil
	children.AppBackgroundSoundManager = v34

	children.AppUpdateManager = Roact.createElement(module53)

	local v35 = if not (fFlagEnablePioneerPostAuthGameJoin and isPioneerLaunch()) then Roact.createElement(UserAgreementsManager) else nil
	children.UserAgreementsManager = v35

	children.AppReadyHandler = Roact.createElement(appReadyHandler)

	local v36 = if not fFlagSignalsNavP2NavigationPrimitives then Roact.createElement(rnBypassAdapter, {
		rnBypassActionSignal = self._rnBypassActionSignal,
		ApplyRoactNavigationHistory = module62,
		updateRoute = self._updateRoute
	}) else nil
	children.RnBypassAdapter = v36

	children.AppChatToastManagerUA = Roact.createElement(module41)

	local v37 = if module4 then Roact.createElement(module3) else nil
	children.AppFriendsCallingCallPip = v37

	children.AppConfigurer = Roact.createElement(module10, { store = self._store })

	local v38 = if not SharedFlags.FFlagInitializeSduiForApp then Roact.createElement(module11) else nil
	children.MonolithSduiRegister = v38

	children.StartupMessageContainer = Roact.createElement(startupMessageContainer)
	local v39 = if v6.GetFFlagEnableInAppBugReporting() then Roact.createElement(bugReporterEventReceiver) else nil
	children.BugReporterEventReceiver = v39

	children.SocialGraphSyncManager = Roact.createElement(socialGraphSyncManager)
	children.MouseCursorHandler = Roact.createElement(module64)

	local v40 = if appGamepadDisconnectHandler then Roact.createElement(appGamepadDisconnectHandler) else nil
	children.AppGamepadDisconnectHandler = v40

	children.PostAppInteractiveLoader = Roact.createElement(module65)
	local v41

	if SharedFlags.FFlagEnablePopLatencyOverlay then
		v41 = Roact.createElement(module2.default)
	elseif v6.FFlagDebugEnablePopLatencyOverlayForAdmins then
		v41 = Roact.createElement(module2.adminOnly)
	end

	children.PopLatencyOverlay = v41

	return Roact.createElement(providerContainer, { providers = v17 }, {
		CursorProvider = Roact.createElement(selectionCursorProvider, {}, {
			NewCursorProvider = Roact.createElement(cursorProvider, {}, children)
		})
	})
end

function extended.didMount(p2)
	if v6.FFlagLuaAppRootUnmountQuitTiming then
		pcall(function()
			require("@luauforge/bundled/ijg").reportPreviousUnmount()
		end)
	end
end

function extended.willUnmount(p2)
	if v6.FFlagLuaAppRootUnmountQuitTiming then
		pcall(function()
			require("@luauforge/bundled/ijg").recordUnmount()
		end)
	end

	if v6.FFlagLuaAppReactTreeUnmountCounter then
		LoggingProtocol.default:logRobloxTelemetryCounter(v9, 1)
	end

	if v6.FFlagLuaAppUseAppHttpStore then
		v8.Instance._dispose()
	end
end

return extended
