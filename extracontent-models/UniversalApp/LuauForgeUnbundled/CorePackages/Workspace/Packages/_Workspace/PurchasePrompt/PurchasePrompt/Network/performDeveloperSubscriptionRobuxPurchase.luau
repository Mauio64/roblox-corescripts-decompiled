local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local parseSubscriptionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/parseSubscriptionError")

local function performDeveloperSubscriptionRobuxPurchase(p2, p3, p4)
	return p2.performDeveloperSubscriptionRobuxPurchase(p3, p4):andThen(function()
		return Promise.resolve()
	end, function(value)
		if type(value) == "string" then
			return Promise.reject(parseSubscriptionError(value))
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performDeveloperSubscriptionRobuxPurchase
