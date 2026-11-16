local telemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/MockableProxyServices").TelemetryService
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")

local v5 = { Launch = 1, Toggle = 2, ViewportChanged = 3 }

local v6 = {
	eventName = "splitPaneViewChange",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SplitPaneViewChangeTelemetryThrottleHundredthsPercent", 1),
	lastUpdated = { 2026, 10, 12 },
	description = "Resolved split pane visibility at user-session launch, explicit control activation, or viewport change."
}

local v7 = {
	eventName = "appLaunchViewport",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("AppLaunchViewportTelemetryThrottleHundredthsPercent", 10),
	lastUpdated = { 2026, 10, 12 },
	description = "Initial resolved user-session viewport in design-space pixels."
}

local v8 = {
	eventName = "SplitPane_StateChanged",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Resolved pane mode at user-session launch and changes from toggles or viewport changes."
}

local v9 = {
	eventName = "SplitPane_PaneControlPressed",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Activations of the support host Back, Expand/Restore, and Close controls."
}

local v10 = {
	eventName = "SplitPane_SupportRouteOpened",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 12 },
	description = "Root support pane transitions from zero routes to one or more, including remounts and fallback returns."
}

local v11 = {
	[v5.Launch] = "launch",
	[v5.Toggle] = "toggle",
	[v5.ViewportChanged] = "viewport_changed"
}

local function getIsViewportReady(p2)
	local userId = tonumber(p2.userId)
	local isViewportReady = not (userId == nil or not (userId > 0)) and p2.viewportSize ~= nil
	return isViewportReady
end

return {
	View = { Shown = 1, Hidden = 2 },
	Action = v5,
	Control = { Back = "back", Expand = "expand", Close = "close" },
	getTelemetryStateFromMode = function(value)
		return value or "inactive"
	end,
	logStateChanged = function(p2, p3)
		telemetryService:LogCounter(v8, {
			customFields = { to_state = p2, cause = v11[p3] }
		}, 1)
	end,
	logPaneControlPressed = function(p2)
		telemetryService:LogCounter(v9, {
			customFields = { control = p2 }
		}, 1)
	end,
	logSupportRouteOpened = function()
		telemetryService:LogCounter(v10, {}, 1)
	end,
	logSplitPaneViewChange = function(data, p2): boolean
		local userId = tonumber(data.userId)
		local v12 = not (userId == nil or not (userId > 0)) and data.viewportSize ~= nil

		if not v12 then
			return false
		end

		local viewportSize = data.viewportSize
		telemetryService:LogEvent(v6, {
			customFields = {
				view = data.view,
				action = p2,
				viewport_width = viewportSize.X,
				viewport_height = viewportSize.Y
			}
		})

		return true
	end,
	logAppLaunchViewport = function(data): boolean
		local userId = tonumber(data.userId)
		local v12 = not (userId == nil or not (userId > 0)) and data.viewportSize ~= nil

		if not v12 then
			return false
		end

		local viewportSize = data.viewportSize
		telemetryService:LogEvent(v7, {
			customFields = {
				viewport_width = viewportSize.X,
				viewport_height = viewportSize.Y,
				is_landscape = data.isLandscape
			}
		})

		return true
	end
}
