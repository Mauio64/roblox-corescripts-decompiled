local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local function getUniversePrivateServerSettings(p2, p3)
	return p2.getUniversePrivateServerSettings(p3):andThen(function(p4)
		local privateServerData = p4.privateServerData

		if privateServerData == nil then
			return Promise.reject(PurchaseError.UnknownFailureNoItemName)
		end

		if privateServerData.isAvailable == false then
			return Promise.reject(PurchaseError.VIPServerUnavailable)
		end

		return Promise.resolve(p4)
	end, function()
		return Promise.reject(PurchaseError.UnknownFailureNoItemName)
	end)
end

return getUniversePrivateServerSettings
