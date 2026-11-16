local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function deprecated_GetProductInfo(p2, p3, p4)
	return p2.getProductInfo(p3, p4):catch(function(p5)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return deprecated_GetProductInfo
