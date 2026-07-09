local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function getAccountInfo(p1, _) -- line: 6
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.getAccountInfo():andThen(function(p3) -- line: 9
		-- upvalues: Promise (copy)
		return Promise.resolve(p3)
	end):catch(function(_) -- line: 12
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getAccountInfo
