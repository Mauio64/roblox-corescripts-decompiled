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
local t1 = {
	Analytics,
	Network,
	ExternalSettings
}

local function handleNativePurchaseFailureOrCancel() -- line: 21
	-- upvalues: Thunk (copy), t1 (copy), PromptState (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
	return Thunk.new(script.Name, t1, function(p1, _) -- line: 22
		-- upvalues: PromptState (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
		if p1:getState().promptState == PromptState.BlackbirdUpsellInProgress then
			return
		end

		p1:dispatch(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
		p1:dispatch(sendCounter(Counter.UpsellFailedNativePurchase))
	end)
end

return handleNativePurchaseFailureOrCancel
