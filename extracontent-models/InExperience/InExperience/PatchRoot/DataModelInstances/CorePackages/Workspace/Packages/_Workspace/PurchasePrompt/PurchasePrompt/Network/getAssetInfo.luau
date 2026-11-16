local parent = script.Parent.Parent

local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function getAssetInfo(p, p2: number)
	return p.getAssetInfo(p2):andThen(function(p3)
		return Promise.resolve(p3)
	end):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getAssetInfo
