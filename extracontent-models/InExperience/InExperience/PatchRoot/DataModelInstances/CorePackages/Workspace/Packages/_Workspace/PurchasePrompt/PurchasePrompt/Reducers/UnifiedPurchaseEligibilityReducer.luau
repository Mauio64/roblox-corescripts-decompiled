local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)

return (Rodux.createReducer(false, {
	[SetIsUserEligibleForUnifiedPurchaseFlow.name] = function(_, p)
		return p.isUserEligibleForUnifiedPurchaseFlow
	end
}))
