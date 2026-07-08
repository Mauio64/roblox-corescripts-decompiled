local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function getPurchaseWarning(p1, s1: string?, n1: number?, b1: boolean) -- line: 5
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getPurchaseWarning(s1, n1, b1):andThen(function(p2) -- line: 8
		-- upvalues: Promise (copy)
		return Promise.resolve(p2)
	end):catch(function(_) -- line: 11
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getPurchaseWarning
