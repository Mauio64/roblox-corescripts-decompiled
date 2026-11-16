local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local ReceivedUserPresence = require(UserLib.Actions.ReceivedUserPresence)
local LegacyFriendsRodux = require(parent.LegacyFriendsRodux)
local UpdateFriendPresenceCounts = LegacyFriendsRodux.Actions.UpdateFriendPresenceCounts
local WebPresenceMap = require(UserLib.Enum.WebPresenceMap)

return function(items, object)
	for _, item in pairs(items) do
		local user = object:getState().Users[tostring(item.userId)]
		local universeId = user and user.universeId or nil

		local universeId2 = item.universeId

		local userId = tostring(item.userId)
		local webPresence = WebPresenceMap[item.userPresenceType]
		local lastLocation = item.lastLocation
		local placeId

		if item.placeId then
			placeId = tostring(item.placeId) or nil
		end

		local rootPlaceId

		if item.rootPlaceId then
			rootPlaceId = tostring(item.rootPlaceId) or nil
		end

		local v

		if item.gameId then
			v = tostring(item.gameId) or nil
		end

		object:dispatch(ReceivedUserPresence(
			userId,
			webPresence,
			lastLocation,
			placeId,
			rootPlaceId,
			v,
			item.lastOnline and tostring(item.lastOnline) or nil,
			universeId2,
			universeId
		))
	end

	local v = {}

	for _, user in pairs(object:getState().Users) do
		if not (user.isFriend and user.presence) then
			continue
		end

		local v2 = v[user.presence] or 0
		v[user.presence] = v2 + 1
	end

	object:dispatch(UpdateFriendPresenceCounts(v))
end
