local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function getCatalogItemDetails(p2, p3, p4)
	return p2.getCatalogItemDetails(p3, p4):andThen(function(p5)
		return Promise.resolve(p5)
	end):catch(function(p5)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getCatalogItemDetails
