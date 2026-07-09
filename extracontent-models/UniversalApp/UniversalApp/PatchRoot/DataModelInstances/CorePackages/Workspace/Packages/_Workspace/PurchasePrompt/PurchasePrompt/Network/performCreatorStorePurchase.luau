local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)

require(ParentParent.Misc.Constants)

local Promise = require(ParentParent.Promise)

local function performCreatorStorePurchase(p1, p2, p3) -- line: 7
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.performCreatorStorePurchase(p2, p3):andThen(function(p4) -- line: 8
		-- upvalues: Promise (copy), PurchaseError (copy)
		if p4.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_ALREADY_OWNED" or p4.purchaseTransactionStatus == "PURCHASE_TRANSACTION_STATUS_SUCCESS" then
			return Promise.resolve(p4)
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end, function(_) -- line: 17
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return performCreatorStorePurchase
