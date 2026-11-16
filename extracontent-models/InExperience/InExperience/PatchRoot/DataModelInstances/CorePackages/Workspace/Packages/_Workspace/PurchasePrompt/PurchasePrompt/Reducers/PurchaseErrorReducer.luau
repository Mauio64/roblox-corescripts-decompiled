local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)

return Rodux.createReducer({}, {
	[ErrorOccurred.name] = function(_, p)
		return p.purchaseError
	end,
	[CompleteRequest.name] = function(_, _)
		return {}
	end
})
