local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)

return (Rodux.createReducer("", {
	[SetPurchaseFlowUUID.name] = function(_, p)
		return p.purchaseFlowUUID
	end
}))
