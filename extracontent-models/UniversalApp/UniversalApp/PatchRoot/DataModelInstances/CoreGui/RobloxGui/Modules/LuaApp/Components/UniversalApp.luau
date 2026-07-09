local CoreGui = game:GetService("CoreGui")
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
local EngineFeature = game:GetEngineFeature("AutoUpgradeEngineFeatureOnly")
local v14 = EngineFeature and game:GetService("AppUpdateService") or nil
local IXPService = game:GetService("IXPService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local ContentProvider = game:GetService("ContentProvider")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local StartupMessageService = game:GetService("StartupMessageService")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Debug.LogTreeConfig)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

require(Modules.LuaApp.Types.RoduxTypes)

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local SystemInfoProtocol = require(CorePackages.Workspace.Packages.SystemInfoProtocol).SystemInfoProtocol
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local GameProtocol = require(CorePackages.Workspace.Packages.ExperienceService).GameProtocol
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol
local PrefetchProtocol = require(CorePackages.Workspace.Packages.PrefetchProtocol).PrefetchProtocol
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ExternalContentSharingProtocol = require(CorePackages.Workspace.Packages.ExternalContentSharingProtocol).ExternalContentSharingProtocol
local Signal = require(Modules.Common.Signal)
local Analytics = require(Modules.Common.Analytics)
local AppReducer = require(Modules.LuaApp.AppReducer)
local useUserAgreements = require(CorePackages.Workspace.Packages.UserAgreements).useUserAgreements
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local AppConfigurer = require(Modules.LuaApp.Components.AppConfigurer)
local AppUiModeStyleProvider = require(Modules.LuaApp.Components.AppUiModeStyleProvider)
local DesignFoundationsBridge = require(Modules.LuaApp.Components.DesignFoundationsBridge)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local ReactProfiler = RoactUtils.Profiling.ReactProfiler
local ReactProfilerContext = RoactUtils.Profiling.ReactProfilerContext
local UiShellEvents = require(CorePackages.Workspace.Packages.UiShellEvents)
local EventStreamUpdater = require(Modules.LuaApp.Components.EventStreamUpdater)
local PageObjectManager = require(Modules.AvatarExperience.Common.Managers.PageObjectManager)
local MutedErrorReporter = require(Modules.LuaApp.Components.MutedErrorReporter)
local MemStorageSubscriberLifecycleAdapter = require(Modules.LuaApp.Components.MemStorageSubscriberLifecycleAdapter)
local LocalPlayerManager = require(Modules.LuaApp.Components.LocalPlayerManager)
local ViewportManager = require(Modules.LuaApp.Components.ViewportManager)
local FrameRateManager = require(Modules.LuaApp.Components.FrameRateManager)
local LocaleManager = require(Modules.LuaApp.Components.LocaleManager)
local LocalStorageListener = require(Modules.LuaApp.Components.LocalStorageListener)
local LuaAppBacktraceLogger = require(Modules.LuaApp.LuaAppBacktraceLogger)
local SessionManager = require(Modules.LuaApp.Components.Session.SessionManager)
local UserHeartbeatsManager = require(Modules.LuaApp.Components.Session.UserHeartbeatsManager)
local UIBlox = require(CorePackages.Packages.UIBlox)
local mutedError = require(Modules.LuaApp.mutedError)
local createRoduxErrorReporter = require(Modules.LuaApp.Util.createRoduxErrorReporter)
local SiteAlertManager = require(Modules.LuaApp.Components.SiteAlertManager)
local InAppAchievementManager = require(CorePackages.Workspace.Packages.Achievements).InAppAchievementManager
local Provider = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local AppReadyHandler = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AppReadyHandler
local RnBypassAdapter = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).RnBypassAdapter
local FFlagImportVirtualCursorToUA = require(CorePackages.Workspace.Packages.SharedFlags).FFlagImportVirtualCursorToUA
local FFlagVirtualCursorModularization = require(CorePackages.Workspace.Packages.SharedFlags).FFlagVirtualCursorModularization

if FFlagImportVirtualCursorToUA then
	if FFlagVirtualCursorModularization then
		require(CorePackages.Workspace.Packages.VirtualCursorModular)
	else
		require(CorePackages.Workspace.Packages.VirtualCursor)
	end
end

