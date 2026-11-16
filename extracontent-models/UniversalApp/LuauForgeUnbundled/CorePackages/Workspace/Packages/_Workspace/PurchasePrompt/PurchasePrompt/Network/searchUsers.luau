local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function searchUsers(p2, p3)
	return p2.searchUsers(p3):andThen(function(p4)
		if type(p4) ~= "table" or type(p4.data) ~= "table" then
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		local result = {}

		for k, v5 in p4.data do
			table.insert(result, {
				userId = v5.id,
				displayName = v5.displayName or v5.name
			})
		end

		return result
	end)
end

return searchUsers
