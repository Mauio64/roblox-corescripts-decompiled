local parent = script.Parent.Parent

local SetPromptState = require(parent.Actions.SetPromptState)
local PromptState = require(parent.Enums.PromptState)
local PurchaseWarning = require(parent.Enums.PurchaseWarning)
local launchRobuxUpsell = require(parent.Thunks.launchRobuxUpsell)
local Thunk = require(parent.Thunk)

local function resolvePurchasePrecheck(p)
	return Thunk.new(script.Name, {}, function(object, _)
		if p == PurchaseWarning.U13PaymentModal then
			return object:dispatch(SetPromptState(PromptState.U13PaymentModal))
		end

		if p == PurchaseWarning.U13MonthlyThreshold1Modal then
			return object:dispatch(SetPromptState(PromptState.U13MonthlyThreshold1Modal))
		end

		if p == PurchaseWarning.RequireEmailVerification then
			return object:dispatch(SetPromptState(PromptState.RequireEmailVerification))
		end

		if p == PurchaseWarning.U13MonthlyThreshold2Modal then
			return object:dispatch(SetPromptState(PromptState.U13MonthlyThreshold2Modal))
		end

		if p == PurchaseWarning.ParentalConsentWarningPaymentModal13To17 then
			return object:dispatch(SetPromptState(PromptState.ParentalConsentWarningPaymentModal13To17))
		end

		return object:dispatch(launchRobuxUpsell())
	end)
end

return resolvePurchasePrecheck