local LocalizationProvider = require(Modules.LuaApp.LocalizationProvider)
local DesignTokenProvider = require(CorePackages.Workspace.Packages.Style).DesignTokenProvider
local tokenMappers = require(Modules.LuaApp.DesignTokenMappers.tokenMappers)
local AppGridProvider = require(Modules.LuaApp.Components.AppGridProvider)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local ThemeProvider = require(Modules.LuaApp.ThemeProvider)
local DeprecatedDarkTheme = require(Modules.LuaApp.Themes.DeprecatedDarkTheme)
local ApolloProvider = require(CorePackages.Packages.ApolloClient).ApolloProvider
local SquadExternalContractProvider = require(CorePackages.Workspace.Packages.SquadsCore.SquadExternalContractProvider).SquadExternalContractProvider
local SquadLocationEnum = require(CorePackages.Workspace.Packages.SquadsCore.Enums).SquadLocationEnum
local UniversalAppEventReceivers = require(Modules.LuaApp.Components.UniversalAppEventReceivers)
local VRFoundationOverlayProvider = require(Modules.LuaApp.Components.CrossPlatformCompatibility.VRFoundationOverlayProvider)
local LuaAppBacktraceReporterAdaptor = require(Modules.LuaApp.Components.LuaAppBacktraceReporterAdaptor)
local AppSquadContract = require(Modules.LuaApp.Components.Squad.AppSquadContract)
local AppChatToastManagerUA = require(CorePackages.Workspace.Packages.AppChat.AppChatToastManagerUA)
local SignalsMessageIngestionMiddleware = require(CorePackages.Workspace.Packages.AppChat.SignalsMessageIngestionMiddleware)
local FFlagAppChatSignalsMessageStore = require(CorePackages.Workspace.Packages.AppChat.FFlagAppChatSignalsMessageStore)
local GetFFlagEnableUnifiedWebViews = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableUnifiedWebViews
local FFlagEnableSignalsMiddleware = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSignalsMiddleware
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppBrowserService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppBrowserService
local AppNotificationService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppNotificationService
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local AppSystemInfo = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSystemInfo
local AppAppLifecycleObserverService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppAppLifecycleObserverService
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local AppLogging = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLogging
local AppGame = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGame
local AppPermissions = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPermissions
local AppPrefetch = require(CorePackages.Workspace.Packages.RoactServiceTags).AppPrefetch
local AppRunService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppRunService
local AppContentProvider = require(CorePackages.Workspace.Packages.RoactServiceTags).AppContentProvider
local AppUserInputService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUserInputService
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local SessionServiceWrapper = require(Modules.LuaApp.Components.Session.SessionServiceWrapper)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local wrapRequestWithMiddleware = require(Modules.LuaApp.Http.wrapRequestWithMiddleware)
local AppUserGameSettings = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUserGameSettings
local AppUpdateService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppUpdateService
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local TopBarSearchSignalContext = require(Modules.LuaApp.Context.TopBarSearchSignalContext)
local PageObjectManagerContext = require(Modules.AvatarExperience.Common.Context.PageObjectManagerContext)
local AppUpdateServiceWrapper = require(CorePackages.Workspace.Packages.RobloxAppUpdate).AppUpdateServiceWrapper
local AppUpdateManager = require(Modules.LuaApp.Components.AppUpdate.AppUpdateManager)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local requestInternalWrapper = require(CorePackages.Workspace.Packages.Http).NetworkLayers.requestInternalWrapper
local ExperienceMenuIXPPreload = require(Modules.LuaApp.Experiment.ExperienceMenuIXPPreload)
local WidgetStoreIXP = require(Modules.LuaApp.Experiment.WidgetStoreIXP)
local AndroidWidgetStoreIXP = require(Modules.LuaApp.Experiment.AndroidWidgetStoreIXP)
local IOSUIRefactorIXP = require(Modules.LuaApp.Experiment.IOSUIRefactorIXP)
local IosAuthServiceIxpStore = require(Modules.LuaApp.Experiment.IosAuthServiceIxpStore)
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local CommonGameEvents = require(Modules.LuaApp.Services.CommonGameEvents)
local AppStartupSequenceTag = require(CorePackages.Workspace.Packages.RoactServiceTags).AppStartupSequenceTag
local createPerformFetchMiddleware = require(CorePackages.Workspace.Packages.Http).createPerformFetchMiddleware
local AppStartupMessageService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppStartupMessageService
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local AppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).AppFeaturePolicies
local ChatPolicies = require(CorePackages.Workspace.Packages.SocialPolicies).ChatPolicies
local AvatarPolicies = require(CorePackages.Workspace.Packages.AvatarPolicies).AvatarPolicies
local SharePolicies = require(CorePackages.Workspace.Packages.SocialPolicies).SharePolicies
local ShareTargetGamePolicies = require(CorePackages.Workspace.Packages.SocialPolicies).ShareTargetGamePolicies
local num = tonumber(settings():GetFVariable("LuaAnalyticsReleasePeriod"))
local BackgroundSoundManager = require(Modules.LuaApp.Components.AppSound.BackgroundSoundManager)
local NativeShellEventReceiver = require(Modules.LuaApp.Components.EventReceivers.NativeShellEventReceiver)
local RNAdapterThunk = require(Modules.LuaApp.Thunks.RNAdapterThunk)
local HomePageLoadTracker = require(CorePackages.Workspace.Packages.HomePageLoadTracker).HomePageLoadTracker
local ApplyRoactNavigationHistory = require(Modules.LuaApp.Actions.ApplyRoactNavigationHistory)
local getHasBackgroundMusic = require(Modules.LuaApp.Util.getHasBackgroundMusic)
local getLegacyRouteFromRoactNavigationState = require(CorePackages.Workspace.Packages.NavigationRodux).Utils.getLegacyRouteFromRoactNavigationState
local StartupMessageContainer = require(CorePackages.Workspace.Packages.AppStartup).StartupMessageContainer
local SocialGraphSyncManager = require(CorePackages.Workspace.Packages.SocialGraphSync).SocialGraphSyncManager
local FeedbackManagerInjectionContextProvider = require(CorePackages.Workspace.Packages.InteractionFeedback).FeedbackManagerInjectionContextProvider
local AppInteractionFeedbackProvider = require(CorePackages.Workspace.Packages.RobloxAppInteractionFeedbackConfig).AppInteractionFeedbackProvider
local DiscoveryAppLaunchTracker = require(CorePackages.Workspace.Packages.AppLaunchTracker).DiscoveryAppLaunchTracker
local BugReporterEventReceiver = require(CorePackages.Workspace.Packages.BugReporting).BugReporterEventReceiver
local MouseCursorHandler = require(Modules.LuaApp.Util.MouseCursorHandler)

