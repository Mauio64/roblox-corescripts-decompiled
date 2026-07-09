local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local User = require(UserLib.Models.User)
local WebPresenceMap = require(UserLib.Enum.WebPresenceMap)
local ConvertUniverseIdToString = require(UserLibParent.SharedFlags).ConvertUniverseIdToString

game:DefineFastFlag("LuaAppFixActiveGameLoadingCheck", false)

return function(p1, p2) -- line: 10
	-- upvalues: ConvertUniverseIdToString (copy), WebPresenceMap (copy), User (copy)
	local t1 = {}

	if game:GetFastFlag("LuaAppFixActiveGameLoadingCheck") and not p2:getState().UniversePlaceInfos then
		return t1
	end

	for _, v in pairs(p1) do
		local v11 = ConvertUniverseIdToString(v.universeId)

		if WebPresenceMap[v.userPresenceType] == User.PresenceType.IN_GAME and not p2:getState().UniversePlaceInfos[v11] then
			table.insert(t1, v.placeId)
		end
	end

	return t1
end
