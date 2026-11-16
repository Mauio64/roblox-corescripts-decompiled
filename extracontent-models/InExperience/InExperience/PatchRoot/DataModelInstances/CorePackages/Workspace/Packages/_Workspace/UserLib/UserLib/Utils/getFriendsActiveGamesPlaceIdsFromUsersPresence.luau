local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local User = require(UserLib.Models.User)
local WebPresenceMap = require(UserLib.Enum.WebPresenceMap)
local SharedFlags = require(parent.SharedFlags)
local ConvertUniverseIdToString = SharedFlags.ConvertUniverseIdToString

game:DefineFastFlag("LuaAppFixActiveGameLoadingCheck", false)

return function(items, object)
	local placeIds = {}

	if game:GetFastFlag("LuaAppFixActiveGameLoadingCheck") and not object:getState().UniversePlaceInfos then
		return placeIds
	end

	for _, item in pairs(items) do
		local convertUniverseIdToString = ConvertUniverseIdToString(item.universeId)

		if
			WebPresenceMap[item.userPresenceType] ~= User.PresenceType.IN_GAME
			or object:getState().UniversePlaceInfos[convertUniverseIdToString]
		then
			continue
		end

		table.insert(placeIds, item.placeId)
	end

	return placeIds
end