if require(Modules.LuaApp.Bootcamp.Util.EnableLuaAppBootcamp)() then
	local ok, result = pcall(require, Modules.LuaApp.Bootcamp.Util.LuaAppBootcampUtil)

	if ok then
		result.runBootcamp()
	else
		warn("Failed to require Bootcamp modules.")
	end
end

local t1 = {
	FIntLuaAppBatchFetchingStatusDelayMs = require(CorePackages.Workspace.Packages.SharedFlags).FIntLuaAppBatchFetchingStatusDelayMs,
	GetFFlagInjectAnalyticsService = require(Modules.LuaApp.Flags.GetFFlagInjectAnalyticsService),
	GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled,
	FFlagUseSessionServiceWrapper = require(Modules.LuaApp.Flags.FFlagLuaAppUseSessionServiceWrapper),
	FFlagLuaAppLaunchTrackThunks = require(CorePackages.Workspace.Packages.AppLaunchTracker).Flags.FFlagLuaAppLaunchTrackThunks,
	GetFFlagEnableWidgetLUAIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableWidgetLUAIXP,
	GetFFlagEnableAndroidWidgetsLuaIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAndroidWidgetsLuaIXP,
	GetFFlagEnableIOSUIRefactorLuaIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableIOSUIRefactorLuaIXP,
	FFlagEnableLockScreenWidgetLuaIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLockScreenWidgetLuaIXP,
	GetFFlagEnableInAppBugReporting = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInAppBugReporting,
	FFlagShareTargetGameCleanup = require(CorePackages.Workspace.Packages.SharedFlags).FFlagShareTargetGameCleanup,
	FFlagEnableReadAloudInUA = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReadAloudInUA(),
	FFlagLuaAppSupportFoundationOverlayInVR = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSupportFoundationOverlayInVR,
	FFlagLuaAppUseAppHttpStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppUseAppHttpStore,
	GetFFlagEnableIosAuthServiceLuaIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableIosAuthServiceLuaIXP,
	FFlagLuaAppNavigationTTITracking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppNavigationTTITracking,
	FFlagLuaAppHomePageLoadTracker = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHomePageLoadTracker,
	FFlagLuaAppDesignFoundationsBridge = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDesignFoundationsBridge,
	FFlagAppChatConversationStore = require(CorePackages.Workspace.Packages.AppChat.FFlagAppChatConversationStore),
	trackStart = require(CorePackages.Workspace.Packages.TimeToInteractiveTracker).TimeToInteractiveTracker.trackStart
}
local createAppHttpStoreWrapper = nil
local HttpStore = nil

if t1.FFlagLuaAppUseAppHttpStore then
	createAppHttpStoreWrapper = require(Modules.LuaApp.Util.createAppHttpStoreWrapper)
	HttpStore = require(CorePackages.Workspace.Packages.HttpStore)
