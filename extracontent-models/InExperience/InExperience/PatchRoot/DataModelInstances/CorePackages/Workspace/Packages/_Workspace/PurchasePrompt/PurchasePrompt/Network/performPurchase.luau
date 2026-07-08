local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Constants = require(PurchasePrompt.Misc.Constants)
local Promise = require(PurchasePrompt.Promise)
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)
local PurchasePromptParent = PurchasePrompt.Parent
local isEconomicRestrictionResponse = require(PurchasePromptParent.IAPExperience).Utility.isEconomicRestrictionResponse
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)

local function performPurchase(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) -- line: 20
	-- upvalues: FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), Promise (copy), Constants (copy), PurchaseError (copy), isGenericChallengeResponse (copy), isEconomicRestrictionResponse (copy), FFlagEnablePriceChangedErrorHandling (copy)
	return p1.performPurchase(p2, p3, p4, p5, p6, p7, p8, p9, p10, (if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then nil else p11), (if not FFlagEnablePurchasePayloadInExperienceShop then nil else p12), p13):andThen(function(p14) -- line: 50
		-- upvalues: Promise (copy), Constants (copy), PurchaseError (copy), isGenericChallengeResponse (copy), isEconomicRestrictionResponse (copy), FFlagEnablePriceChangedErrorHandling (copy)
		if p14.purchased or p14.reason == "AlreadyOwned" then
			return Promise.resolve(p14)
		end

		if p14.reason == Constants.PurchaseFailureReason.EconomyDisabled then
			return Promise.reject(PurchaseError.PurchaseDisabled)
		end

		if p14.reason == Constants.PurchaseFailureReason.TwoStepVerificationRequired then
			return Promise.reject(PurchaseError.TwoFactorNeeded)
		end

		if p14.transactionStatus == 24 then
			return Promise.reject(PurchaseError.TwoFactorNeeded)
		end

		if isGenericChallengeResponse(p14) then
			return Promise.reject(p14)
		end

		if isEconomicRestrictionResponse(p14) then
			return Promise.reject(p14)
		end

		if FFlagEnablePriceChangedErrorHandling and p14.reason == Constants.PurchaseFailureReason.PriceChanged then
			return Promise.reject(PurchaseError.PriceChanged)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(_) -- line: 78
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performPurchase
