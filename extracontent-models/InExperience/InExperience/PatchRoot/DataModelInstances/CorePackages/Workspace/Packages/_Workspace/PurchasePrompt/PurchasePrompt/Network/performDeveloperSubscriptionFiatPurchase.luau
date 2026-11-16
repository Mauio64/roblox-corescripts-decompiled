local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)
local IAPExperience = require(parent.IAPExperience)

local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseSubscriptionError = require(PurchasePrompt.Utils.parseSubscriptionError)

local function performDeveloperSubscriptionFiatPurchase(p, p2: string)
	return p.performSubscriptionPurchase(p2, ""):andThen(function(p3)
		if isEconomicRestrictionResponse(p3) then
			return Promise.reject(p3)
		end

		return Promise.resolve(p3)
	end, function(value)
		if type(value) == "string" then
			return Promise.reject(parseSubscriptionError(value))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionFiatPurchase
