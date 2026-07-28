local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local EngineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")
local t1 = {
	eventName = "playtest_mode_enabled",
	description = "Fires once when playtest mode becomes enabled for the local player",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("PlaytestModeEnabledEventThrottleHundredthsPercent", 10000),
	lastUpdated = {
		2026,
		7,
		23
	}
}

local function _logEventWithStandardizedFields(p1, t2: {[any]: any}?) -- line: 26
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), TelemetryService (copy)
	local t3 = {
		"addPlaceId",
		"addUniverseId",
		"addSessionInfo"
	}
	local v11 = t2 or {}

	if EngineFeature then
		table.insert(t3, "addPlaySessionId")
	else
		v11.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(p1, {
		standardizedFields = t3,
		customFields = v11
	})
end

return {
	logPlaytestModeEnabled = function(s1: string) -- line: 42
		-- upvalues: _logEventWithStandardizedFields (copy), t1 (copy)
		_logEventWithStandardizedFields(t1, {
			reason = s1
		})
	end
}
