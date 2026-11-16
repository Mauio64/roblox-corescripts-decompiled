local parent = script.Parent.Parent
local PurchaseError = require(parent.Enums.PurchaseError)
local Promise = require(parent.Promise)

local function getUniversePrivateServerSettings(p, p2: number)
	return p.getUniversePrivateServerSettings(p2):andThen(function(p3)
		local privateServerData = p3.privateServerData

		if privateServerData == nil then
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end

		if privateServerData.isAvailable == false then
			return Promise.reject(PurchaseError.VIPServerUnavailable)
		end

		return Promise.resolve(p3)
	end, function()
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getUniversePrivateServerSettings
