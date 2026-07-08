local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Constants = require(ParentParent.Misc.Constants)
local Promise = require(ParentParent.Promise)
local isGenericChallengeResponse = require(ParentParent.Utils.isGenericChallengeResponse)
local ParentParentParent = ParentParent.Parent
local isEconomicRestrictionResponse = require(ParentParentParent.IAPExperience).Utility.isEconomicRestrictionResponse
local FFlagEnablePriceChangedErrorHandling = require(ParentParent.Flags.FFlagEnablePriceChangedErrorHandling)

local function performPurchaseV2(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) -- line: 17
	-- upvalues: Promise (copy), Constants (copy), PurchaseError (copy), isGenericChallengeResponse (copy), isEconomicRestrictionResponse (copy), FFlagEnablePriceChangedErrorHandling (copy)
	return p1.performPurchaseV2(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12):andThen(function(p13) -- line: 45
		-- upvalues: Promise (copy), Constants (copy), PurchaseError (copy), isGenericChallengeResponse (copy), isEconomicRestrictionResponse (copy), FFlagEnablePriceChangedErrorHandling (copy)
		if p13.purchased or p13.reason == "AlreadyOwned" then
			return Promise.resolve(p13)
		end

		if p13.reason == Constants.PurchaseFailureReason.EconomyDisabled then
			return Promise.reject(PurchaseError.PurchaseDisabled)
		end

		if p13.reason == Constants.PurchaseFailureReason.TwoStepVerificationRequired then
			return Promise.reject(PurchaseError.TwoFactorNeeded)
		end

		if p13.transactionStatus == 24 then
			return Promise.reject(PurchaseError.TwoFactorNeeded)
		end

		if isGenericChallengeResponse(p13) then
			return Promise.reject(p13)
		end

		if isEconomicRestrictionResponse(p13) then
			return Promise.reject(p13)
		end

		if FFlagEnablePriceChangedErrorHandling and p13.reason == Constants.PurchaseFailureReason.PriceChanged then
			return Promise.reject(PurchaseError.PriceChanged)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(_) -- line: 73
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performPurchaseV2
