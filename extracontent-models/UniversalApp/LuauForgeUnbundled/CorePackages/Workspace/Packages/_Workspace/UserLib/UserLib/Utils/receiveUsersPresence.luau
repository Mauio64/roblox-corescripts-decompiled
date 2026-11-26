local ReceivedUserPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/ReceivedUserPresence")
local updateFriendPresenceCounts = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/LegacyFriendsRodux").Actions.UpdateFriendPresenceCounts
local WebPresenceMap = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Enum/WebPresenceMap")

return function(items, object)
	for k, item in pairs(items) do
		local user = object:getState().Users[tostring(item.userId)]
		local universeId = user and user.universeId or nil

		local universeId2 = item.universeId

		local userId = tostring(item.userId)
		local v6 = WebPresenceMap[item.userPresenceType]
		local lastLocation = item.lastLocation
		local placeId = if item.placeId then tostring(item.placeId) or nil else nil
		local rootPlaceId = if item.rootPlaceId then tostring(item.rootPlaceId) or nil else nil
		local v7 = if item.gameId then tostring(item.gameId) or nil else nil
		object:dispatch(ReceivedUserPresence(
			userId,
			v6,
			lastLocation,
			placeId,
			rootPlaceId,
			v7,
			item.lastOnline and tostring(item.lastOnline) or nil,
			universeId2,
			universeId
		))
	end

	local v5 = {}

	for k, user in pairs(object:getState().Users) do
		if not (user.isFriend and user.presence) then
			continue
		end

		local v6 = v5[user.presence] or 0
		v5[user.presence] = v6 + 1
	end

	object:dispatch(updateFriendPresenceCounts(v5))
end
