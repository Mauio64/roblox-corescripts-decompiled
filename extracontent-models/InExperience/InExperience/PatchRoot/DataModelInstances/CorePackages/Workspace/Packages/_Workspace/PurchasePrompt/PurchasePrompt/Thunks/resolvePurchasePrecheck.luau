local ParentParent = script.Parent.Parent
local SetPromptState = require(ParentParent.Actions.SetPromptState)
local PromptState = require(ParentParent.Enums.PromptState)
local PurchaseWarning = require(ParentParent.Enums.PurchaseWarning)
local launchRobuxUpsell = require(ParentParent.Thunks.launchRobuxUpsell)
local Thunk = require(ParentParent.Thunk)

local function resolvePurchasePrecheck(p1) -- line: 9
	-- upvalues: Thunk (copy), PurchaseWarning (copy), SetPromptState (copy), PromptState (copy), launchRobuxUpsell (copy)
	return Thunk.new(script.Name, {}, function(p2, _) -- line: 10
		-- upvalues: p1 (copy), PurchaseWarning (copy), SetPromptState (copy), PromptState (copy), launchRobuxUpsell (copy)
		if p1 == PurchaseWarning.U13PaymentModal then
			return p2:dispatch(SetPromptState(PromptState.U13PaymentModal))
		end

		if p1 == PurchaseWarning.U13MonthlyThreshold1Modal then
			return p2:dispatch(SetPromptState(PromptState.U13MonthlyThreshold1Modal))
		end

		if p1 == PurchaseWarning.RequireEmailVerification then
			return p2:dispatch(SetPromptState(PromptState.RequireEmailVerification))
		end

		if p1 == PurchaseWarning.U13MonthlyThreshold2Modal then
			return p2:dispatch(SetPromptState(PromptState.U13MonthlyThreshold2Modal))
		end

		if p1 == PurchaseWarning.ParentalConsentWarningPaymentModal13To17 then
			return p2:dispatch(SetPromptState(PromptState.ParentalConsentWarningPaymentModal13To17))
		end

		return p2:dispatch(launchRobuxUpsell())
	end)
end

return resolvePurchasePrecheck
