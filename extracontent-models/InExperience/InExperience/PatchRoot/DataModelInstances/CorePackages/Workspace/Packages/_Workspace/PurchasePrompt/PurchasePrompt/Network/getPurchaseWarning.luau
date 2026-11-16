local parent = script.Parent.Parent
local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function getPurchaseWarning(p, p2: string?, p3: number?, flag: boolean)
	return p.getPurchaseWarning(p2, p3, flag):andThen(function(p4)
		return Promise.resolve(p4)
	end):catch(function(_)
		return Promise.reject(PurchaseError.UnknownFailure)
	end)
end

return getPurchaseWarning
