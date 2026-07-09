local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function getCatalogItemDetails(p1, n1: number, s1: string) -- line: 6
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getCatalogItemDetails(n1, s1):andThen(function(p2) -- line: 9
		-- upvalues: Promise (copy)
		return Promise.resolve(p2)
	end):catch(function(_) -- line: 12
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getCatalogItemDetails
