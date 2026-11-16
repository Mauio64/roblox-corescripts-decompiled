local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local parent = CommercePurchaseApp.Parent
local Rodux = require(parent.Rodux)

local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local CommercePurchaseFailed = require(CommercePurchaseApp.Store.Actions.CommercePurchaseFailed)
local CommercePurchaseStarted = require(CommercePurchaseApp.Store.Actions.CommercePurchaseStarted)
local CommercePurchaseCheckout = require(CommercePurchaseApp.Store.Actions.CommercePurchaseCheckout)

require(CommercePurchaseApp.Store.Types)

local function createInitialState() -- 2 equivalent calls inferred from this helper
	return { promptState = CommercePurchasePromptStateEnum.None }
end

local createReducer = Rodux.createReducer
local initialState = createInitialState() -- inferred equivalent call
return (createReducer(initialState, {
	[CommercePurchaseEnded.name] = function(_, _)
		return createInitialState() -- inferred equivalent call
	end,
	[CommercePurchaseFailed.name] = function(p, p2)
		local clone = table.clone(p)
		clone.errorCode = p2.errorCode
		clone.promptState = CommercePurchasePromptStateEnum.Error
		return clone
	end,
	[CommercePurchaseStarted.name] = function(p, p2)
		local clone = table.clone(p)
		clone.promptState = CommercePurchasePromptStateEnum.Started
		clone.commerceProductId = p2.commerceProductId
		return clone
	end,
	[CommercePurchaseCheckout.name] = function(p, p2)
		local clone = table.clone(p)
		clone.promptState = CommercePurchasePromptStateEnum.Checkout
		clone.checkoutSessionId = p2.checkoutSessionId
		return clone
	end
}))
