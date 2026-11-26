local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")

local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local Counter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/Counter")
local sendCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendCounter")

local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

local v5 = { Analytics, Network, ExternalSettings }

local function handleNativePurchaseFailureOrCancel()
	return Thunk.new("handleNativePurchaseFailureOrCancel", v5, function(object, p2)
		if object:getState().promptState == PromptState.BlackbirdUpsellInProgress then
			return
		end

		object:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
		object:dispatch(sendCounter(Counter.UpsellFailedNativePurchase))
	end)
end

return handleNativePurchaseFailureOrCancel
