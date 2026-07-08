local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local enumerate = require(PurchasePromptParent.PurchasePromptDeps).enumerate
local addRawValueMethodToEnum = require(PurchasePrompt.Utils.addRawValueMethodToEnum)
local t1 = {}
local t2 = {
	None = "None",
	ConfirmedU13PaymentModal = "ConfirmedU13PaymentModal",
	ConfirmedU13MonthlyThreshold1Modal = "ConfirmedU13MonthlyThreshold1Modal",
	ConfirmedU13MonthlyThreshold2Modal = "ConfirmedU13MonthlyThreshold2Modal",
	ConfirmedParentalConsentWarningPaymentModal13To17 = "ConfirmedParentalConsentWarningPaymentModal13To17"
}

t1.UserActionType = enumerate(script.Name, t2)
addRawValueMethodToEnum(t1.UserActionType, t2)

function t1.Post(p1, s1: string) -- line: 21
	-- upvalues: t1 (copy)
	local v9 = t1.UserActionType.toRawValue(s1)

	return p1.postPurchaseWarningAcknowledge(v9)
end

return t1
