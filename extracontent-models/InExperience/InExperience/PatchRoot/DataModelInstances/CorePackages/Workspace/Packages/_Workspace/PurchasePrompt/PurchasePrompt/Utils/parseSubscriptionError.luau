local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local IAPExperience = require(parent.IAPExperience)
local isErrorReasonPrefixWithEconomicRestrictions = IAPExperience.Utility.isErrorReasonPrefixWithEconomicRestrictions

local function parseSubscriptionError(p)
	if p == "UserHasSpendLimitSet" then
		return PurchaseError.SubscriptionExceededUserSpendLimit
	elseif p == "UnsupportedLocale" then
		return PurchaseError.SubscriptionUnsupportedLocale
	elseif p == "RestrictedUser" then
		return PurchaseError.RestrictedUser
	elseif p == "PurchasePlatformNotSupported" then
		return PurchaseError.SubscriptionPurchasePlatformNotSupported
	elseif p == "InvalidSaleLocation" then
		return PurchaseError.SubscriptionInvalidSaleLocation
	elseif p == "UserAlreadySubscribed" then
		return PurchaseError.AlreadySubscribed
	elseif p == "ProductNotForSale" then
		return PurchaseError.SubscriptionNotForSale
	elseif p == "VpcRequired" then
		return PurchaseError.VpcRequired
	elseif p == "ExceedParentalSpendLimit" then
		return PurchaseError.ExceedParentalSpendLimit
	end

	if isErrorReasonPrefixWithEconomicRestrictions(p) then
		return p
	end

	return PurchaseError.UnknownFailure
end

return parseSubscriptionError
