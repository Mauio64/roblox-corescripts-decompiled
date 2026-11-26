local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local isEconomicRestrictionResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Utility.isEconomicRestrictionResponse
local parseSubscriptionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/parseSubscriptionError")

local function performDeveloperSubscriptionFiatPurchase(p2, p3)
	return p2.performSubscriptionPurchase(p3, ""):andThen(function(p4)
		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		return Promise.resolve(p4)
	end, function(value)
		if type(value) == "string" then
			return Promise.reject(parseSubscriptionError(value))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionFiatPurchase
