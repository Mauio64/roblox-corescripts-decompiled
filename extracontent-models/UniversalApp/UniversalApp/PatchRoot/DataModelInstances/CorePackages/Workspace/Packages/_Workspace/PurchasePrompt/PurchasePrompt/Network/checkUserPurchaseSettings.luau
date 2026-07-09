local ParentParent = script.Parent.Parent
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local Promise = require(ParentParent.Promise)

local function checkUserPurchaseSettings(p1) -- line: 7
	-- upvalues: Promise (copy), PurchaseError (copy)
	return p1.checkUserPurchaseSettings():andThen(function(p2) -- line: 10
		-- upvalues: Promise (copy)
		return Promise.resolve(p2)
	end):catch(function(_) -- line: 13
		-- upvalues: Promise (copy), PurchaseError (copy)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return checkUserPurchaseSettings
