local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local Counter = require(PurchasePrompt.Enums.Counter)
local sendCounter = require(PurchasePrompt.Thunks.sendCounter)

local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local Thunk = require(PurchasePrompt.Thunk)
local PromptState = require(PurchasePrompt.Enums.PromptState)

local v = { Analytics, Network, ExternalSettings }

local function handleNativePurchaseFailureOrCancel()
	return Thunk.new(script.Name, v, function(object, _)
		if object:getState().promptState == PromptState.BlackbirdUpsellInProgress then
			return
		end

		object:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
		object:dispatch(sendCounter(Counter.UpsellFailedNativePurchase))
	end)
end

return handleNativePurchaseFailureOrCancel
