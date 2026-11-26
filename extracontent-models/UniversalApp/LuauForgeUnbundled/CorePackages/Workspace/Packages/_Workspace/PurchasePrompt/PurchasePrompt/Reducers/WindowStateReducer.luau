local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local StartPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/StartPurchase")
local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")
local SetButtonState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetButtonState")
local WindowState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/WindowState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

return rodux.createReducer(WindowState.Hidden, {
	[SetPromptState.name] = function(p2, p3)
		if p3.promptState == PromptState.None then
			return WindowState.Hidden
		end

		return WindowState.Shown
	end,
	[SetButtonState.name] = function(p2, p3)
		return p3.state
	end,
	[ErrorOccurred.name] = function(p2, p3)
		return WindowState.Shown
	end,
	[StartPurchase.name] = function(p2, p3)
		return WindowState.Shown
	end,
	[PromptNativeUpsellSuggestions.name] = function(p2, p3)
		return WindowState.Shown
	end,
	[CompleteRequest.name] = function(p2, p3)
		return WindowState.Hidden
	end
})
