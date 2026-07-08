local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local StartPurchase = require(PurchasePrompt.Actions.StartPurchase)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local PromptState = require(PurchasePrompt.Enums.PromptState)

return (Rodux.createReducer(PromptState.None, {
	[SetPromptState.name] = function(_, p2) -- line: 14
		return p2.promptState
	end,
	[CompleteRequest.name] = function(_, _) -- line: 17
		-- upvalues: PromptState (copy)
		return PromptState.None
	end,
	[ErrorOccurred.name] = function(_, _) -- line: 20
		-- upvalues: PromptState (copy)
		return PromptState.Error
	end,
	[StartPurchase.name] = function(_, _) -- line: 23
		-- upvalues: PromptState (copy)
		return PromptState.PurchaseInProgress
	end,
	[PromptNativeUpsellSuggestions.name] = function(_, _) -- line: 26
		-- upvalues: PromptState (copy)
		return PromptState.RobuxUpsell
	end
}))
