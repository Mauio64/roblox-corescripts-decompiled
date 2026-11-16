local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPurchaseFlow = require(PurchasePrompt.Actions.SetPurchaseFlow)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)

return Rodux.createReducer(false, {
	[CompleteRequest.name] = function(_, _)
		return PurchaseFlow.None
	end,
	[SetPurchaseFlow.name] = function(_, p)
		return p.purchaseFlow
	end
})
