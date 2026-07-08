local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local ReceivedUserPresence = require(UserLib.Actions.ReceivedUserPresence)
local UpdateFriendPresenceCounts = require(UserLibParent.LegacyFriendsRodux).Actions.UpdateFriendPresenceCounts
local WebPresenceMap = require(UserLib.Enum.WebPresenceMap)

return function(p1, p2) -- line: 8
	-- upvalues: ReceivedUserPresence (copy), WebPresenceMap (copy), UpdateFriendPresenceCounts (copy)
	for _, v in pairs(p1) do
		local v10 = p2:getState().Users[tostring(v.userId)]
		local v11 = v10 and v10.universeId or nil
		local universeId = v.universeId

		p2:dispatch(ReceivedUserPresence(tostring(v.userId), WebPresenceMap[v.userPresenceType], v.lastLocation, v.placeId and tostring(v.placeId) or nil, v.rootPlaceId and tostring(v.rootPlaceId) or nil, v.gameId and tostring(v.gameId) or nil, v.lastOnline and tostring(v.lastOnline) or nil, universeId, v11))
	end

	local t1 = {}

	for _, v in pairs(p2:getState().Users) do
		if v.isFriend and v.presence then
			local v16 = t1[v.presence] or 0

			t1[v.presence] = v16 + 1
		end
	end

	p2:dispatch(UpdateFriendPresenceCounts(t1))
end
