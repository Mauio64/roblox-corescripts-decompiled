local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPurchaseFlowUUID = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlowUUID")

return (rodux.createReducer("", {
	[SetPurchaseFlowUUID.name] = function(p2, p3)
		return p3.purchaseFlowUUID
	end
}))
