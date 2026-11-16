local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)
local IAPExperience = require(parent.IAPExperience)
require(PurchasePrompt.types)

local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local function performVIPServerPurchase(p, p2: number, p3)
	return p.performVIPServerPurchase(p2, p3):andThen(function(p4)
		if isEconomicRestrictionResponse(p4) then
			return Promise.reject(p4)
		end

		if type(p4) == "table" and type(p4.vipServerId) == "number" then
			return p4
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performVIPServerPurchase
