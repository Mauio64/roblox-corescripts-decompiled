local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)

local actionCreator = Rodux.makeActionCreator("GET_FRIENDS_SUCCEEDED_ACTION", function(users, p, userSort)
	return {
		responseBody = { data = p },
		namedIds = { users = users },
		queryArgs = { userSort = userSort }
	}
end)

local actionCreator2 = Rodux.makeActionCreator("GET_FRIENDS_COUNT_SUCCEEDED_ACTION", function(users, count)
	return {
		responseBody = { count = count },
		namedIds = { users = users }
	}
end)

local actionCreator3 = Rodux.makeActionCreator("GET_REQUEST_COUNT", function(count)
	return {
		responseBody = { count = count }
	}
end)

local actionCreator4 = Rodux.makeActionCreator("GET_NEW_FRIEND_REQUEST_COUNT", function(count)
	return {
		responseBody = { count = count }
	}
end)

local actionCreator5 = Rodux.makeActionCreator("GET_NEW_FRIEND_REQUEST_COUNT", function(status)
	return {
		responseBody = { status = status }
	}
end)

local actionCreator6 = Rodux.makeActionCreator("UNFRIEND_TARGET_USER_ID", function(p)
	return {
		namedIds = { users = p.targetUserId },
		additionalData = { currentUserId = p.currentUserId }
	}
end)

local actionCreator7 = Rodux.makeActionCreator("ACCEPT_REQUEST_FROM_USER_ID", function(p)
	return {
		ids = p.ids,
		additionalData = { currentUserId = p.currentUserId }
	}
end)

local actionCreator8 = Rodux.makeActionCreator("REQUEST_FRIENDSHIP_FROM_USER_ID", function(p)
	return {
		namedIds = { users = p.users },
		additionalData = { currentUserId = p.currentUserId }
	}
end)

local actionCreator9 = Rodux.makeActionCreator("REQUEST_FRIENDSHIP_FROM_CONTACT_ID", function(p)
	return {
		namedIds = { contacts = p.contacts },
		additionalData = { currentUserId = p.currentUserId }
	}
end)

local actionCreator10 = Rodux.makeActionCreator("DECLINE_REQUEST_FROM_USER_ID", function(p)
	return { ids = p.ids }
end)

local actionCreator11 = Rodux.makeActionCreator("GET_FRIEND_REQUESTS", function(p)
	return {
		responseBody = p and p.data or {
			previousPageCursor = nil,
			nextPageCursor = "637699238608300000-46587081730_1_986dd841c63787446d580a8055b3fa73",
			data = {
				{
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 123,
						sourceUniverseId = nil,
						contactName = "Name",
						senderNickname = "nickname"
					},
					mutualFriendsList = nil,
					description = "me dan robux :) gracias",
					created = "2021-01-19T02:01:21.997Z",
					isBanned = false,
					externalAppDisplayName = nil,
					id = 123,
					name = "TestUser_1",
					displayName = "TestUser_1",
					isUnseen = true
				},
				{
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 456,
						sourceUniverseId = 2092410051,
						contactName = nil,
						senderNickname = nil,
						originSourceType = "qrCode"
					},
					mutualFriendsList = { 123, 345 },
					description = "me dan robux :) gracias",
					created = "2021-01-19T02:01:21.997Z",
					isBanned = false,
					externalAppDisplayName = nil,
					id = 456,
					name = "TestUser_2",
					displayName = "TestUser_2",
					isUnseen = false
				}
			}
		},
		additionalData = {
			currentUserId = p and p.currentUserId or nil
		}
	}
end)

local actionCreator12 = Rodux.makeActionCreator("DECLINE_ALL_FRIEND_REQUESTS", function(p)
	return { ids = p.ids }
end)

