local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function deprecated_GetProductInfo(p, p2, p3)
	return p.getProductInfo(p2, p3):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return deprecated_GetProductInfo
