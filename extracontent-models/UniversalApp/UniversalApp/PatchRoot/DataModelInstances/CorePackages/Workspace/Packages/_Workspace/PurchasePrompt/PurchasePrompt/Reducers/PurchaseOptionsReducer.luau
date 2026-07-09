local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseOptions = require(PurchasePrompt.Actions.SetPurchaseOptions)
local _ = require(PurchasePromptParent.SharedFlags).FFlagUnifiedPurchaseGamepassAddProductUniverseId

require(PurchasePrompt.types)

local t1 = {
	shouldSkipOwnershipCheck = false,
	shouldFetchCartPricing = false
}

return (Rodux.createReducer(t1, {
	[SetPurchaseOptions.name] = function(_, p2) -- line: 18
		return p2.purchaseOptions
	end
}))
