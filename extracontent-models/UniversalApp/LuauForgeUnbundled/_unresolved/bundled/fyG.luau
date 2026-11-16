local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local defineFastInt = game:DefineFastInt("SettingsTelemetryThrottleHundredthsPercent", 10000)
local defineFastFlag = game:DefineFastFlag("EnableSettingsTelemetryPointsBackend", false)

local v5 = { "addSessionInfo", LoggingProtocol.StandardizedFields.addOsInfo, LoggingProtocol.StandardizedFields.addSessionId }

local function makeEventConfig(p2, description)
	local v6 = if defineFastFlag then {
		LoggingProtocol.TelemetryBackends.EventIngest,
		LoggingProtocol.TelemetryBackends.Points
	} else { LoggingProtocol.TelemetryBackends.EventIngest }
	return {
		eventName = p2,
		backends = v6,
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 9, 23 },
		description = description
	}
end

local eventConfig = makeEventConfig(
	"settingsToggle",
	"Fired when a user changes a setting in Device Preferences or Platform Settings"
)

local eventConfig2 = makeEventConfig(
	"settingsSnapshot",
	"Snapshot of a user's settings, fired per setting once per app launch"
)

return {
	reportSettingToggle = function(p2, p3, p4, p5)
		(p5 or LoggingProtocol.default):logRobloxTelemetryEvent(eventConfig, v5, {
			setting = p2,
			old_value = tostring(p3),
			new_value = tostring(p4)
		})
	end,
	reportSettingsSnapshot = function(items, p2)
		local v6 = p2 or LoggingProtocol.default

		for k, item in items do
			v6:logRobloxTelemetryEvent(eventConfig2, v5, {
				setting = k,
				value = tostring(item)
			})
		end
	end
}
