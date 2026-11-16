local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local parseSubscriptionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/parseSubscriptionError")

local function performSubscriptionPurchase(p2, p3, p4)
	return p2.performSubscriptionPurchase(p3, p4):catch(function(p5)
		return Promise.reject(parseSubscriptionError(p5))
	end)
end

return performSubscriptionPurchase
