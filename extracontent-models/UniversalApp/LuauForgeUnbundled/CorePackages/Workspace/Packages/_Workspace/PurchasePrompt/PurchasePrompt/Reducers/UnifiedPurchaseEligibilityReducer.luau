local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetIsUserEligibleForUnifiedPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetIsUserEligibleForUnifiedPurchaseFlow")

return (rodux.createReducer(false, {
	[SetIsUserEligibleForUnifiedPurchaseFlow.name] = function(p2, p3)
		return p3.isUserEligibleForUnifiedPurchaseFlow
	end
}))
