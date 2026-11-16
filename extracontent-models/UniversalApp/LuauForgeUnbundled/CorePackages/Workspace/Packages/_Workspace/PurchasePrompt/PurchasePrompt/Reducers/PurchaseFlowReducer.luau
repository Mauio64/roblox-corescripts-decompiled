local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlow")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")

return rodux.createReducer(false, {
	[CompleteRequest.name] = function(p2, p3)
		return PurchaseFlow.None
	end,
	[SetPurchaseFlow.name] = function(p2, p3)
		return p3.purchaseFlow
	end
})
