local module = require("@luauforge/bundled/dzz")

local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/SharedFlags").ConvertUniverseIdToString
local receivedUserPresence = require("@luauforge/bundled/ciE").Actions.ReceivedUserPresence
local module2 = require("@luauforge/bundled/dAF")

return function(options, data)
	local v5 = options or {}

	local function RemoveUserIdFromMap(p2, p3)
		local v6 = p3 and v5[tostring(p3)]

		if v6 then
			v5 = module.Set(v5, tostring(p3), module.RemoveFromDictionary(v6, p2))
		end
	end

	local function AddUserIdToMap(userId, p2)
		local v6 = v5[p2] or {}

		v5 = module.JoinDictionaries(v5, {
			[p2] = module.JoinDictionaries(v6, { [userId] = userId })
		})
	end

	if data.type ~= receivedUserPresence.name then
		return v5
	end

	local userId = tostring(data.userId)
	local previousUniverseId = tostring(data.previousUniverseId)

	if data.presence == module2.PresenceType.IN_GAME then
		local v6 = convertUniverseIdToString(data.universeId)
		local v7 = previousUniverseId
			and v6 ~= previousUniverseId
			and previousUniverseId
			and v5[tostring(previousUniverseId)]

		if v7 then
			local set = module.Set
			local v8 = v5
			v5 = set(v8, tostring(previousUniverseId), module.RemoveFromDictionary(v7, userId))
		end

		AddUserIdToMap(userId, v6)
	elseif previousUniverseId then
		local v6 = v5[tostring(previousUniverseId)]

		if v6 then
			local set = module.Set
			local v7 = v5
			v5 = set(v7, tostring(previousUniverseId), module.RemoveFromDictionary(v6, userId))
		end
	end

	return v5
end
