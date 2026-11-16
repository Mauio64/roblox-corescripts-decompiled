local parent = script.Parent

local BuyRobuxRouting = require(parent.BuyRobuxRouting)

return {
	openBuyRobux = function(p, callback, p2: string)
		BuyRobuxRouting.logBuyRobuxRoutingCallsite(p2)
		local resolveAndLogDestination = BuyRobuxRouting.resolveAndLogDestination(p)

		if resolveAndLogDestination.kind == "web" then
			callback(resolveAndLogDestination.url)
		else
			callback(BuyRobuxRouting.fallbackWebUrl(p))
		end
	end,
	["jest.config"] = script["jest.config"]
}
