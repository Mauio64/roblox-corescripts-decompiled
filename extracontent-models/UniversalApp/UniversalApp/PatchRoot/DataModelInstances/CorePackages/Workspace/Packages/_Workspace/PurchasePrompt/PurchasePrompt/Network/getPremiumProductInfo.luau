local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function getPremiumProductInfo(p1) -- line: 5
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getPremiumProductInfo():catch(function(_) -- line: 6
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getPremiumProductInfo
