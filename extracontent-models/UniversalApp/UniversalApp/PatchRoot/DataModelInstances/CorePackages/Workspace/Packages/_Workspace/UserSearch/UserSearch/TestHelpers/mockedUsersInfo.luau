local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local ProfileInsightsMocks = require(UserSearch.TestHelpers.ProfileInsightsMocks)
local PresenceType = require(UserSearch.Rodux.RoduxPresence).Enums.PresenceType
local ContextualInfoTypes = require(UserSearchParent.SocialCommon).Enums.ContextualInfoTypes
local t1 = {
	yourself = "1111",
	following = "2222",
	friend = "3333",
	incomingFriendship = "4444",
	compactTileIncomingFriendship = "4444",
	outgoingFriendship = "5555",
	compactTileOutgoingFriendship = "5555",
	previousUserName = "6666",
	random = "7777",
	notFriend = "8888",
	mutualFriends = "9999",
	compactTileMutualFriends = "9999",
	frequents = "101010",
	friendInGame = "111111",
	friendInStudio = "121212"
}
local t2 = {
	incomingFriendship = nil,
	compactTileIncomingFriendship = nil,
	outgoingFriendship = nil,
	random = nil,
	notFriend = nil,
	yourself = ContextualInfoTypes.IsMyself,
	following = ContextualInfoTypes.Following,
	friend = ContextualInfoTypes.Friend,
	previousUserName = ContextualInfoTypes.PreviousUsername,
	mutualFriends = ContextualInfoTypes.MutualFriends,
	compactTileMutualFriends = ContextualInfoTypes.MutualFriends,
	frequents = ContextualInfoTypes.Frequents,
	friendInGame = ContextualInfoTypes.ExperienceLastLocation,
	friendInStudio = ContextualInfoTypes.Friend
}
local t3 = {
	[t1.friend] = Enum.FriendStatus.Friend,
	[t1.incomingFriendship] = Enum.FriendStatus.FriendRequestReceived,
	[t1.compactTileIncomingFriendship] = Enum.FriendStatus.FriendRequestReceived,
	[t1.outgoingFriendship] = Enum.FriendStatus.FriendRequestSent,
	[t1.compactTileOutgoingFriendship] = Enum.FriendStatus.FriendRequestSent,
	[t1.notFriend] = Enum.FriendStatus.NotFriend,
	[t1.mutualFriends] = Enum.FriendStatus.NotFriend,
	[t1.compactTileMutualFriends] = Enum.FriendStatus.NotFriend,
	[t1.frequents] = Enum.FriendStatus.NotFriend,
	[t1.friendInGame] = Enum.FriendStatus.Friend,
	[t1.friendInStudio] = Enum.FriendStatus.Friend
}
local t4 = {
	LocalUserId = t1.yourself
}
local t5 = {
	NetworkStatus = {},
	Friends = {
		friendshipStatus = t3,
		followings = {
			followingStatuses = {
				[t1.following] = {
					isFollowing = true,
					isFollowed = false
				}
			}
		}
	}
}
local t6 = {}
local t7 = {}
local yourself = t1.yourself
local yourself2 = t1.yourself
local Offline = PresenceType.Offline

t7[yourself] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline,
	userId = tonumber(yourself2),
	universeId = if Offline ~= PresenceType.InGame then nil else 123
}

local following = t1.following
local following2 = t1.following
local Offline2 = PresenceType.Offline

t7[following] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline2,
	userId = tonumber(following2),
	universeId = if Offline2 ~= PresenceType.InGame then nil else 123
}

local friend = t1.friend
local friend2 = t1.friend
local Online = PresenceType.Online

t7[friend] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Online,
	userId = tonumber(friend2),
	universeId = if Online ~= PresenceType.InGame then nil else 123
}

local incomingFriendship = t1.incomingFriendship
local incomingFriendship2 = t1.incomingFriendship
local Offline3 = PresenceType.Offline

t7[incomingFriendship] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline3,
	userId = tonumber(incomingFriendship2),
	universeId = if Offline3 ~= PresenceType.InGame then nil else 123
}

local compactTileIncomingFriendship = t1.compactTileIncomingFriendship
local compactTileIncomingFriendship2 = t1.compactTileIncomingFriendship
local Offline4 = PresenceType.Offline

