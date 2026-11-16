local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function getProductPurchasableDetails(p2, p3)
	return p2.getProductPurchasableDetails(p3):andThen(function(p4)
		return Promise.resolve(p4)
	end):catch(function(p4)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getProductPurchasableDetails
