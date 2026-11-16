local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SubscriptionPurchaseInfoReceived = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SubscriptionPurchaseInfoReceived")

local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local function resolveSubscriptionPromptState(p2)
	return Thunk.new("resolveSubscriptionPromptState", nil, function(object, p3)
		object:dispatch(SubscriptionPurchaseInfoReceived(p2))

		if p2.CanPurchase == false then
			return object:dispatch(ErrorOccurred(PurchaseError.AlreadySubscribed))
		end

		return object:dispatch(SetPromptState(PromptState.PromptSubscriptionPurchase))
	end)
end

return resolveSubscriptionPromptState
