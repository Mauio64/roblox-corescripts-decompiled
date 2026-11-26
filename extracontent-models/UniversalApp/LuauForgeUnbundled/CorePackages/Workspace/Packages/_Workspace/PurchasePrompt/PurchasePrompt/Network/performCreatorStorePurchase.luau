local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function performCreatorStorePurchase(p2, p3, p4)
	return p2.performCreatorStorePurchase(p3, p4):andThen(function(p5)
		if
			p5.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_ALREADY_OWNED"
			or p5.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_SUCCESS"
		then
			return Promise.resolve(p5)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(p5)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performCreatorStorePurchase
