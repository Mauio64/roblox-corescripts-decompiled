local User = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Models/User")
local WebPresenceMap = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Enum/WebPresenceMap")
local convertUniverseIdToString = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags").ConvertUniverseIdToString

game:DefineFastFlag("LuaAppFixActiveGameLoadingCheck", false)

return function(items, object)
	local placeIds = {}

	if game:GetFastFlag("LuaAppFixActiveGameLoadingCheck") and not object:getState().UniversePlaceInfos then
		return placeIds
	end

	for k, item in pairs(items) do
		local v5 = convertUniverseIdToString(item.universeId)

		if
			WebPresenceMap[item.userPresenceType] ~= User.PresenceType.IN_GAME
			or object:getState().UniversePlaceInfos[v5]
		then
			continue
		end

		table.insert(placeIds, item.placeId)
	end

	return placeIds
end
