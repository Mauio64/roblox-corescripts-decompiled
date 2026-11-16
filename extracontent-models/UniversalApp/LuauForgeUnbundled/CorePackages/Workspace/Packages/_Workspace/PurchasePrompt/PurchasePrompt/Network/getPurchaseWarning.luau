local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function getPurchaseWarning(p2, p3, p4, p5)
	return p2.getPurchaseWarning(p3, p4, p5):andThen(function(p6)
		return Promise.resolve(p6)
	end):catch(function(p6)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getPurchaseWarning
