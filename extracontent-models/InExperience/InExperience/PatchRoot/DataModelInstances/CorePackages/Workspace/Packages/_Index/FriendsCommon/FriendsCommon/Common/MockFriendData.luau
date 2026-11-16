local MockFriendData = {}
MockFriendData.localUserId = "1"
MockFriendData.offlineFriend = {
	__typename = "Friend",
	id = "2",
	hasVerifiedBadge = false,
	targetUserId = "1"
}

MockFriendData.onlineFriend = {
	__typename = "Friend",
	id = "5",
	targetUserId = "1",
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
	},
	sortScore = 20.4
}
MockFriendData.inGameFriend = {
	__typename = "Friend",
	id = "3",
	targetUserId = "1",
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
	},
	sortScore = 30.3
}

MockFriendData.inStudioFriend = {
	__typename = "Friend",
	id = "4",
	targetUserId = "1",
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
	},
	sortScore = 10.5
}

MockFriendData.inGameFriendNoUniverseId = {
	__typename = "Friend",
	id = "6",
	targetUserId = "1",
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
	},
	sortScore = 20.3
}

MockFriendData.inGameFriendLowerSortScore = {
	__typename = "Friend",
	id = "7",
	targetUserId = "1",
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
	},
	sortScore = 30.1
}

function MockFriendData.convertGraphQlOnlineFriendsToPresenceApiFormat(items)
	local result = {}
	local sortScoresById = {}

	for _, item in items do
		local id = item.id
		local presence = item.presence

		table.insert(result, {
			userId = id,
			userPresenceType = presence.userPresenceType,
			lastLocation = presence.lastLocation,
			lastOnline = presence.lastOnline,
			gameId = presence.gameId,
			placeId = presence.placeId,
			rootPlaceId = presence.rootPlaceId,
			universeId = presence.universeId
		})

		sortScoresById[id] = item.sortScore
	end

	return result, sortScoresById
end

function MockFriendData.convertGraphQlOnlineFriendsToExectedSignalFormat(items)
	local result = {}

	for _, item in items do
		local id = item.id
		local presence = item.presence

		table.insert(result, {
			id = id,
			sortScore = item.sortScore,
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

	return result
end

return MockFriendData
