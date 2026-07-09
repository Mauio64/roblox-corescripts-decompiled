local t1 = {
	__typename = "Friend",
	id = "2",
	hasVerifiedBadge = false,
	targetUserId = "1"
}
local t2 = {
	__typename = "Friend",
	id = "3",
	targetUserId = "1",
	sortScore = 30.3,
	presence = {
		__typename = "UserPresence",
		id = "3",
		userPresenceType = "InGame",
		lastLocation = "location",
		lastOnline = "time",
		gameId = "game-id",
		placeId = "123",
		rootPlaceId = "456",
		universeId = "789"
	}
}
local t3 = {
	__typename = "Friend",
	id = "4",
	targetUserId = "1",
	sortScore = 10.5,
	presence = {
		__typename = "UserPresence",
		id = "4",
		userPresenceType = "InStudio",
		lastLocation = "Studio",
		lastOnline = "time2",
		gameId = "",
		placeId = "",
		rootPlaceId = "",
		universeId = ""
	}
}
local t4 = {
	__typename = "Friend",
	id = "5",
	targetUserId = "1",
	sortScore = 20.4,
	presence = {
		__typename = "UserPresence",
		id = "5",
		userPresenceType = "Online",
		lastLocation = "Website",
		lastOnline = "time3",
		gameId = "",
		placeId = "",
		rootPlaceId = "",
		universeId = ""
	}
}
local t5 = {
	__typename = "Friend",
	id = "6",
	targetUserId = "1",
	sortScore = 20.3,
	presence = {
		__typename = "UserPresence",
		id = "6",
		userPresenceType = "InGame",
		lastLocation = "",
		lastOnline = "time4",
		gameId = "",
		placeId = "",
		rootPlaceId = "",
		universeId = ""
	}
}
local t6 = {
	__typename = "Friend",
	id = "7",
	targetUserId = "1",
	sortScore = 30.1,
	presence = {
		__typename = "UserPresence",
		id = "3",
		userPresenceType = "InGame",
		lastLocation = "location",
		lastOnline = "time",
		gameId = "game-id",
		placeId = "123",
		rootPlaceId = "456",
		universeId = "789"
	}
}

return {
	localUserId = "1",
	offlineFriend = t1,
	onlineFriend = t4,
	inGameFriend = t2,
	inStudioFriend = t3,
	inGameFriendNoUniverseId = t5,
	inGameFriendLowerSortScore = t6,
	convertGraphQlOnlineFriendsToPresenceApiFormat = function(p1) -- line: 100
		local t7 = {}
		local t8 = {}

		for _, v11 in p1 do
			local id = v11.id
			local presence = v11.presence

			table.insert(t7, {
				userId = id,
				userPresenceType = presence.userPresenceType,
				lastLocation = presence.lastLocation,
				lastOnline = presence.lastOnline,
				gameId = presence.gameId,
				placeId = presence.placeId,
				rootPlaceId = presence.rootPlaceId,
				universeId = presence.universeId
			})
			t8[id] = v11.sortScore
		end

		return t7, t8
	end,
	convertGraphQlOnlineFriendsToExectedSignalFormat = function(p2) -- line: 123
		local t9 = {}

		for _, v17 in p2 do
			local id = v17.id
			local presence = v17.presence

			table.insert(t9, {
				id = id,
				sortScore = v17.sortScore,
				presence = {
					id = id,
					userPresenceType = presence.userPresenceType,
					lastLocation = presence.lastLocation,
					lastOnline = presence.lastOnline,
					gameId = presence.gameId,
					placeId = presence.placeId,
					rootPlaceId = presence.rootPlaceId,
					universeId = presence.universeId
				}
			})
		end

		return t9
	end
}
