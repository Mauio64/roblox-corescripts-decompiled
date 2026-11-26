local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local parseSubscriptionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/parseSubscriptionError")

local function getSubscriptionPurchaseInfo(p2, p3)
	return p2.getSubscriptionPurchaseInfo(p3):catch(function(p4)
		return Promise.reject(parseSubscriptionError(p4))
	end)
end

return getSubscriptionPurchaseInfo
