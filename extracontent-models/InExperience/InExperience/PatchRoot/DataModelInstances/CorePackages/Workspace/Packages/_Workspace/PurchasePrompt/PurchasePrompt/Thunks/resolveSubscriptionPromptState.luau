local ParentParent = script.Parent.Parent
local SetPromptState = require(ParentParent.Actions.SetPromptState)
local ErrorOccurred = require(ParentParent.Actions.ErrorOccurred)
local SubscriptionPurchaseInfoReceived = require(ParentParent.Actions.SubscriptionPurchaseInfoReceived)
local PromptState = require(ParentParent.Enums.PromptState)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Thunk = require(ParentParent.Thunk)

local function resolveSubscriptionPromptState(p1) -- line: 13
	-- upvalues: Thunk (copy), SubscriptionPurchaseInfoReceived (copy), ErrorOccurred (copy), PurchaseError (copy), SetPromptState (copy), PromptState (copy)
	return Thunk.new(script.Name, nil, function(p2, _) -- line: 14
		-- upvalues: SubscriptionPurchaseInfoReceived (copy), p1 (copy), ErrorOccurred (copy), PurchaseError (copy), SetPromptState (copy), PromptState (copy)
		p2:dispatch(SubscriptionPurchaseInfoReceived(p1))

		if p1.CanPurchase == false then
			return p2:dispatch(ErrorOccurred(PurchaseError.AlreadySubscribed))
		end

		return p2:dispatch(SetPromptState(PromptState.PromptSubscriptionPurchase))
	end)
end

return resolveSubscriptionPromptState
