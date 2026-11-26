local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function expectField(p2, p3)
	return function(p4)
		if type(p4) == "table" and type(p4[p2]) == p3 then
			return p4
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end
end

local function updateVIPServerConfiguration(p2, p3, data)
	local v5 = { friendsAllowed = data.friendsAllowed }

	if #data.usersToAdd > 0 then
		local v6 = {}

		for k, v7 in data.usersToAdd do
			table.insert(v6, (tostring(v7)))
		end

		v5.usersToAdd = v6
	end

	local v6 = "friendsAllowed"
	local v7 = "boolean"
	local v8 = { p2.updateVIPServerPermissions(p3, v5):andThen(function(p4)
			if type(p4) == "table" and type(p4[v6]) == v7 then
				return p4
			end

			return Promise.reject(PurchaseError.UnknownFailure)
		end) }

	local name = nil

	if data.name ~= nil then
		local v9 = "name"
		local v10 = "string"
		table.insert(v8, p2.updateVIPServer(p3, { name = data.name }):andThen(function(p4)
			if type(p4) == "table" and type(p4[v9]) == v10 then
				return p4
			end

			return Promise.reject(PurchaseError.UnknownFailure)
		end):andThen(function(p4)
			name = p4.name
		end))
	end

	return Promise.all(v8):andThen(function()
		return name
	end)
end

return updateVIPServerConfiguration
