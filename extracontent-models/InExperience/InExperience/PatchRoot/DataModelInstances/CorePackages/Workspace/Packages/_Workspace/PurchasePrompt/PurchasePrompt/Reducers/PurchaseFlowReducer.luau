local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPurchaseFlow = require(PurchasePrompt.Actions.SetPurchaseFlow)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

return Rodux.createReducer(false, {
	[CompleteRequest.name] = function(_, _) -- line: 12
		-- upvalues: PurchaseFlow (copy)
		return PurchaseFlow.None
	end,
	[SetPurchaseFlow.name] = function(_, p4) -- line: 15
		return p4.purchaseFlow
	end
})