local actionCreator13 = Rodux.makeActionCreator("GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID", function(value, p)
	return {
		responseBody = {
			data = p or {
				{
					friendRequest = nil,
					rank = 2,
					mutualFriendsList = { "1", "2" },
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 89,
					name = "red",
					displayName = "coolDisplayName"
				},
				{
					friendRequest = nil,
					rank = 4,
					mutualFriendsList = {},
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 19,
					name = "reputation",
					contextType = "MutualFriends",
					displayName = "anotherCoolName"
				},
				{
					rank = 3,
					mutualFriendsList = {},
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 25,
					name = "reputation",
					contextType = "MutualFriends",
					displayName = "anotherCoolName",
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 123,
						sourceUniverseId = nil,
						contactName = nil
					}
				},
				{
					rank = 1,
					mutualFriendsList = {},
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 0,
					contactId = "contactId",
					thumbnailEntities = {
						avatarImageUrl = "avatarImageUrl",
						headshotImageUrl = "headshotImageUrl"
					},
					name = "reputation",
					contextType = "Contacts",
					displayName = "Contact Name"
				}
			}
		},
		namedIds = {
			users = value or 678
		}
	}
end)

local actionCreator14 = Rodux.makeActionCreator("GET_FRIENDSHIP_STATUS", function(_)
	return {
		responseBody = {
			data = {
				{ id = 123, status = "NotFriends" },
				{ id = 355, status = "Friends" }
			}
		}
	}
end)

local actionCreator15 = Rodux.makeActionCreator("GET_FRIENDSHIP_STATUSES", function(_)
	return {
		responseBody = {
			data = {
				{ id = 123, status = "NotFriends" },
				{ id = 355, status = "Friends" }
			}
		}
	}
end)

local actionCreator16 = Rodux.makeActionCreator("GET_EXTENDED_FRIENDSHIP_STATUS", function(p, responseBody)
	return {
		responseBody = responseBody,
		ids = { p }
	}
end)

local actionCreator17 = Rodux.makeActionCreator("BLOCK_USER_BY_ID", function(p, responseBody)
	return {
		responseBody = responseBody,
		namedIds = { users = p.userId },
		additionalData = { currentUserId = p.currentUserId }
	}
end)

