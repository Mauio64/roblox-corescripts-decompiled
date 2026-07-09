local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local UserProfiles = require(AppChatParent.UserProfiles)
local ApolloClient = require(AppChatParent.ApolloClient)
local ApolloClientTestUtils = require(AppChatParent.GraphQLServer).ApolloClientTestUtils
local queries = require(AppChatParent.ApolloLocalState).queries
local MockUserData = require(AppChat.Users.MockUserData)
local mockApolloClient = ApolloClientTestUtils.mockApolloClient

return function(p1) -- line: 16
	-- upvalues: mockApolloClient (copy), MockUserData (copy), UserProfiles (copy), queries (copy), React (copy), ApolloClient (copy)
	local v11 = mockApolloClient({})
	local v12 = MockUserData.createMockApolloProfiles()

	UserProfiles.TestUtils.writeProfileDataToCache(v11, v12)

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
		sortScore = 30,
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
		id = "422502",
		targetUserId = "1",
		sortScore = 30.3,
		presence = {
			__typename = "UserPresence",
			id = "422502",
			userPresenceType = "InGame",
			lastLocation = "location",
			lastOnline = "time",
			gameId = "game-id",
			placeId = "123",
			rootPlaceId = "456",
			universeId = "789"
		}
	}

	v11:writeQuery({
		loading = false,
		variables = {
			userId = "1",
			sort = 1,
			nextCursor = ""
		},
		query = queries.allFriendsByUserId,
		data = {
			allFriendsByUserId = {
				__typename = "FriendsListPage",
				prevCursor = "",
				curCursor = "",
				nextCursor = "",
				targetUserId = "1",
				friends = { t1 }
			}
		}
	})
	v11:writeQuery({
		loading = false,
		variables = {
			userId = "1",
			sort = 1
		},
		query = queries.onlineFriendsByUserId,
		data = {
			onlineFriendsByUserId = {
				t2,
				t3
			}
		}
	})

	return React.createElement(ApolloClient.ApolloProvider, {
		client = v11
	}, {
		AnalyticsElement = p1
	})
end
