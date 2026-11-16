local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local Promise = require(PurchasePrompt.Promise)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
require(PurchasePrompt.types)

local function expectField(p: string, p2: string) -- 2 equivalent calls inferred from this helper
	return function(p3)
		if type(p3) == "table" and type(p3[p]) == p2 then
			return p3
		end

		return Promise.reject(PurchaseError.UnknownFailure)
	end
end

local function updateVIPServerConfiguration(p, p2: number, data)
	local v = { friendsAllowed = data.friendsAllowed }

	if #data.usersToAdd > 0 then
		local usersToAdd = {}

		for _, v2 in data.usersToAdd do
			table.insert(usersToAdd, (tostring(v2)))
		end

		v.usersToAdd = usersToAdd
	end

	local v2 = { p.updateVIPServerPermissions(p2, v):andThen(expectField("friendsAllowed", "boolean")) } -- inferred equivalent call

	local name = nil

	if data.name ~= nil then
		table.insert(
			v2,
			p.updateVIPServer(p2, { name = data.name }):andThen(expectField("name", "string")):andThen(function(p3) -- inferred equivalent call
				name = p3.name
			end)
		)
	end

	return Promise.all(v2):andThen(function()
		return name
	end)
end

return updateVIPServerConfiguration
