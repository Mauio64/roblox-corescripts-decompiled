local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local addRawValueMethodToEnum = require(ParentParent.Utility.addRawValueMethodToEnum)
local enumerate = require(ParentParentParent.enumerate)
local t1 = {
	None = "None",
	Unknown = "Unknown",
	AlreadyOwn = "AlreadyOwn",
	FailedGrant = "FailedGrant",
	FailedGrantUnknown = "FailedGrantUnknown",
	Limited = "Limited",
	NotEnoughRobux = "NotEnoughRobux",
	NotEnoughRobuxInApp = "NotEnoughRobuxInApp",
	NotForSale = "NotForSale",
	NotForSaleExperience = "NotForSaleExperience",
	PremiumOnly = "PremiumOnly",
	ThirdPartyDisabled = "ThirdPartyDisabled",
	Under13 = "Under13",
	PremiumPlatformUnavailable = "PremiumPlatformUnavailable",
	AlreadyPremium = "AlreadyPremium",
	PurchaseLimit = "PurchaseLimit",
	ParentalLimit = "ParentalLimit",
	AlreadySubscribed = "AlreadySubscribed",
	SubscriptionNotForSale = "SubscriptionNotForSale",
	SubscriptionExceededUserSpendLimit = "SubscriptionExceededUserSpendLimit",
	SubscriptionUnsupportedLocale = "SubscriptionUnsupportedLocale",
	RestrictedUser = "RestrictedUser",
	SubscriptionPurchasePlatformNotSupported = "SubscriptionPurchasePlatformNotSupported",
	SubscriptionInvalidSaleLocation = "SubscriptionInvalidSaleLocation",
	VpcRequired = "VpcRequired",
	FailedRobuxPurchase = "FailedRobuxPurchase",
	ExceedParentalSpendLimit = "ExceedParentalSpendLimit",
	EconomicRestriction = "EconomicRestriction"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
