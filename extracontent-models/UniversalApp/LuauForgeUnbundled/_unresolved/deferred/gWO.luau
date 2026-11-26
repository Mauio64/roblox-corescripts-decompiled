local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/fyX")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	ShowU13PaymentModal = "ShowU13PaymentModal",
	ShowU13MonthlyThreshold1Modal = "ShowU13MonthlyThreshold1Modal",
	ShowU13MonthlyThreshold2Modal = "ShowU13MonthlyThreshold2Modal",
	ShowParentalConsentWarningPaymentModal13To17 = "ShowParentalConsentWarningPaymentModal13To17",
	ConfirmU13PaymentModal = "ConfirmU13PaymentModal",
	ConfirmU13MonthlyThreshold1Modal = "ConfirmU13MonthlyThreshold1Modal",
	ConfirmU13MonthlyThreshold2Modal = "ConfirmU13MonthlyThreshold2Modal",
	ConfirmParentalConsentWarningPaymentModal13To17 = "ConfirmParentalConsentWarningPaymentModal13To17",
	InvalidProducts = "FailedInvalidProducts",
	PurchaseFailed = "PurchaseFailed",
	PurchaseCanceled = "PurchaseCanceled",
	ShowPurchaseNotEnabledModal = "ShowPurchaseNotEnabledModal",
	ShowEconomicRestrictionModal = "ShowEconomicRestrictionModal"
}

local v6 = enumerate("BuyRobuxCounter", v5)

module(v6, v5)

return v6
