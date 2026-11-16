local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local enumerate = PurchasePromptDeps.enumerate

local addRawValueMethodToEnum = require(PurchasePrompt.Utils.addRawValueMethodToEnum)

local PostPurchaseWarningAcknowledge = {}

local v = {
	None = "None",
	ConfirmedU13PaymentModal = "ConfirmedU13PaymentModal",
	ConfirmedU13MonthlyThreshold1Modal = "ConfirmedU13MonthlyThreshold1Modal",
	ConfirmedU13MonthlyThreshold2Modal = "ConfirmedU13MonthlyThreshold2Modal",
	ConfirmedParentalConsentWarningPaymentModal13To17 = "ConfirmedParentalConsentWarningPaymentModal13To17"
}

PostPurchaseWarningAcknowledge.UserActionType = enumerate(script.Name, v)
addRawValueMethodToEnum(PostPurchaseWarningAcknowledge.UserActionType, v)

function PostPurchaseWarningAcknowledge.Post(p, p2: string)
	local rawValue = PostPurchaseWarningAcknowledge.UserActionType.toRawValue(p2)
	return p.postPurchaseWarningAcknowledge(rawValue)
end

return PostPurchaseWarningAcknowledge
