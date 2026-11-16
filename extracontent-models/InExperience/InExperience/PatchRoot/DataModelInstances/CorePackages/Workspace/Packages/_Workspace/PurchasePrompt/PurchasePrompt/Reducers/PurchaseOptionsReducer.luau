local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPurchaseOptions = require(PurchasePrompt.Actions.SetPurchaseOptions)
require(PurchasePrompt.types)

return (Rodux.createReducer({ shouldSkipOwnershipCheck = false, shouldFetchCartPricing = false }, {
	[SetPurchaseOptions.name] = function(_, p)
		return p.purchaseOptions
	end
}))
