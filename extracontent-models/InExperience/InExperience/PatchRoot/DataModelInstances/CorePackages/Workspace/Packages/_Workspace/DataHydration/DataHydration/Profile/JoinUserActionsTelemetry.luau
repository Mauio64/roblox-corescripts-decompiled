local parent = script:FindFirstAncestor("DataHydration").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("JoinUserActionsFetchCounterThrottleHundredthsPercent", 10000)

local v = {
	eventName = "joinUserActionsFetch",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 30 },
	description = "JoinUserActions request outcomes; status custom field is Success or Failed."
}

local v2 = { Success = true, Failed = true }

return {
	logFetchResult = function(status: string)
		if not v2[status] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(v, nil, { status = status })
	end
}