t7[compactTileIncomingFriendship] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline4,
	userId = tonumber(compactTileIncomingFriendship2),
	universeId = if Offline4 ~= PresenceType.InGame then nil else 123
}

local outgoingFriendship = t1.outgoingFriendship
local outgoingFriendship2 = t1.outgoingFriendship
local Offline5 = PresenceType.Offline

t7[outgoingFriendship] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline5,
	userId = tonumber(outgoingFriendship2),
	universeId = if Offline5 ~= PresenceType.InGame then nil else 123
}

local previousUserName = t1.previousUserName
local previousUserName2 = t1.previousUserName
local Offline6 = PresenceType.Offline

t7[previousUserName] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline6,
	userId = tonumber(previousUserName2),
	universeId = if Offline6 ~= PresenceType.InGame then nil else 123
}

local random = t1.random
local random2 = t1.random
local Offline7 = PresenceType.Offline

t7[random] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline7,
	userId = tonumber(random2),
	universeId = if Offline7 ~= PresenceType.InGame then nil else 123
}

local notFriend = t1.notFriend
local notFriend2 = t1.notFriend
local Offline8 = PresenceType.Offline

t7[notFriend] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline8,
	userId = tonumber(notFriend2),
	universeId = if Offline8 ~= PresenceType.InGame then nil else 123
}

local mutualFriends = t1.mutualFriends
local mutualFriends2 = t1.mutualFriends
local Offline9 = PresenceType.Offline

t7[mutualFriends] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline9,
	userId = tonumber(mutualFriends2),
	universeId = if Offline9 ~= PresenceType.InGame then nil else 123
}

local compactTileMutualFriends = t1.compactTileMutualFriends
local compactTileMutualFriends2 = t1.compactTileMutualFriends
local Offline10 = PresenceType.Offline

t7[compactTileMutualFriends] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline10,
	userId = tonumber(compactTileMutualFriends2),
	universeId = if Offline10 ~= PresenceType.InGame then nil else 123
}

local frequents = t1.frequents
local frequents2 = t1.frequents
local Offline11 = PresenceType.Offline

t7[frequents] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = Offline11,
	userId = tonumber(frequents2),
	universeId = if Offline11 ~= PresenceType.InGame then nil else 123
}

local friendInGame = t1.friendInGame
local friendInGame2 = t1.friendInGame
local InGame = PresenceType.InGame

t7[friendInGame] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = InGame,
	userId = tonumber(friendInGame2),
	universeId = if InGame ~= PresenceType.InGame then nil else 123
}

local friendInStudio = t1.friendInStudio
local friendInStudio2 = t1.friendInStudio
local InStudio = PresenceType.InStudio

t7[friendInStudio] = {
	lastLocation = "MockLastLocation",
	lastOnline = "2022-05-08T22:44:25.08Z",
	gameInstanceId = nil,
	placeId = nil,
	rootPlaceId = nil,
	userPresenceType = InStudio,
	userId = tonumber(friendInStudio2),
	universeId = if InStudio ~= PresenceType.InGame then nil else 123
}
t6.byUserId = t7
t5.Presence = t6
t4.UserSearch = t5

local t8 = {
	yourself = {
		id = t1.yourself
	},
	following = {
		id = t1.following
	},
	friend = {
		id = t1.friend
	},
	incomingFriendship = {
		id = t1.incomingFriendship
	},
	compactTileIncomingFriendship = {
		id = t1.compactTileIncomingFriendship
	},
	outgoingFriendship = {
		id = t1.outgoingFriendship
	},
	compactTileOutgoingFriendship = {
		id = t1.compactTileOutgoingFriendship
	},
	previousUserName = {
		id = t1.previousUserName,
		previousUsernames = {
			"random1",
			"random1",
			"searchKeyword"
		}
	},
	random = {
		id = t1.random
	},
	notFriend = {
		id = t1.notFriend
	},
	mutualFriends = {
		id = t1.mutualFriends,
		profileInsight = ProfileInsightsMocks.mockProfileInsightWithMutualFriends(t1.mutualFriends)
	},
	frequents = {
		id = t1.frequents,
		profileInsight = ProfileInsightsMocks.mockProfileInsight(t1.frequents)
	},
	friendInGame = {
		id = t1.friendInGame
	},
	friendInStudio = {
		id = t1.friendInStudio
	}
}

return {
	ids = t1,
	state = t4,
	users = t8,
	contextualInfoType = t2
}
