local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)

return (Rodux.createReducer("", {
	[SetPurchaseFlowUUID.name] = function(_, p2) -- line: 10
		return p2.purchaseFlowUUID
	end
}))
