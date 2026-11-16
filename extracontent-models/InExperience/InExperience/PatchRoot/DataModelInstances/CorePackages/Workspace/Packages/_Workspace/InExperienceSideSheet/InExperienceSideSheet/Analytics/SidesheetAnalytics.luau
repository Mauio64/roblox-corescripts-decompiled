local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local engineFeature = game:GetEngineFeature("TelemetryServicePlaySessionInfoEnabled")

local v = {
	eventName = "sidesheet_closed",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("SidesheetClosedEventThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 4, 8 },
	description = "Fires when the sidesheet is closed"
}

function _logEventWithStandardizedFields(p, options)
	local standardizedFields = {
		"addPlaceId",
		"addUniverseId",
		"addSessionInfo",
		"addOSInfo",
		"addMemoryInfo"
	}
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

function logSidesheetClosed(source: string)
	_logEventWithStandardizedFields(v, { source = source })
end

return { logSidesheetClosed = logSidesheetClosed }
