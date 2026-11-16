local parent = script.Parent.Parent
local parent2 = parent.Parent

local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
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

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
