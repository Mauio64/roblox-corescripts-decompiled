local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)
local isEconomicRestrictionResponse = require(PurchasePromptParent.IAPExperience).Utility.isEconomicRestrictionResponse
local parseSubscriptionError = require(PurchasePrompt.Utils.parseSubscriptionError)

local function performDeveloperSubscriptionFiatPurchase(p1, s1: string) -- line: 11
	-- upvalues: isEconomicRestrictionResponse (copy), Promise (copy), parseSubscriptionError (copy), PurchaseError (copy)
	return p1.performSubscriptionPurchase(s1, ""):andThen(function(p2) -- line: 12
		-- upvalues: isEconomicRestrictionResponse (copy), Promise (copy)
		if isEconomicRestrictionResponse(p2) then
			return Promise.reject(p2)
		end

		return Promise.resolve(p2)
	end, function(p3) -- line: 18
		-- upvalues: Promise (copy), parseSubscriptionError (copy), PurchaseError (copy)
		if type(p3) == "string" then
			return Promise.reject(parseSubscriptionError(p3))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionFiatPurchase
