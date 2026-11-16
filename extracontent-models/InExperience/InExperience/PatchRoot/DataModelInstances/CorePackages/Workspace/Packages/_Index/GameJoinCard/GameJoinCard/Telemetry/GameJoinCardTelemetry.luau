local parent = script:FindFirstAncestor("GameJoinCard").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("MobileGameJoinCardBannerLoadCounterThrottleHundredthsPercent", 10000)

local v = {
	eventName = "mobileGameJoinCardBannerLoad",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 5, 14 },
	description = "MobileGameJoinCard banner image resolution outcomes; status custom field is one of Success / NotFound / Fallback / Failed."
}

local v2 = { Success = true, NotFound = true, Fallback = true, Failed = true }

local defineFastInt2 = game:DefineFastInt("GameJoinCardActionsResolveStatThrottleHundredthsPercent", 10000)

local v3 = {
	eventName = "gameJoinCardActionsResolve",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 2026, 10, 5 },
	links = "",
	description = "Milliseconds a visible join card waited on JoinUserActions. status is Ready or Failed. surface is mobile or desktop."
}

local v4 = { Ready = true, Failed = true }
local GameJoinCardTelemetry = {}

function GameJoinCardTelemetry.logBannerLoadResult(status: string)
	if not v2[status] then
		return
	end

	LoggingProtocol.default:logRobloxTelemetryCounter(v, nil, { status = status })
end

function GameJoinCardTelemetry.logActionsResolved(p: number, status: string, surface: string)
	if not v4[status] then
		return
	end

	LoggingProtocol.default:logRobloxTelemetryStat(v3, math.max(0, (math.floor(p))), {
		status = status,
		surface = surface
	})
end

return GameJoinCardTelemetry
