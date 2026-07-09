local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	"addPlaceId",
	"addUniverseId",
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}
local t2 = {
	eventName = "ServeEnhancedVideoError",
	description = "        This is fired when there is an error calling /serve-enhanced-video.\n    ",
	backends = { "Points" },
	throttlingPercentage = game:DefineFastInt("ServeEnhancedVideoErrorTelemetryThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		3,
		20
	}
}

return {
	logServeEnhancedVideoError = function(s1: string) -- line: 19
		-- upvalues: TelemetryService (copy), t2 (copy), t1 (copy)
		TelemetryService:LogEvent(t2, {
			standardizedFields = t1,
			customFields = {
				error = s1
			}
		})
	end
}
