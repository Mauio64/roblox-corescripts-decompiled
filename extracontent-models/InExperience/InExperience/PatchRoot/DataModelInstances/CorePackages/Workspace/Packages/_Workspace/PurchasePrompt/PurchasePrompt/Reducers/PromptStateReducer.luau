local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local StartPurchase = require(PurchasePrompt.Actions.StartPurchase)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local PromptState = require(PurchasePrompt.Enums.PromptState)

return (Rodux.createReducer(PromptState.None, {
	[SetPromptState.name] = function(_, p)
		return p.promptState
	end,
	[CompleteRequest.name] = function(_, _)
		return PromptState.None
	end,
	[ErrorOccurred.name] = function(_, _)
		return PromptState.Error
	end,
	[StartPurchase.name] = function(_, _)
		return PromptState.PurchaseInProgress
	end,
	[PromptNativeUpsellSuggestions.name] = function(_, _)
		return PromptState.RobuxUpsell
	end
}))
