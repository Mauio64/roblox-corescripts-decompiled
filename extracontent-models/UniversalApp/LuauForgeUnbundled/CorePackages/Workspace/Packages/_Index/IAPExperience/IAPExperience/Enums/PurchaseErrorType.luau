local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
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
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("PurchaseErrorType", v5)

addRawValueMethodToEnum(v6, v5)

return v6
