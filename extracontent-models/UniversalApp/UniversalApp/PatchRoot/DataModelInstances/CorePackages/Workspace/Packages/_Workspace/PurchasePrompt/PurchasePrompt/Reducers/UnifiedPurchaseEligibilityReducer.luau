local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)

return (Rodux.createReducer(false, {
	[SetIsUserEligibleForUnifiedPurchaseFlow.name] = function(_, p2) -- line: 10
		return p2.isUserEligibleForUnifiedPurchaseFlow
	end
}))
