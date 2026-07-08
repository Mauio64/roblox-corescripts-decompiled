local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function getVngShopUrl(p1) -- line: 5
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getVngShopUrl():andThen(function(p2) -- line: 8
		-- upvalues: Promise (copy)
		return Promise.resolve(p2)
	end):catch(function(_) -- line: 11
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getVngShopUrl
