local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/LoggingProtocol")

local v5 = {
	eventName = "BuyRobuxNewRoutingCallsite",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 10, 21 },
	throttlingPercentage = 10000,
	description = "Fires when a new Buy Robux routing callsite runs."
}

local function logBuyRobuxRoutingCallsite(p2)
	LoggingProtocol.default:logRobloxTelemetryCounter(v5, 1, { callsite = p2 })
end

return logBuyRobuxRoutingCallsite
