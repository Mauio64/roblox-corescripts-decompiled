local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetRobloxSubscriptionProducts")

return (rodux.createReducer(nil, {
	[SetRobloxSubscriptionProducts.name] = function(p2, p3)
		return p3.robloxSubscriptionProducts
	end
}))
