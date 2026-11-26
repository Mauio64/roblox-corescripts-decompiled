local BuyRobuxRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/BuyRobuxInExperience/BuyRobuxRouting")

return {
	openBuyRobux = function(p2, callback, p3)
		BuyRobuxRouting.logBuyRobuxRoutingCallsite(p3)
		local resolveAndLogDestination = BuyRobuxRouting.resolveAndLogDestination(p2)

		if resolveAndLogDestination.kind == "web" then
			callback(resolveAndLogDestination.url)
		else
			callback(BuyRobuxRouting.fallbackWebUrl(p2))
		end
	end
}
