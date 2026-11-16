local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local Promise = require(PurchasePrompt.Promise)
require(PurchasePrompt.types)

local function searchUsers(p, p2: string)
	return p.searchUsers(p2):andThen(function(p3)
		if type(p3) ~= "table" or type(p3.data) ~= "table" then
			return Promise.reject(PurchaseError.UnknownFailure)
		end

		local result = {}

		for _, v in p3.data do
			table.insert(result, {
				userId = v.id,
				displayName = v.displayName or v.name
			})
		end

		return result
	end)
end

return searchUsers