return {
	mockGetFriendsFromUserId = "GET_FRIENDS_SUCCEEDED_ACTION",
	mockGetFriendsFromUserIdAction = actionCreator,
	mockGetFriendsCountFromUserId = "GET_FRIENDS_COUNT_SUCCEEDED_ACTION",
	mockGetFriendsCountFromUserIdAction = actionCreator2,
	mockRequestCount = "GET_REQUEST_COUNT",
	mockRequestCountAction = actionCreator3,
	mockGetNewRequestsCount = "GET_NEW_FRIEND_REQUEST_COUNT",
	mockNewFriendRequestsCountAction = actionCreator4,
	mockClearNewFriendRequests = "CLEAR_NEW_FRIEND_REQUEST_COUNT",
	mockClearNewFriendRequestsAction = actionCreator5,
	mockUnfriendTargetUserId = "UNFRIEND_TARGET_USER_ID",
	mockUnfriendTargetUserIdAction = actionCreator6,
	mockAcceptFriendRequestFromUserId = "ACCEPT_REQUEST_FROM_USER_ID",
	mockAcceptFriendRequestFromUserIdAction = actionCreator7,
	mockRequestFriendshipFromUserId = "REQUEST_FRIENDSHIP_FROM_USER_ID",
	mockRequestFriendshipFromUserIdAction = actionCreator8,
	mockRequestFriendshipFromContactId = "REQUEST_FRIENDSHIP_FROM_CONTACT_ID",
	mockRequestFriendshipFromContactIdAction = actionCreator9,
	mockDeclineFriendRequestFromUserId = "DECLINE_REQUEST_FROM_USER_ID",
	mockDeclineFriendRequestFromUserIdAction = actionCreator10,
	mockGetFriendRequests = "GET_FRIEND_REQUESTS",
	mockGetFriendRequestsAction = actionCreator11,
	mockDeclineAllFriendRequests = "DECLINE_ALL_FRIEND_REQUESTS",
	mockDeclineAllFriendRequestsAction = actionCreator12,
	mockGetFriendRecommendationsFromUserId = "GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID",
	mockGetFriendRecommendationsFromUserIdAction = actionCreator13,
	mockGetFriendshipStatus = "GET_FRIENDSHIP_STATUS",
	mockGetFriendshipStatusAction = actionCreator14,
	mockGetFriendshipStatuses = "GET_FRIENDSHIP_STATUSES",
	mockGetFriendshipStatusesAction = actionCreator15,
	mockGetUserExtendedFriendshipStatus = "GET_EXTENDED_FRIENDSHIP_STATUS",
	mockGetUserExtendedFriendshipStatusAction = actionCreator16,
	mockGetFollowingExists = "GET_FOLLOWING_EXISTS",
	mockGetFollowingExistsAction = Rodux.makeActionCreator("GET_FOLLOWING_EXISTS", function(_, _)
		return {
			responseBody = {
				followings = {
					{ userId = 123, isFollowing = true, isFollowed = true },
					{ userId = 355, isFollowing = false, isFollowed = true }
				}
			}
		}
	end),
	mockBlockUserById = "BLOCK_USER_BY_ID",
	mockBlockUserByIdAction = actionCreator17,
	friendsNetworkingMock = {
		GetFriendshipStatus = {
			Succeeded = { name = "GET_FRIENDSHIP_STATUS" }
		},
		GetFriendshipStatuses = {
			Succeeded = { name = "GET_FRIENDSHIP_STATUSES" }
		},
		GetFriendsFromUserId = {
			Succeeded = { name = "GET_FRIENDS_SUCCEEDED_ACTION" }
		},
		GetFriendsCountFromUserId = {
			Succeeded = { name = "GET_FRIENDS_COUNT_SUCCEEDED_ACTION" }
		},
		UnfriendTargetUserId = {
			Succeeded = { name = "UNFRIEND_TARGET_USER_ID" }
		},
		GetFriendRequestsCount = {
			Succeeded = { name = "GET_REQUEST_COUNT" }
		},
		GetNewFriendRequestsCount = {
			Succeeded = { name = "GET_NEW_FRIEND_REQUEST_COUNT" }
		},
		ClearNewFriendRequests = {
			Succeeded = { name = "CLEAR_NEW_FRIEND_REQUEST_COUNT" }
		},
		AcceptFriendRequestFromUserId = {
			Succeeded = { name = "ACCEPT_REQUEST_FROM_USER_ID" }
		},
		DeclineFriendRequestFromUserId = {
			Succeeded = { name = "DECLINE_REQUEST_FROM_USER_ID" }
		},
		GetFriendRequests = {
			Succeeded = { name = "GET_FRIEND_REQUESTS" }
		},
		DeclineAllFriendRequests = {
			Succeeded = { name = "DECLINE_ALL_FRIEND_REQUESTS" }
		},
		GetFriendRecommendationsFromUserId = {
			Succeeded = { name = "GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID" }
		},
		RequestFriendshipFromUserId = {
			Succeeded = { name = "REQUEST_FRIENDSHIP_FROM_USER_ID" }
		},
		RequestFriendshipFromContactId = {
			Succeeded = { name = "REQUEST_FRIENDSHIP_FROM_CONTACT_ID" }
		},
		GetExtendedFriendshipStatus = {
			Succeeded = { name = "GET_EXTENDED_FRIENDSHIP_STATUS" }
		},
		GetFollowingExists = {
			Succeeded = { name = "GET_FOLLOWING_EXISTS" }
		}
	},
	networkingBlockingMock = {
		BlockUserById = {
			Succeeded = { name = "BLOCK_USER_BY_ID" }
		}
	},
	userBlockingNetworkingMock = {
		BlockUserById = {
			Succeeded = { name = "BLOCK_USER_BY_ID" }
		}
	}
}
