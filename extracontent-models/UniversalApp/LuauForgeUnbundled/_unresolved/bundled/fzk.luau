local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local defineFastFlag = game:DefineFastFlag("EnableSkyStyleTelemetry", false)

local defineFastInt = game:DefineFastInt("SkyStyleTelemetryThrottleHundredthsPercent", 10000)

local v5 = {
	eventName = "vrSkyStyleChange",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 7, 22 },
	description = "Tracks VR sky style selection, application, and invalid/error cases",
	links = "https://sourcegraph.rbx.com/github.com/Roblox/proto-schemas/-/blob/production/eventstream/mobile/vr_sky_style_change.proto"
}

local v6 = { FFlagEnableSkyStyleTelemetry = defineFastFlag }

local function logSkyStyleChange(object, p2, p3)
	object:logRobloxTelemetryEvent(
		v5,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo, LoggingProtocol.StandardizedFields.addSessionId },
		p2,
		p3
	)
end

function v6.reportSelected(p2, p3)
	(p3 or LoggingProtocol.default):logRobloxTelemetryEvent(
		v5,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo, LoggingProtocol.StandardizedFields.addSessionId },
		{ action = "select", skyStyle = p2 },
		"settingDropdown"
	)
end

function v6.reportApplied(p2, p3)
	(p3 or LoggingProtocol.default):logRobloxTelemetryEvent(
		v5,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo, LoggingProtocol.StandardizedFields.addSessionId },
		{ action = "apply", skyStyle = p2 },
		"applySkyStyle"
	)
end

function v6.reportError(p2, p3, p4, p5)
	(p5 or LoggingProtocol.default):logRobloxTelemetryEvent(
		v5,
		{ "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo, LoggingProtocol.StandardizedFields.addSessionId },
		{ action = "error", skyStyle = p3, errorReason = p2 },
		p4
	)
end

return v6
