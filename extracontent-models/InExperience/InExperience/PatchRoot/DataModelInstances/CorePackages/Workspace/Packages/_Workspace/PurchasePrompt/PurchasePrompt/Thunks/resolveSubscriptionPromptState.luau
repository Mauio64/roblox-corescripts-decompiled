local parent = script.Parent.Parent

local SetPromptState = require(parent.Actions.SetPromptState)
local ErrorOccurred = require(parent.Actions.ErrorOccurred)
local SubscriptionPurchaseInfoReceived = require(parent.Actions.SubscriptionPurchaseInfoReceived)

local PromptState = require(parent.Enums.PromptState)
local PurchaseError = require(parent.Enums.PurchaseError)

local Thunk = require(parent.Thunk)

local function resolveSubscriptionPromptState(p)
	return Thunk.new(script.Name, nil, function(object, _)
		object:dispatch(SubscriptionPurchaseInfoReceived(p))

		if p.CanPurchase == false then
			return object:dispatch(ErrorOccurred(PurchaseError.AlreadySubscribed))
		end

		return object:dispatch(SetPromptState(PromptState.PromptSubscriptionPurchase))
	end)
end

return resolveSubscriptionPromptState
