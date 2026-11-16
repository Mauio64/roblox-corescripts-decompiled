local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local SetPostPurchaseActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPostPurchaseActions")

return (rodux.createReducer({}, {
	[SetPostPurchaseActions.name] = function(p2, p3)
		return p3.postPurchaseActions
	end
}))
