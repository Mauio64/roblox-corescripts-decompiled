local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local isErrorReasonPrefixWithEconomicRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Utility.isErrorReasonPrefixWithEconomicRestrictions

local function parseSubscriptionError(p2)
	if p2 == "UserHasSpendLimitSet" then
		return PurchaseError.SubscriptionExceededUserSpendLimit
	elseif p2 == "UnsupportedLocale" then
		return PurchaseError.SubscriptionUnsupportedLocale
	elseif p2 == "RestrictedUser" then
		return PurchaseError.RestrictedUser
	elseif p2 == "PurchasePlatformNotSupported" then
		return PurchaseError.SubscriptionPurchasePlatformNotSupported
	elseif p2 == "InvalidSaleLocation" then
		return PurchaseError.SubscriptionInvalidSaleLocation
	elseif p2 == "UserAlreadySubscribed" then
		return PurchaseError.AlreadySubscribed
	elseif p2 == "ProductNotForSale" then
		return PurchaseError.SubscriptionNotForSale
	elseif p2 == "VpcRequired" then
		return PurchaseError.VpcRequired
	elseif p2 == "ExceedParentalSpendLimit" then
		return PurchaseError.ExceedParentalSpendLimit
	end

	if isErrorReasonPrefixWithEconomicRestrictions(p2) then
		return p2
	end

	return PurchaseError.UnknownFailure
end

return parseSubscriptionError
