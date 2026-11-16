local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Constants = require(parent.Misc.Constants)
local Promise = require(parent.Promise)
local isGenericChallengeResponse = require(parent.Utils.isGenericChallengeResponse)

local parent2 = parent.Parent
local IAPExperience = require(parent2.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local FFlagEnablePriceChangedErrorHandling = require(parent.Flags.FFlagEnablePriceChangedErrorHandling)

local function performPurchaseV2(p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	return p.performPurchaseV2(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12):andThen(function(data)
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

return performPurchaseV2
