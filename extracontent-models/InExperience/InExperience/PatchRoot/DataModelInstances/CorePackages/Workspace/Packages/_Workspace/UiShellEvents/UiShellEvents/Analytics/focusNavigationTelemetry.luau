local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("UiShellEvents").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local TelemetryBackends = LoggingProtocol.TelemetryBackends
require(parent.FocusNavigationUtils)

local v = {
	eventName = "KeyboardFocusModeEnteredCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = "2026-06-22",
	description = "Counts # of sessions that use keyboard mode."
}

local v2 = {
	eventName = "KeyboardFocusModeEnteredEvent",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = "2026-06-22",
	description = "Tracks % of DAUs that use keyboard mode."
}

local v3 = {
	eventName = "FocusNavToggledEvent",
	backends = { TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("FocusNavToggledEventThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	links = "proto-schemas: production/eventstream/console/focus_nav_toggled.proto",
	description = "Fired when the user enters or exits focus navigation. Sent to ingest_proto.focus_nav_toggled."
}

local v4 = {
	eventName = "ShortcutBarToggle",
	backends = { TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("ShortcutBarToggleThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	links = "proto-schemas: production/eventstream/console/shortcut_bar_toggle.proto",
	description = "Fired when focus navigation dispatches a shortcut the user pressed to a handler. Sent to ingest_proto.shortcut_bar_toggle."
}

local v5 = {
	eventName = "FocusNavToggledCounter",
	backends = { TelemetryBackends.Counter },
	lastUpdated = { 26, 10, 4 },
	description = "Counts focus navigation entries and exits by entry and input type."
}

local v6 = {
	eventName = "FocusNavShortcutToggleCounter",
	backends = { TelemetryBackends.Counter },
	lastUpdated = { 26, 10, 4 },
	description = "Counts shortcuts used in focus navigation by action and input type."
}

local v7 = {
	eventName = "FocusNavToggledPoints",
	backends = { TelemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt("FocusNavToggledPointsThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	description = "Focus navigation entries and exits with page and keyboard details, for Grafana breakdowns."
}

local v8 = {
	eventName = "FocusNavShortcutTogglePoints",
	backends = { TelemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt("FocusNavShortcutTogglePointsThrottleHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 4 },
	description = "Shortcuts used in focus navigation with button and page, for Grafana breakdowns."
}

local function logToAllBackends(p, p2, p3, customFields, customFields2)
	TelemetryService:LogEvent(p, { customFields = customFields })
	TelemetryService:LogEvent(p2, { customFields = customFields })
	TelemetryService:LogCounter(p3, { customFields = customFields2 }, 1)
end

local standardizedFields = { "addSessionId", "addOSInfo", "addSessionInfo" }
local FocusNavigationTelemetry = {}

function FocusNavigationTelemetry.logKeyboardFocusModeEntered()
	TelemetryService:LogEvent(v2, { customFields = {}, standardizedFields = standardizedFields })

	TelemetryService:LogCounter(v, { customFields = {}, standardizedFields = standardizedFields })
end

function FocusNavigationTelemetry.logFocusNavToggled(customFields)
	logToAllBackends(v3, v7, v5, customFields, {
		entry = customFields.entry,
		input_type = customFields.input_type
	})
end

function FocusNavigationTelemetry.logFocusNavShortcutToggle(customFields)
	logToAllBackends(v4, v8, v6, customFields, {
		action = customFields.action,
		input_type = customFields.input_type
	})
end

return FocusNavigationTelemetry
