local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("LuaAppItemImpressionsEventThrottlingHundredthsPercent", 10000)

local function sduiCustomImpressionsEvent(s1: string, s2: string, t1: {[any]: any}) -- line: 7
	-- upvalues: TelemetryService (copy), v2 (copy)
	TelemetryService:LogEvent({
		eventName = s1,
		backends = {
			"EventIngest",
			"Points"
		},
		throttlingPercentage = v2,
		lastUpdated = {
			26,
			3,
			17
		},
		description = `SDUI custom impression event: { s1 }`
	}, {
		eventContext = s2,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = t1
	})
end

return sduiCustomImpressionsEvent
