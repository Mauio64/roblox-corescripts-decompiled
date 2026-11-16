local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetRobloxSubscriptionProducts = require(PurchasePrompt.Actions.SetRobloxSubscriptionProducts)

return (Rodux.createReducer(nil, {
	[SetRobloxSubscriptionProducts.name] = function(_, p)
		return p.robloxSubscriptionProducts
	end
}))
