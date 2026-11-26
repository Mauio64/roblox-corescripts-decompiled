local TelemetryService = game:GetService("TelemetryService")

local telemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/LoggingProtocol").TelemetryBackends
require("@game/CorePackages/Workspace/Packages/_Workspace/UiShellEvents/FocusNavigationUtils")

local v5 = {
	eventName = "KeyboardFocusModeEnteredCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = "2026-06-22",
	description = "Counts # of sessions that use keyboard mode."
}

local v6 = {
	eventName = "KeyboardFocusModeEnteredEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = "2026-06-22",
	description = "Tracks % of DAUs that use keyboard mode."
}

local v7 = {
	eventName = "FocusNavToggledEvent",
	backends = { telemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("FocusNavToggledEventThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	links = "proto-schemas: production/eventstream/console/focus_nav_toggled.proto",
	description = "Fired when the user enters or exits focus navigation. Sent to ingest_proto.focus_nav_toggled."
}

local v8 = {
	eventName = "ShortcutBarToggle",
	backends = { telemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("ShortcutBarToggleThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	links = "proto-schemas: production/eventstream/console/shortcut_bar_toggle.proto",
	description = "Fired when focus navigation dispatches a shortcut the user pressed to a handler. Sent to ingest_proto.shortcut_bar_toggle."
}

local v9 = {
	eventName = "FocusNavToggledCounter",
	backends = { telemetryBackends.Counter },
	lastUpdated = { 26, 10, 4 },
	description = "Counts focus navigation entries and exits by entry and input type."
}

local v10 = {
	eventName = "FocusNavShortcutToggleCounter",
	backends = { telemetryBackends.Counter },
	lastUpdated = { 26, 10, 4 },
	description = "Counts shortcuts used in focus navigation by action and input type."
}

local v11 = {
	eventName = "FocusNavToggledPoints",
	backends = { telemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt("FocusNavToggledPointsThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	description = "Focus navigation entries and exits with page and keyboard details, for Grafana breakdowns."
}

local v12 = {
	eventName = "FocusNavShortcutTogglePoints",
	backends = { telemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt(
		"FocusNavShortcutTogglePointsThrottleHundredthsPercent",
		10000
	),
	lastUpdated = { 26, 10, 4 },
	description = "Shortcuts used in focus navigation with button and page, for Grafana breakdowns."
}

local function logToAllBackends(p2, p3, p4, p5, p6)
	TelemetryService:LogEvent(p2, { customFields = p5 })
	TelemetryService:LogEvent(p3, { customFields = p5 })
	TelemetryService:LogCounter(p4, { customFields = p6 }, 1)
end

local v13 = { "addSessionId", "addOSInfo", "addSessionInfo" }
return {
	logKeyboardFocusModeEntered = function()
		TelemetryService:LogEvent(v6, { customFields = {}, standardizedFields = v13 })

		TelemetryService:LogCounter(v5, { customFields = {}, standardizedFields = v13 })
	end,
	logFocusNavToggled = function(p2)
		logToAllBackends(v7, v11, v9, p2, {
			entry = p2.entry,
			input_type = p2.input_type
		})
	end,
	logFocusNavShortcutToggle = function(p2)
		logToAllBackends(v8, v12, v10, p2, {
			action = p2.action,
			input_type = p2.input_type
		})
	end
}
