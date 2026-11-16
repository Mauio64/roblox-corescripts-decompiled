local createEnum = require(script.Parent.createEnum)

return (createEnum("PurchaseWarning", {
	"NoAction",
	"U13PaymentModal",
	"U13MonthlyThreshold1Modal",
	"RequireEmailVerification",
	"U13MonthlyThreshold2Modal",
	"ParentalConsentWarningPaymentModal13To17"
}))
