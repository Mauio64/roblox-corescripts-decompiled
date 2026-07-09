local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)

return (Rodux.createReducer(nil, {
	[SetRobloxSubscriptionProducts.name] = function(_, p2) -- line: 10
		return p2.robloxSubscriptionProducts
	end
}))
