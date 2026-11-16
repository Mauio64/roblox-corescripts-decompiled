local Destination = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/Destination")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/logBuyRobuxRoutingCallsite")

return {
	fallbackWebUrl = Destination.fallbackWebUrl,
	resolveDestination = Destination.resolveDestination,
	logExposure = Destination.logExposure,
	resolveAndLogDestination = Destination.resolveAndLogDestination,
	logBuyRobuxRoutingCallsite = module2
}
