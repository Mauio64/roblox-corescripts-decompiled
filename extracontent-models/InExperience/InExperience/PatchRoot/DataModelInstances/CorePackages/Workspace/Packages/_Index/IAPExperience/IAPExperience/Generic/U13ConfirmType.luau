local parent = script.Parent.Parent
local parent2 = parent.Parent

local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
	None = "None",
	U13PaymentModal = "U13PaymentModal",
	U13MonthlyThreshold1Modal = "U13MonthlyThreshold1Modal",
	U13MonthlyThreshold2Modal = "U13MonthlyThreshold2Modal",
	ParentalConsentWarningPaymentModal13To17 = "ParentalConsentWarningPaymentModal13To17"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