end

local t2 = {
	AvatarSceneInteractionProvider = require(Modules.AvatarExperience.Common.Context.SceneInteractionProvider),
	BodyDataProvider = require(Modules.AvatarExperience.Common.Context.BodyDataProvider),
	AdjustmentDataProvider = require(Modules.AvatarExperience.Common.Context.AdjustmentData.AdjustmentDataProvider),
	AppliedDescriptionProvider = require(Modules.AvatarExperience.Common.Context.AppliedDescription.AppliedDescriptionProvider),
	AvatarSaveContextProvider = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.AvatarSaveContextProvider
}
local PostAppInteractiveLoader = require(Modules.LuaApp.UniversalApp.PostAppInteractiveLoader)
local ApolloClient = require(Modules.LuaApp.Components.ApolloClient)
local RootNavigator = require(Modules.LuaApp.Navigation.RootNavigator)
local makeNavigationStateLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.makeNavigationStateLogger)
local makeOmniFeedService = require(Modules.Personalization.OmniFeed.makeOmniFeedService)
local Navigation = require(CorePackages.Workspace.Packages.Navigation)
local v164 = if not SharedFlags.FFlagUseSignalsNavigation then nil else require(Modules.LuaApp.Navigation.AppNavigation)

local function getTargetPage(p1) -- line: 261
	-- upvalues: getTargetPage (copy)
	if p1 and (p1.action and p1.action.routeName) then
		return p1.action.routeName
	end

	if p1 and p1.routeName then
		return p1.routeName
	end

	if p1 and p1.actions and typeof(p1.actions) == "table" and p1.index then
		local v171 = p1.actions[p1.index]

		if v171 then
			return getTargetPage(v171)
		end
	end

	return nil
end
local function createAppContainer(p2) -- line: 277
	-- upvalues: Roact (copy), RoactNavigation (copy)
	local v173 = Roact.PureComponent:extend("NavigationAppContainer")

	v173.router = p2.router

	function v173.render(p3) -- line: 280
		return p3.props.children
	end

	return RoactNavigation.createAppContainer(v173)
end
local function UserAgreementsManager() -- line: 286
	-- upvalues: useUserAgreements (copy)
	useUserAgreements()

	return nil
end

local v168 = if not SharedFlags.FFlagUseSignalsRoduxStore then Rodux.Store.new else require(CorePackages.Workspace.Packages.SignalsRodux).createStore
local v169 = Roact.Component:extend("UniversalApp")

v169.defaultProps = {
	httpService = HttpService,
	rbxAnalyticsService = if not t1.GetFFlagInjectAnalyticsService() then nil else RbxAnalyticsService,
	ixpService = if not t1.GetFFlagInjectAnalyticsService() then nil else IXPService
}

