local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local v = {
	eventName = "playtest_mode_enabled",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("PlaytestModeEnabledEventThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 7, 23 },
	description = "Fires once when playtest mode becomes enabled for the local player"
}

local function _logEventWithStandardizedFields(p, options)
	local standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo" }
	local customFields = options or {}

	if engineFeature then
		table.insert(standardizedFields, "addPlaySessionId")
	else
		customFields.playsessionid = RbxAnalyticsService:GetPlaySessionId()
	end

	TelemetryService:LogEvent(p, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

return {
	logPlaytestModeEnabled = function(reason: string)
		_logEventWithStandardizedFields(v, { reason = reason })
	end
}
