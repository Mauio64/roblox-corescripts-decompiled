local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function getAssetInfo(p2, p3)
	return p2.getAssetInfo(p3):andThen(function(p4)
		return Promise.resolve(p4)
	end):catch(function(p4)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getAssetInfo
