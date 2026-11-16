local parent = script:FindFirstAncestor("BuyRobuxRouting").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local v = {
	eventName = "BuyRobuxNewRoutingCallsite",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 21 },
	throttlingPercentage = 10000,
	description = "Fires when a new Buy Robux routing callsite runs."
}

local function logBuyRobuxRoutingCallsite(callsite: string)
	LoggingProtocol.default:logRobloxTelemetryCounter(v, 1, { callsite = callsite })
end

return logBuyRobuxRoutingCallsite
