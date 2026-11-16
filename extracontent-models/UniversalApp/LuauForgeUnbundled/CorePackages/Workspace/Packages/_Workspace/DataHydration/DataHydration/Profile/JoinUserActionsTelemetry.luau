local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LoggingProtocol")

local defineFastInt = game:DefineFastInt("JoinUserActionsFetchCounterThrottleHundredthsPercent", 10000)

local v5 = {
	eventName = "joinUserActionsFetch",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 30 },
	description = "JoinUserActions request outcomes; status custom field is Success or Failed."
}

local v6 = { Success = true, Failed = true }

return {
	logFetchResult = function(p2)
		if not v6[p2] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(v5, nil, { status = p2 })
	end
}
