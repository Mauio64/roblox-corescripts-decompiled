local parent = script:FindFirstAncestor("BuyRobuxRouting").Parent
local LoggingProtocol = require(parent.LoggingProtocol)

local v = {
	eventName = "BuyRobuxRoutingDecision",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 21 },
	throttlingPercentage = 10000,
	description = "Fires when new Buy Robux routing chooses a destination."
}

local function logBuyRobuxRoutingDecision(destination: string, reason: string)
	LoggingProtocol.default:logRobloxTelemetryCounter(v, 1, {
		destination = destination,
		reason = reason
	})
end

return logBuyRobuxRoutingDecision
