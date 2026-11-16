local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function getAccountInfo(p, _)
	return p.getAccountInfo():andThen(function(p2)
		return Promise.resolve(p2)
	end):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getAccountInfo
