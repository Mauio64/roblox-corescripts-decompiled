local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")
local CommercePurchaseAppParent = CommercePurchaseApp.Parent
local Rodux = require(CommercePurchaseAppParent.Rodux)
local CommercePurchasePromptStateEnum = require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)
local CommercePurchaseEnded = require(CommercePurchaseApp.Store.Actions.CommercePurchaseEnded)
local CommercePurchaseFailed = require(CommercePurchaseApp.Store.Actions.CommercePurchaseFailed)
local CommercePurchaseStarted = require(CommercePurchaseApp.Store.Actions.CommercePurchaseStarted)
local CommercePurchaseCheckout = require(CommercePurchaseApp.Store.Actions.CommercePurchaseCheckout)

require(CommercePurchaseApp.Store.Types)

local function createInitialState() -- line: 20
	-- upvalues: CommercePurchasePromptStateEnum (copy)
	return {
		promptState = CommercePurchasePromptStateEnum.None
	}
end

return (Rodux.createReducer({
	promptState = CommercePurchasePromptStateEnum.None
}, {
	[CommercePurchaseEnded.name] = function(_, _) -- line: 27
		-- upvalues: CommercePurchasePromptStateEnum (copy)
		return {
			promptState = CommercePurchasePromptStateEnum.None
		}
	end,
	[CommercePurchaseFailed.name] = function(p3, p4) -- line: 30
		-- upvalues: CommercePurchasePromptStateEnum (copy)
		local v14 = table.clone(p3)

		v14.errorCode = p4.errorCode
		v14.promptState = CommercePurchasePromptStateEnum.Error

		return v14
	end,
	[CommercePurchaseStarted.name] = function(p5, p6) -- line: 36
		-- upvalues: CommercePurchasePromptStateEnum (copy)
		local v17 = table.clone(p5)

		v17.promptState = CommercePurchasePromptStateEnum.Started
		v17.commerceProductId = p6.commerceProductId

		return v17
	end,
	[CommercePurchaseCheckout.name] = function(p7, p8) -- line: 42
		-- upvalues: CommercePurchasePromptStateEnum (copy)
		local v20 = table.clone(p7)

		v20.promptState = CommercePurchasePromptStateEnum.Checkout
		v20.checkoutSessionId = p8.checkoutSessionId

		return v20
	end
}))
