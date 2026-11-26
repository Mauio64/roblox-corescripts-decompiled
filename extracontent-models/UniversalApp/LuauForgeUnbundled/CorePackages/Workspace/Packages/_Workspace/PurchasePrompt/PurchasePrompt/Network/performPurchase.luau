local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local isGenericChallengeResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isGenericChallengeResponse")

local isEconomicRestrictionResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Utility.isEconomicRestrictionResponse

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local fFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop

local FFlagEnablePriceChangedErrorHandling = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePriceChangedErrorHandling")

local function performPurchase(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14)
	local performPurchase2 = p2.performPurchase

	if not fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
		p12 = nil
	end

	if not fFlagEnablePurchasePayloadInExperienceShop then
		p13 = nil
	end

	return performPurchase2(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14):andThen(function(data)
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
	end, function(p15)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performPurchase
