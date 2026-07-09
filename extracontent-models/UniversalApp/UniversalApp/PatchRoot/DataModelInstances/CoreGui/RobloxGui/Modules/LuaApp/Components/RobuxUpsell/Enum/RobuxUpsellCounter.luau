local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local addRawValueMethodToEnum = require(Modules.LuaApp.Enum.AccountSecurity.addRawValueMethodToEnum)
local enumerate = require(CorePackages.Packages.enumerate)
local t1 = {
	UnknownError = "UnknownError",
	UpsellShown = "UpsellShown",
	UpsellModalShown = "UpsellModalShown",
	UpsellGenericModalShown = "UpsellGenericModalShown",
	UpsellCancelled = "UpsellCancelled",
	UpsellFailedNotEnoughRobux = "UpsellFailedNotEnoughRobux",
	UpsellFailedNativePurchase = "UpsellFailedNativePurchase",
	UpsellFailedTwoStep = "UpsellFailedTwoStep",
	UpsellFailed = "UpsellFailed",
	UpsellSuccess = "UpsellSuccess",
	ShowU13PaymentModal = "ShowU13PaymentModal",
	ShowU13MonthlyThreshold1Modal = "ShowU13MonthlyThreshold1Modal",
	ShowU13MonthlyThreshold2Modal = "ShowU13MonthlyThreshold2Modal",
	ShowParentalConsentWarningPaymentModal13To17 = "ShowParentalConsentWarningPaymentModal13To17",
	ConfirmU13PaymentModal = "ConfirmU13PaymentModal",
	ConfirmU13MonthlyThreshold1Modal = "ConfirmU13MonthlyThreshold1Modal",
	ConfirmU13MonthlyThreshold2Modal = "ConfirmU13MonthlyThreshold2Modal",
	ConfirmParentalConsentWarningPaymentModal13To17 = "ConfirmParentalConsentWarningPaymentModal13To17",
	ShownEnableTwoStepAuth = "ShownEnableTwoStepAuth",
	ShownTwoStepAuth = "ShownTwoStepAuth",
	FailedShowTwoStepAuth = "FailedShowTwoStepAuth",
	FailedShowTwoStepAuthUnknown = "FailedShowTwoStepAuthUnknown",
	CompletedTwoStepAuth = "CompletedTwoStepAuth",
	InvalidatedTwoStepAuth = "InvalidatedTwoStepAuth",
	AbandonedTwoStepAuth = "AbandonedTwoStepAuth",
	LoadFailedTwoStepAuth = "LoadFailedTwoStepAuth",
	ShowPurchaseNotEnabledModal = "ShowPurchaseNotEnabledModal",
	ShowEconomicRestrictionModal = "ShowEconomicRestrictionModal"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