function v169.init(p4) -- line: 307
	-- upvalues: LoggingProtocol (copy), PageObjectManager (copy), AvatarEditorService (copy), t1 (copy), DiscoveryAppLaunchTracker (copy), Rodux (copy), FFlagSignalsNavP2NavigationPrimitives (copy), Signal (copy), RNAdapterThunk (copy), getTargetPage (copy), HomePageLoadTracker (copy), createPerformFetchMiddleware (copy), FFlagAppChatSignalsMessageStore (copy), SignalsMessageIngestionMiddleware (copy), CorePackages (copy), FFlagEnableSignalsMiddleware (copy), Modules (copy), createRoduxErrorReporter (copy), mutedError (copy), v168 (copy), AppReducer (copy), SharedFlags (copy), RootNavigator (copy), Roact (copy), RoactNavigation (copy), Analytics (copy), SystemInfoProtocol (copy), LinkingProtocol (copy), GameProtocol (copy), PermissionsProtocol (copy), PrefetchProtocol (copy), ExternalContentSharingProtocol (copy), Localization (copy), LocalizationService (copy), GuiService (copy), createAppHttpStoreWrapper (ref), requestInternalWrapper (copy), SessionServiceWrapper (copy), SessionService (copy), StartupMessageService (copy), EventIngest (copy), EventIngestService (copy), EngineFeature (copy), AppUpdateServiceWrapper (copy), v14 (copy), CommonGameEvents (copy), ReactFocusNavigation (copy), getLegacyRouteFromRoactNavigationState (copy), LuaAppBacktraceLogger (copy), wrapRequestWithMiddleware (copy), InAppAchievementManager (copy), RoactUtils (copy), UiShellEvents (copy), makeOmniFeedService (copy)
	LoggingProtocol.default:logEventOnce("universal_app_init_begin")
	p4._pageObjectManager = PageObjectManager.new()

	local t3 = {
		avatarEditorService = AvatarEditorService,
		pageObjectManager = p4._pageObjectManager
	}
	local t4 = { if not t1.FFlagLuaAppLaunchTrackThunks or (not DiscoveryAppLaunchTracker.isEnabled() or not DiscoveryAppLaunchTracker.default) then Rodux.makeThunkMiddleware(t3) else DiscoveryAppLaunchTracker.default.roduxTracker:makeThunkMiddleware(t3) }

	if not FFlagSignalsNavP2NavigationPrimitives then
		p4._rnBypassActionSignal = Signal.new()
		table.insert(t4, (RNAdapterThunk.middleware(function(p5) -- line: 327
			-- upvalues: t1 (copy), getTargetPage (copy), HomePageLoadTracker (copy), p4 (copy)
			if t1.FFlagLuaAppNavigationTTITracking or t1.FFlagLuaAppHomePageLoadTracker then
				local v196 = getTargetPage(p5)

				if t1.FFlagLuaAppNavigationTTITracking and v196 then
					t1.trackStart("NavigateTo_" .. v196, true)
				end

				if t1.FFlagLuaAppHomePageLoadTracker and v196 == "Home" then
					HomePageLoadTracker.beginVisit()
				end
			end

			p4._rnBypassActionSignal:fire(p5)
		end)))
	end

	table.insert(t4, createPerformFetchMiddleware(t1.FIntLuaAppBatchFetchingStatusDelayMs / 1000))

	if FFlagAppChatSignalsMessageStore then
		table.insert(t4, SignalsMessageIngestionMiddleware)
	end

	if t1.FFlagAppChatConversationStore then
		table.insert(t4, require(CorePackages.Workspace.Packages.AppChat.SignalsConversationMiddleware))
	end

	if FFlagEnableSignalsMiddleware then
		local SignalsMiddleware = require(CorePackages.Workspace.Packages.SignalsMiddleware)
		local AppSignalsActionHandlers = require(Modules.LuaApp.AppSignalsActionHandlers)

		table.insert(t4, SignalsMiddleware.createSignalsMiddleware(AppSignalsActionHandlers))
	end

	local v179 = createRoduxErrorReporter(mutedError)
	local v180 = if not DiscoveryAppLaunchTracker.isEnabled() or not DiscoveryAppLaunchTracker.default then _G.__RODUX_STORE_DEV_TOOLS__ else _G.__RODUX_STORE_DEV_TOOLS__ or DiscoveryAppLaunchTracker.default.roduxTracker

	p4._store = v168(AppReducer, nil, t4, v179, v180)

	local v181

	if SharedFlags.FFlagUseSignalsNavigation then
		v181 = nil
	else
		local v182 = RootNavigator
		local v183 = Roact.PureComponent:extend("NavigationAppContainer")

		v183.router = v182.router

		function v183.render(p6) -- line: 280
			return p6.props.children
		end

		v181 = RoactNavigation.createAppContainer(v183)
	end

	p4._appContainer = v181
	p4._analytics = if not t1.GetFFlagInjectAnalyticsService() then Analytics.new() else Analytics.new(p4.props.rbxAnalyticsService)
	p4._systemInfo = SystemInfoProtocol.default
	p4._linking = LinkingProtocol.default
	p4._logging = LoggingProtocol.default
	p4._game = GameProtocol.default
	p4._permissions = PermissionsProtocol.default
	p4._prefetch = PrefetchProtocol.default
	p4._externalContentSharing = ExternalContentSharingProtocol.default
	p4._localization = Localization.new(LocalizationService.RobloxLocaleId)
	p4._guiService = GuiService

	if t1.FFlagLuaAppUseAppHttpStore then
		p4._appHttpStore = createAppHttpStoreWrapper(p4._store, requestInternalWrapper(p4.props.httpService), p4._guiService)
	end

	p4._sessionService = if not t1.FFlagUseSessionServiceWrapper then SessionService else SessionServiceWrapper
	p4._startupMessage = StartupMessageService
	p4._eventIngest = EventIngest.new(EventIngestService)
	p4._appUpdate = EngineFeature and AppUpdateServiceWrapper.new(v14) or nil
	p4._commonGameEvents = CommonGameEvents.get(SessionService, p4._analytics, p4._eventIngest)
	p4._appStartupSequence = require(CorePackages.Workspace.Packages.AppStartup).AppStartupSequence.default
	p4._focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	pcall(function() -- line: 392
		-- upvalues: p4 (copy)
		p4._appLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	end)
	p4.routeSignal = Signal.new()

	function p4._updateRoute(p7) -- line: 404
		-- upvalues: getLegacyRouteFromRoactNavigationState (copy), p4 (copy)
		local v199 = getLegacyRouteFromRoactNavigationState(p7)

		p4.routeSignal:fire(v199)
	end
	function p4._connectRouteSignal(p8) -- line: 411
		-- upvalues: p4 (copy)
		return p4.routeSignal:connect(p8)
	end

	LuaAppBacktraceLogger:connectToStore(p4._store)
	p4._appRequestService = wrapRequestWithMiddleware(requestInternalWrapper(p4.props.httpService), p4._store, p4._guiService)
	p4._achievementManager = InAppAchievementManager.new(p4._store)
	p4._profilerContext = RoactUtils.Profiling.createReactProfilerContext()
	UiShellEvents.createAppLaunchReactProfilerLogger(p4._profilerContext, "home_page_interactive")
	makeOmniFeedService()

	if t1.FFlagEnableReadAloudInUA then
		require(CorePackages.Workspace.Packages.ReadAloud).ConnectReadAloudToSettings()
	end

	LoggingProtocol.default:logEventOnce("universal_app_init_end")
