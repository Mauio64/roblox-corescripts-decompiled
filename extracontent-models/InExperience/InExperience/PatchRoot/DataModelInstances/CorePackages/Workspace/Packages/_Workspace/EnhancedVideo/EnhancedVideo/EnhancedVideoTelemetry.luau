local TelemetryService = game:GetService("TelemetryService")

local standardizedFields = {
	"addPlaceId",
	"addUniverseId",
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}

local v = {
	eventName = "ServeEnhancedVideoError",
	backends = { "Points" },
	throttlingPercentage = game:DefineFastInt("ServeEnhancedVideoErrorTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 3, 20 },
	description = "        This is fired when there is an error calling /serve-enhanced-video.\n    "
}

return {
	logServeEnhancedVideoError = function(err: string)
		TelemetryService:LogEvent(v, {
			standardizedFields = standardizedFields,
			customFields = { error = err }
		})
	end
}
