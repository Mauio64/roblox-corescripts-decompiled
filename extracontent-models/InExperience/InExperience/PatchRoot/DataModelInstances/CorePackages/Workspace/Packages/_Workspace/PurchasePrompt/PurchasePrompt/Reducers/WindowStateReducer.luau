local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local StartPurchase = require(PurchasePrompt.Actions.StartPurchase)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local SetWindowState = require(PurchasePrompt.Actions.SetWindowState)
local WindowState = require(PurchasePrompt.Enums.WindowState)
local PromptState = require(PurchasePrompt.Enums.PromptState)

return Rodux.createReducer(WindowState.Hidden, {
	[SetPromptState.name] = function(_, p)
		if p.promptState == PromptState.None then
			return WindowState.Hidden
		end

		return WindowState.Shown
	end,
	[SetWindowState.name] = function(_, p)
		return p.state
	end,
	[ErrorOccurred.name] = function(_, _)
		return WindowState.Shown
	end,
	[StartPurchase.name] = function(_, _)
		return WindowState.Shown
	end,
	[PromptNativeUpsellSuggestions.name] = function(_, _)
		return WindowState.Shown
	end,
	[CompleteRequest.name] = function(_, _)
		return WindowState.Hidden
	end
})