end
function v169.appendRoactServiceProviders(p9, p10) -- line: 435
	-- upvalues: RoactServices (copy), RoactAnalytics (copy), RoactLocalization (copy), RoactNetworking (copy), AppBrowserService (copy), GetFFlagEnableUnifiedWebViews (copy), BrowserService (copy), AppNotificationService (copy), NotificationService (copy), AppGuiService (copy), AppSystemInfo (copy), AppLinking (copy), AppLogging (copy), AppGame (copy), AppPermissions (copy), AppPrefetch (copy), AppRunService (copy), RunService (copy), AppContentProvider (copy), ContentProvider (copy), AppUserInputService (copy), UserInputService (copy), AppAppLifecycleObserverService (copy), AppSessionService (copy), AppEventIngestService (copy), AppUserGameSettings (copy), UserGameSettings (copy), AppUpdateService (copy), RoactAnalyticsCommonGameEvents (copy), AppStartupSequenceTag (copy), AppStartupMessageService (copy)
	table.insert(p10, {
		class = RoactServices.ServiceProvider,
		props = {
			services = {
				[RoactAnalytics] = p9._analytics,
				[RoactLocalization] = p9._localization,
				[RoactNetworking] = p9._appRequestService,
				[AppBrowserService] = if not GetFFlagEnableUnifiedWebViews() then BrowserService else nil,
				[AppNotificationService] = NotificationService,
				[AppGuiService] = p9._guiService,
				[AppSystemInfo] = p9._systemInfo,
				[AppLinking] = p9._linking,
				[AppLogging] = p9._logging,
				[AppGame] = p9._game,
				[AppPermissions] = p9._permissions,
				[AppPrefetch] = p9._prefetch,
				[AppRunService] = RunService,
				[AppContentProvider] = ContentProvider,
				[AppUserInputService] = UserInputService,
				[AppAppLifecycleObserverService] = p9._appLifecycleObserverService,
				[AppSessionService] = p9._sessionService,
				[AppEventIngestService] = p9._eventIngest,
				[AppUserGameSettings] = UserGameSettings,
				[AppUpdateService] = p9._appUpdate,
				[RoactAnalyticsCommonGameEvents] = p9._commonGameEvents,
				[AppStartupSequenceTag] = p9._appStartupSequence,
				[AppStartupMessageService] = p9._startupMessage
			}
		}
	})
