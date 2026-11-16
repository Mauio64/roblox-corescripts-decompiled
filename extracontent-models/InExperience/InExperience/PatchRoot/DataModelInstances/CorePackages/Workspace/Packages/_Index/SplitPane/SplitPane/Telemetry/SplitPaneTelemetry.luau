local parent = script:FindFirstAncestor("SplitPane").Parent
local MockableProxyServices = require(parent.MockableProxyServices)
local TelemetryService = MockableProxyServices.TelemetryService
local LoggingProtocol = require(parent.LoggingProtocol)
require(parent.AppSplitView)

local action = { Launch = 1, Toggle = 2, ViewportChanged = 3 }

local v = {
	eventName = "splitPaneViewChange",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SplitPaneViewChangeTelemetryThrottleHundredthsPercent", 1),
	lastUpdated = { 2026, 10, 12 },
	description = "Resolved split pane visibility at user-session launch, explicit control activation, or viewport change."
}

local v2 = {
	eventName = "appLaunchViewport",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("AppLaunchViewportTelemetryThrottleHundredthsPercent", 10),
	lastUpdated = { 2026, 10, 12 },
	description = "Initial resolved user-session viewport in design-space pixels."
}

local v3 = {
	eventName = "SplitPane_StateChanged",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Resolved pane mode at user-session launch and changes from toggles or viewport changes."
}

local v4 = {
	eventName = "SplitPane_PaneControlPressed",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Activations of the support host Back, Expand/Restore, and Close controls."
}

local v5 = {
	eventName = "SplitPane_SupportRouteOpened",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Root support pane transitions from zero routes to one or more, including remounts and fallback returns."
}

local v6 = {
	[action.Launch] = "launch",
	[action.Toggle] = "toggle",
	[action.ViewportChanged] = "viewport_changed"
}

local function getIsViewportReady(p) -- 2 equivalent calls inferred from this helper
	local userId = tonumber(p.userId)
	local isViewportReady

	if userId == nil or not (userId > 0) then
		isViewportReady = false
	else
		isViewportReady = p.viewportSize ~= nil
	end

	return isViewportReady
end

local SplitPaneTelemetry = {}
SplitPaneTelemetry.View = { Shown = 1, Hidden = 2 }
SplitPaneTelemetry.Action = action
SplitPaneTelemetry.Control = { Back = "back", Expand = "expand", Close = "close" }

function SplitPaneTelemetry.getTelemetryStateFromMode(value)
	return value or "inactive"
end

function SplitPaneTelemetry.logStateChanged(to_state, p: number)
	TelemetryService:LogCounter(v3, {
		customFields = { to_state = to_state, cause = v6[p] }
	}, 1)
end

function SplitPaneTelemetry.logPaneControlPressed(control: string)
	TelemetryService:LogCounter(v4, {
		customFields = { control = control }
	}, 1)
end

function SplitPaneTelemetry.logSupportRouteOpened()
	TelemetryService:LogCounter(v5, {}, 1)
end

function SplitPaneTelemetry.logSplitPaneViewChange(p, action2: number): boolean
	if not getIsViewportReady(p) then -- inferred equivalent call
		return false
	end

	local viewportSize = p.viewportSize
	TelemetryService:LogEvent(v, {
		customFields = {
			view = p.view,
			action = action2,
			viewport_width = viewportSize.X,
			viewport_height = viewportSize.Y
		}
	})

	return true
end

function SplitPaneTelemetry.logAppLaunchViewport(p): boolean
	if not getIsViewportReady(p) then -- inferred equivalent call
		return false
	end

	local viewportSize = p.viewportSize
	TelemetryService:LogEvent(v2, {
		customFields = {
			viewport_width = viewportSize.X,
			viewport_height = viewportSize.Y,
			is_landscape = p.isLandscape
		}
	})

	return true
end

return SplitPaneTelemetry
