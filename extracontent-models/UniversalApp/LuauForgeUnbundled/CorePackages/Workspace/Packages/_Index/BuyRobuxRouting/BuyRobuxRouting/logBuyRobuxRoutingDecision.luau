local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/LoggingProtocol")

local v5 = {
	eventName = "BuyRobuxRoutingDecision",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 21 },
	throttlingPercentage = 10000,
	description = "Fires when new Buy Robux routing chooses a destination."
}

local function logBuyRobuxRoutingDecision(p2, p3)
	LoggingProtocol.default:logRobloxTelemetryCounter(v5, 1, { destination = p2, reason = p3 })
end

return logBuyRobuxRoutingDecision
