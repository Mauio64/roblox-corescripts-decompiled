local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local isErrorReasonPrefixWithEconomicRestrictions = require(PurchasePromptParent.IAPExperience).Utility.isErrorReasonPrefixWithEconomicRestrictions

local function parseSubscriptionError(p1) -- line: 8
	-- upvalues: PurchaseError (copy), isErrorReasonPrefixWithEconomicRestrictions (copy)
	if p1 == "UserHasSpendLimitSet" then
		return PurchaseError.SubscriptionExceededUserSpendLimit
	end

	if p1 == "UnsupportedLocale" then
		return PurchaseError.SubscriptionUnsupportedLocale
	end

	if p1 == "RestrictedUser" then
		return PurchaseError.RestrictedUser
	end

	if p1 == "PurchasePlatformNotSupported" then
		return PurchaseError.SubscriptionPurchasePlatformNotSupported
	end

	if p1 == "InvalidSaleLocation" then
		return PurchaseError.SubscriptionInvalidSaleLocation
	end

	if p1 == "UserAlreadySubscribed" then
		return PurchaseError.AlreadySubscribed
	end

	if p1 == "ProductNotForSale" then
		return PurchaseError.SubscriptionNotForSale
	end

	if p1 == "VpcRequired" then
		return PurchaseError.VpcRequired
	end

	if p1 == "ExceedParentalSpendLimit" then
		return PurchaseError.ExceedParentalSpendLimit
	end

	if isErrorReasonPrefixWithEconomicRestrictions(p1) then
		return p1
	end

	return PurchaseError.UnknownFailure
end

return parseSubscriptionError
