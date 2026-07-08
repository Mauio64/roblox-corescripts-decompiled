local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local t1 = {
	eventName = "sidesheet_closed",
	description = "Fires when the sidesheet is closed",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SidesheetClosedEventThrottleHundredthsPercent", 10000),
	lastUpdated = {
		2026,
		4,
		8
	}
}

function _logEventWithStandardizedFields(p1, t2: {[any]: any}?) -- line: 26
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy)
	local t3 = {
		"addPlaceId",
		"addUniverseId",
		"addSessionInfo",
		"addOSInfo",
		"addMemoryInfo"
	}
	local v10 = t2 or {}

	if EngineFeature then
		table.insert(t3, "addPlaySessionId")
	else
		v10.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(p1, {
		standardizedFields = t3,
		customFields = v10
	})
end
function logSidesheetClosed(s1: string) -- line: 42
	-- upvalues: t1 (copy)
	_logEventWithStandardizedFields(t1, {
		source = s1
	})
end

return {
	logSidesheetClosed = logSidesheetClosed
}
