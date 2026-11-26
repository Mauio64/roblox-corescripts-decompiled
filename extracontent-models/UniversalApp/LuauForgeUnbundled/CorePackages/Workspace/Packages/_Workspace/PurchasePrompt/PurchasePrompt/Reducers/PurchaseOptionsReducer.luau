local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPurchaseOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseOptions")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

return (rodux.createReducer({
	shouldSkipOwnershipCheck = false,
	shouldFetchCartPricing = false
}, {
	[SetPurchaseOptions.name] = function(p2, p3)
		return p3.purchaseOptions
	end
}))
