local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function checkUserPurchaseSettings(p2)
	return p2.checkUserPurchaseSettings():andThen(function(p3)
		return Promise.resolve(p3)
	end):catch(function(p3)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return checkUserPurchaseSettings
