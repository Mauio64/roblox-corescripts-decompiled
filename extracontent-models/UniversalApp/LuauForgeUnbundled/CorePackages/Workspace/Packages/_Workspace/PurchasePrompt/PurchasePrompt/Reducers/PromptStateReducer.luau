local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local StartPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/StartPurchase")
local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

return (rodux.createReducer(PromptState.None, {
	[SetPromptState.name] = function(p2, p3)
		return p3.promptState
	end,
	[CompleteRequest.name] = function(p2, p3)
		return PromptState.None
	end,
	[ErrorOccurred.name] = function(p2, p3)
		return PromptState.Error
	end,
	[StartPurchase.name] = function(p2, p3)
		return PromptState.PurchaseInProgress
	end,
	[PromptNativeUpsellSuggestions.name] = function(p2, p3)
		return PromptState.RobuxUpsell
	end
}))
