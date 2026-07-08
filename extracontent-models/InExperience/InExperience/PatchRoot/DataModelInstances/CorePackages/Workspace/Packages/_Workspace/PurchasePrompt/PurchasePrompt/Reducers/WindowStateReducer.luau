local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local CompleteRequest = require(PurchasePrompt.Actions.CompleteRequest)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local StartPurchase = require(PurchasePrompt.Actions.StartPurchase)
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)
local SetWindowState = require(PurchasePrompt.Actions.SetWindowState)
local WindowState = require(PurchasePrompt.Enums.WindowState)
local PromptState = require(PurchasePrompt.Enums.PromptState)

return Rodux.createReducer(WindowState.Hidden, {
	[SetPromptState.name] = function(_, p2) -- line: 18
		-- upvalues: PromptState (copy), WindowState (copy)
		if p2.promptState == PromptState.None then
			return WindowState.Hidden
		end

		return WindowState.Shown
	end,
	[SetWindowState.name] = function(_, p4) -- line: 25
		return p4.state
	end,
	[ErrorOccurred.name] = function(_, _) -- line: 28
		-- upvalues: WindowState (copy)
		return WindowState.Shown
	end,
	[StartPurchase.name] = function(_, _) -- line: 31
		-- upvalues: WindowState (copy)
		return WindowState.Shown
	end,
	[PromptNativeUpsellSuggestions.name] = function(_, _) -- line: 34
		-- upvalues: WindowState (copy)
		return WindowState.Shown
	end,
	[CompleteRequest.name] = function(_, _) -- line: 37
		-- upvalues: WindowState (copy)
		return WindowState.Hidden
	end
})
