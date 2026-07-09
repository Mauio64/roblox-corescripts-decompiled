local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function deprecated_GetProductInfo(p1, p2, p3) -- line: 6
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getProductInfo(p2, p3):catch(function(_) -- line: 7
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return deprecated_GetProductInfo
