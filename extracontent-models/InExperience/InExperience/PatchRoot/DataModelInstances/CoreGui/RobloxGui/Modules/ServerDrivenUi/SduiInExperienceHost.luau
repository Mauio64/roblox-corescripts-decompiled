local CorePackages = game:GetService("CorePackages")

local EventIngestService = game:GetService("EventIngestService")
local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Signals = require(CorePackages.Packages.Signals)
local Analytics = require(CorePackages.Workspace.Packages.Analytics)
local analytics = Analytics.Analytics
local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventIngest = Analytics2.AnalyticsReporters.EventIngest
local Http = require(CorePackages.Workspace.Packages.Http)
local requestInternalWrapper = Http.NetworkLayers.requestInternalWrapper
local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local linkingProtocol = LinkingProtocol.LinkingProtocol
local Localization = require(CorePackages.Workspace.Packages.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices)
local ServiceProvider = RoactServices.RoactServices.ServiceProvider
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local StoreContext = RoactRodux.StoreContext

local UIBlox = require(CorePackages.Packages.UIBlox)
local FeedbackManagerInjectionContext = UIBlox.Core.Control.FeedbackManagerInjectionContext
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local GetAppPolicyStore = UniversalAppPolicy.GetAppPolicyStore

local SduiCoreSystem = require(CorePackages.Workspace.Packages.SduiCoreSystem)
local SduiInstrumentation = SduiCoreSystem.SduiInstrumentation
local SduiLogger = SduiCoreSystem.SduiLogger

local services = nil

local function getServices()
	if services == nil then
		services = {
			appAnalytics = analytics.new(),
			eventIngest = EventIngest.new(EventIngestService),
			networking = requestInternalWrapper(HttpService),
			sessionService = SessionService
		}
	end

	return services
end

local function reportRoduxUnavailable(p)
	local reportError = SduiLogger.reportError
	local roduxUnavailable = SduiCoreSystem.SduiErrors.SduiErrorType.RoduxUnavailable
	local name

	if typeof(p) == "table" then
		name = p.type
	else
		name = typeof(p)
	end

	reportError(roduxUnavailable, { message = "Dispatched without a Rodux store", name = name }, "unknown")
end

local function createUnavailableDependency(p, p2: string)
	return (setmetatable({}, {
		__index = function(_, p3)
			return function(): nil
				SduiLogger.reportError(
					p,
					{
						message = `{p2} is unavailable in experience`,
						name = tostring(p3)
					},
					"unknown"
				)

				return nil
			end
		end
	}))
end

local unavailableDependency = createUnavailableDependency(
	SduiCoreSystem.SduiErrors.SduiErrorType.NavigationUnavailable,
	"Navigation"
)

local unavailableDependency2 = createUnavailableDependency(
	SduiCoreSystem.SduiErrors.SduiErrorType.GameAnalyticsUnavailable,
	"GameAnalytics"
)

local function getNavigation()
	return unavailableDependency
end

local function useTriggerFeedback()
	local current = React.useContext(FeedbackManagerInjectionContext)
	local ref = React.useRef(current)
	ref.current = current
	return React.useCallback(function(p: string, p2, p3: string?, p4)
		return ref.current(p, p2, p3, p4)
	end, { ref })
end

local function useGlobalDependencies()
	local instrumentation = React.useMemo(function()
		return SduiInstrumentation.new()
	end, {})
	local localization = React.useContext(LocalizationRoactContext)
	local tileCursor = Foundation.Hooks.useCursor(Foundation.Enums.CursorType.RoundedRect)
	local triggerFeedback = useTriggerFeedback()

	return React.useMemo(function()
		local services2 = getServices()
		return {
			dispatch = reportRoduxUnavailable,
			getNavigation = getNavigation,
			appAnalytics = services2.appAnalytics,
			gameAnalytics = unavailableDependency2,
			eventIngest = services2.eventIngest,
			sessionService = services2.sessionService,
			linkingProtocol = linkingProtocol.default,
			logger = SduiLogger,
			cursors = { tileCursor = tileCursor },
			instrumentation = instrumentation,
			localization = localization,
			networking = services2.networking,
			triggerFeedback = triggerFeedback
		}
	end, { instrumentation, localization, tileCursor, triggerFeedback })
end

local function useScopedDependencies()
	local v = React.useContext(StoreContext)
	local dispatch = React.useCallback(function(p)
		if v then
			v:dispatch(p)
		else
			reportRoduxUnavailable(p)
		end
	end, { v })

	return React.useMemo(function()
		return { dispatch = dispatch }
	end, { dispatch })
end

local function SduiInExperienceHost(p)
	local v = useGlobalDependencies()
	local v2 = useScopedDependencies()

	local state, setState = React.useState(false)
	React.useLayoutEffect(function()
		local sduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore()
		sduiServiceDependenciesStore.setDependencies(v)
		local v3 = sduiServiceDependenciesStore.setScopedDependencies(p.surfaceKey, v2)
		setState(true)
		return v3
	end, { v, v2, p.surfaceKey })

	local v3 = Foundation.Hooks.useTokens()
	React.useEffect(function()
		SduiCoreSystem.getSduiTokensStore().setTokens(v3)
	end, { v3 })

	React.useEffect(function()
		local getAppPolicy = GetAppPolicyStore(false).getAppPolicy
		return Signals.createEffect(function(p2)
			SduiCoreSystem.getSduiPolicyStore().setAppPolicy(getAppPolicy(p2))
		end)
	end, {})

	if not state then
		return nil
	end

	local services2 = getServices()

	return React.createElement(ServiceProvider, {
		services = {
			[RoactServiceTags.RoactNetworking] = services2.networking,
			[RoactServiceTags.AppEventIngestService] = services2.eventIngest,
			[RoactServiceTags.RoactAnalytics] = services2.appAnalytics,
			[RoactServiceTags.AppSessionService] = services2.sessionService
		}
	}, {
		Children = React.createElement(React.Fragment, nil, p.children)
	})
end

return React.memo(SduiInExperienceHost)
