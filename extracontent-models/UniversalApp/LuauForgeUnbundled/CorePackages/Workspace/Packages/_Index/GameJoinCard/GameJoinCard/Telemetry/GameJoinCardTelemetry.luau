local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/LoggingProtocol")

local defineFastInt = game:DefineFastInt(
	"MobileGameJoinCardBannerLoadCounterThrottleHundredthsPercent",
	10000
)

local v5 = {
	eventName = "mobileGameJoinCardBannerLoad",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 14 },
	description = "MobileGameJoinCard banner image resolution outcomes; status custom field is one of Success / NotFound / Fallback / Failed."
}

local v6 = { Success = true, NotFound = true, Fallback = true, Failed = true }

local defineFastInt2 = game:DefineFastInt("GameJoinCardActionsResolveStatThrottleHundredthsPercent", 10000)

local v7 = {
	eventName = "gameJoinCardActionsResolve",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 2026, 10, 5 },
	links = "",
	description = "Milliseconds a visible join card waited on JoinUserActions. status is Ready or Failed. surface is mobile or desktop."
}

local v8 = { Ready = true, Failed = true }
return {
	logBannerLoadResult = function(p2)
		if not v6[p2] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(v5, nil, { status = p2 })
	end,
	logActionsResolved = function(p2, p3, p4)
		if not v8[p3] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryStat(v7, math.max(0, (math.floor(p2))), {
			status = p3,
			surface = p4
		})
	end
}
