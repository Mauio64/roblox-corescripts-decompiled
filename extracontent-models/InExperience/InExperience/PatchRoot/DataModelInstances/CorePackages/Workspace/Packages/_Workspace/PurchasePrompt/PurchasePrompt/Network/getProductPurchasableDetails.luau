local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function getProductPurchasableDetails(p, p2)
	return p.getProductPurchasableDetails(p2):andThen(function(p3)
		return Promise.resolve(p3)
	end):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getProductPurchasableDetails