end
function v169.render(p11) -- line: 469
	-- upvalues: DeprecatedDarkTheme (copy), ReactProfilerContext (copy), ReactProfiler (copy), SharedFlags (copy), Navigation (copy), v164 (copy), makeNavigationStateLogger (copy), RoactAppExperiment (copy), t1 (copy), IXPService (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), ChatPolicies (copy), AvatarPolicies (copy), SharePolicies (copy), ShareTargetGamePolicies (copy), AppUiModeStyleProvider (copy), DesignFoundationsBridge (copy), DesignTokenProvider (copy), tokenMappers (copy), AppGridProvider (copy), ThemeProvider (copy), LocalizationProvider (copy), ReactFocusNavigation (copy), Provider (copy), t2 (copy), TopBarSearchSignalContext (copy), PageObjectManagerContext (copy), ApolloProvider (copy), ApolloClient (copy), AppInteractionFeedbackProvider (copy), FeedbackManagerInjectionContextProvider (copy), Responsive (copy), SquadExternalContractProvider (copy), AppSquadContract (copy), SquadLocationEnum (copy), VRFoundationOverlayProvider (copy), NativeShellEventReceiver (copy), ExperienceMenuIXPPreload (copy), WidgetStoreIXP (copy), AndroidWidgetStoreIXP (copy), IOSUIRefactorIXP (copy), IosAuthServiceIxpStore (copy), Roact (copy), UniversalAppEventReceivers (copy), MemStorageSubscriberLifecycleAdapter (copy), LocalPlayerManager (copy), ViewportManager (copy), FrameRateManager (copy), LocaleManager (copy), EventStreamUpdater (copy), num (copy), LocalStorageListener (copy), MutedErrorReporter (copy), LuaAppBacktraceReporterAdaptor (copy), SessionManager (copy), UserHeartbeatsManager (copy), SiteAlertManager (copy), getHasBackgroundMusic (copy), BackgroundSoundManager (copy), AppUpdateManager (copy), UserAgreementsManager (copy), AppReadyHandler (copy), FFlagSignalsNavP2NavigationPrimitives (copy), RnBypassAdapter (copy), ApplyRoactNavigationHistory (copy), AppChatToastManagerUA (copy), AppConfigurer (copy), StartupMessageContainer (copy), BugReporterEventReceiver (copy), SocialGraphSyncManager (copy), MouseCursorHandler (copy), PostAppInteractiveLoader (copy), ProviderContainer (copy), SelectionCursorProvider (copy), CursorProvider (copy)
	local appName = p11.props.appName
	local v188 = DeprecatedDarkTheme
	local t5 = {}

	table.insert(t5, {
		class = ReactProfilerContext.Provider,
		props = {
			value = p11._profilerContext
		}
	})
	table.insert(t5, {
		class = ReactProfiler,
		props = {
			id = "UniversalApp"
		}
	})

	if SharedFlags.FFlagUseSignalsNavigation then
		table.insert(t5, {
			class = Navigation.SignalsNavigationContainer,
			props = {
				navigation = v164
			}
		})
	else
		table.insert(t5, {
			class = p11._appContainer,
			props = {
				onNavigationStateChange = makeNavigationStateLogger("UniversalApp")
			}
		})
	end

	table.insert(t5, {
		class = RoactAppExperiment.Provider,
		props = {
			value = if not t1.GetFFlagInjectAnalyticsService() then IXPService else p11.props.ixpService
		}
	})
	table.insert(t5, {
		class = RoactRodux.StoreProvider,
		props = {
			store = p11._store
		}
	})
	table.insert(t5, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = {
				AppFeaturePolicies,
				ChatPolicies,
				AvatarPolicies,
				SharePolicies,
				if not t1.FFlagShareTargetGameCleanup then ShareTargetGamePolicies else nil
			},
			policyData = if not t1.GetFFlagInjectAnalyticsService() then nil else p11.props.policyData
		}
	})
	p11:appendRoactServiceProviders(t5)

	local t6 = {
		themeName = "dark",
		fontName = "gotham"
	}

	table.insert(t5, {
		class = AppUiModeStyleProvider,
		props = {
			style = t6
		}
	})

	if t1.FFlagLuaAppDesignFoundationsBridge then
		table.insert(t5, {
			class = DesignFoundationsBridge
		})
	end

	table.insert(t5, {
		class = DesignTokenProvider,
		props = {
			tokenMappers = tokenMappers
		}
	})
	table.insert(t5, {
		class = AppGridProvider
	})
	table.insert(t5, {
		class = ThemeProvider,
		props = {
			themeName = "dark",
			theme = v188
		}
	})
	table.insert(t5, {
		class = LocalizationProvider,
		props = {
			localization = p11._localization
		}
	})
	table.insert(t5, {
		class = ReactFocusNavigation.FocusNavigationContext.Provider,
		props = {
			value = p11._focusNavigationService
		}
	})
	table.insert(t5, {
		class = Provider
	})
	table.insert(t5, {
		class = t2.AvatarSceneInteractionProvider
	})
	table.insert(t5, {
		class = t2.BodyDataProvider
	})
	table.insert(t5, {
		class = t2.AdjustmentDataProvider
	})
	table.insert(t5, {
		class = t2.AppliedDescriptionProvider
	})
	table.insert(t5, {
		class = t2.AvatarSaveContextProvider
	})
	table.insert(t5, {
		class = TopBarSearchSignalContext.Provider
	})
	table.insert(t5, {
		class = PageObjectManagerContext.Provider,
		props = {
			pageObjectManager = p11._pageObjectManager
		}
	})
	table.insert(t5, {
		class = ApolloProvider,
		props = {
			client = ApolloClient
		}
	})
	table.insert(t5, {
		class = AppInteractionFeedbackProvider
	})
	table.insert(t5, {
		class = FeedbackManagerInjectionContextProvider
	})
	table.insert(t5, {
		class = Responsive.ResponsiveProvider
	})

	if t1.GetFFlagIsSquadEnabled() then
		table.insert(t5, {
			class = SquadExternalContractProvider,
			props = {
				contract = AppSquadContract,
				squadLocation = SquadLocationEnum.UniversalApp
			}
		})
	end

	if t1.FFlagLuaAppSupportFoundationOverlayInVR then
		table.insert(t5, {
			class = VRFoundationOverlayProvider
		})
	end

	local t7 = {}

	table.insert(t7, NativeShellEventReceiver)
	table.insert(t7, ExperienceMenuIXPPreload)

	if t1.GetFFlagEnableWidgetLUAIXP() or t1.FFlagEnableLockScreenWidgetLuaIXP then
		table.insert(t7, WidgetStoreIXP)
	end

	if t1.GetFFlagEnableAndroidWidgetsLuaIXP() then
		table.insert(t7, AndroidWidgetStoreIXP)
	end

	if t1.GetFFlagEnableIOSUIRefactorLuaIXP() then
		table.insert(t7, IOSUIRefactorIXP)
	end

	if t1.GetFFlagEnableIosAuthServiceLuaIXP() then
		table.insert(t7, IosAuthServiceIxpStore)
	end

	local t8 = {
		EventReceivers = Roact.createElement(UniversalAppEventReceivers),
		MemStorageSubscribers = next(t7) and Roact.createElement(MemStorageSubscriberLifecycleAdapter, {
			receiverComponents = t7
		}) or nil,
		LocalPlayerManager = Roact.createElement(LocalPlayerManager),
		ViewportManager = Roact.createElement(ViewportManager),
		FrameRateManager = Roact.createElement(FrameRateManager),
		LocaleManager = Roact.createElement(LocaleManager, {
			localization = p11._localization
		}),
		EventStreamUpdater = Roact.createElement(EventStreamUpdater, {
			releasePeriod = num
		}),
		LocalStorageListener = Roact.createElement(LocalStorageListener),
		MutedErrorReporter = Roact.createElement(MutedErrorReporter, {
			appName = appName
		}),
		BacktraceReporterAdaptor = Roact.createElement(LuaAppBacktraceReporterAdaptor),
		SessionManager = Roact.createElement(SessionManager, {
			connectRouteSignal = p11._connectRouteSignal
		}),
		UserHeartbeatsManager = Roact.createElement(UserHeartbeatsManager),
		SiteAlertManager = Roact.createElement(SiteAlertManager),
		AppBackgroundSoundManager = if not getHasBackgroundMusic() then nil else Roact.createElement(BackgroundSoundManager),
		AppUpdateManager = Roact.createElement(AppUpdateManager),
		UserAgreementsManager = Roact.createElement(UserAgreementsManager),
		AppReadyHandler = Roact.createElement(AppReadyHandler),
		RnBypassAdapter = if FFlagSignalsNavP2NavigationPrimitives then nil else Roact.createElement(RnBypassAdapter, {
			rnBypassActionSignal = p11._rnBypassActionSignal,
			ApplyRoactNavigationHistory = ApplyRoactNavigationHistory,
			updateRoute = p11._updateRoute
		}),
		AppChatToastManagerUA = Roact.createElement(AppChatToastManagerUA),
		AppConfigurer = Roact.createElement(AppConfigurer, {
			store = p11._store
		}),
		StartupMessageContainer = Roact.createElement(StartupMessageContainer),
		BugReporterEventReceiver = if not t1.GetFFlagEnableInAppBugReporting() then nil else Roact.createElement(BugReporterEventReceiver),
		SocialGraphSyncManager = Roact.createElement(SocialGraphSyncManager),
		MouseCursorHandler = Roact.createElement(MouseCursorHandler),
		PostAppInteractiveLoader = Roact.createElement(PostAppInteractiveLoader)
	}

	return Roact.createElement(ProviderContainer, {
		providers = t5
	}, {
		CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
			NewCursorProvider = Roact.createElement(CursorProvider, {}, t8)
		})
	})
end
function v169.willUnmount(_) -- line: 747
	-- upvalues: t1 (copy), HttpStore (ref)
	if t1.FFlagLuaAppUseAppHttpStore then
		HttpStore.Instance._dispose()
	end
end

return v169
