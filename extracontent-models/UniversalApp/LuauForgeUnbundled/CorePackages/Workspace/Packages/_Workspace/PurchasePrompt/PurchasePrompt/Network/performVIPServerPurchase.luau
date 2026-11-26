local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse

local function performVIPServerPurchase(p2, p3, p4)
	return p2.performVIPServerPurchase(p3, p4):andThen(function(p5)
		if isEconomicRestrictionResponse(p5) then
			return Promise.reject(p5)
		end

		if type(p5) == "table" and type(p5.vipServerId) == "number" then
			return p5
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performVIPServerPurchase
