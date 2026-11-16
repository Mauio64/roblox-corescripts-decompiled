local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
require(parent.Misc.Constants)
local Promise = require(parent.Promise)

local function performCreatorStorePurchase(p, p2, p3)
	return p.performCreatorStorePurchase(p2, p3):andThen(function(p4)
		if
			p4.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_ALREADY_OWNED"
			or p4.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_SUCCESS"
		then
			return Promise.resolve(p4)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performCreatorStorePurchase
