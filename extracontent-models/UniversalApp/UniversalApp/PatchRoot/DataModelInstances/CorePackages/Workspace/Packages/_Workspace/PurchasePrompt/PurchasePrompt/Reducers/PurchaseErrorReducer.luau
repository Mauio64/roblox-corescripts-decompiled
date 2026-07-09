local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return Rodux.createReducer({}, {
	[ErrorOccurred.name] = function(_, p2) -- line: 12
		return p2.purchaseError
	end,
	[CompleteRequest.name] = function(_, _) -- line: 15
		return {}
	end
})
