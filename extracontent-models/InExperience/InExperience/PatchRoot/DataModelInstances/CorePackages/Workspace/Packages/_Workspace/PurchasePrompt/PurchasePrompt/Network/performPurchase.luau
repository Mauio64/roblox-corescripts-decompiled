local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Constants = require(PurchasePrompt.Misc.Constants)
local Promise = require(PurchasePrompt.Promise)
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)

local parent = PurchasePrompt.Parent
local IAPExperience = require(parent.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local SharedFlags = require(parent.SharedFlags)

local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop

local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)

local function performPurchase(p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	local performPurchase2 = p.performPurchase

	if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
		p11 = nil
	end

	if not FFlagEnablePurchasePayloadInExperienceShop then
		p12 = nil
	end

	return performPurchase2(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13):andThen(function(data)
		if data.purchased or data.reason == "AlreadyOwned" then
			return Promise.resolve(data)
		end

		if data.reason == Constants.PurchaseFailureReason.EconomyDisabled then
			return Promise.reject(PurchaseError.PurchaseDisabled)
		end

		if not (data.reason ~= Constants.PurchaseFailureReason.TwoStepVerificationRequired and data.transactionStatus ~= 24) then
			return Promise.reject(PurchaseError.TwoFactorNeeded)
		end

		if isGenericChallengeResponse(data) or isEconomicRestrictionResponse(data) then
			return Promise.reject(data)
		end

		if FFlagEnablePriceChangedErrorHandling and data.reason == Constants.PurchaseFailureReason.PriceChanged then
			return Promise.reject(PurchaseError.PriceChanged)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performPurchase
