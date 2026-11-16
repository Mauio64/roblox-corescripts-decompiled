local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").enumerate

local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/addRawValueMethodToEnum")

local v5 = {}

local v6 = {
	None = "None",
	ConfirmedU13PaymentModal = "ConfirmedU13PaymentModal",
	ConfirmedU13MonthlyThreshold1Modal = "ConfirmedU13MonthlyThreshold1Modal",
	ConfirmedU13MonthlyThreshold2Modal = "ConfirmedU13MonthlyThreshold2Modal",
	ConfirmedParentalConsentWarningPaymentModal13To17 = "ConfirmedParentalConsentWarningPaymentModal13To17"
}

v5.UserActionType = enumerate("postPurchaseWarningAcknowledge", v6)
addRawValueMethodToEnum(v5.UserActionType, v6)

function v5.Post(p2, p3)
	local rawValue = v5.UserActionType.toRawValue(p3)
	return p2.postPurchaseWarningAcknowledge(rawValue)
end

return v5
