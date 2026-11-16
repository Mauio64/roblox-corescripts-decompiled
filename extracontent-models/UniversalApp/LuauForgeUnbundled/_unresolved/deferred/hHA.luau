local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local defineFastInt = game:DefineFastInt("VRComfortSettingsAnalyticsHundredthsPercent", 10000)

local v5 = {
	eventName = "VRComfortSettingChanged",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 7, 17 },
	description = "Event sent when a VR comfort setting is changed, discriminated by the `setting` field",
	links = ""
}

local function logSettingChanged(p2, p3)
	TelemetryService:LogEvent(v5, {
		customFields = { setting = p2, value = p3 }
	})
end

return {
	onComfortProfileChanged = function(p2)
		logSettingChanged("ComfortProfile", p2.Name)
	end,
	onVignetteEnabledChanged = function(p2)
		logSettingChanged("VignetteEnabled", tostring(p2))
	end,
	onSteppedRotationEnabledChanged = function(p2)
		logSettingChanged("SteppedRotationEnabled", tostring(p2))
	end,
	onThirdPersonFixedCamEnabledChanged = function(p2)
		logSettingChanged("ThirdPersonFixedCamEnabled", tostring(p2))
	end,
	onSafetyBubbleModeChanged = function(p2)
		logSettingChanged("SafetyBubbleMode", p2.Name)
	end
}
