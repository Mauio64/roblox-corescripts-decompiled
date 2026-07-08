local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(Parent.Rodux)
local v3 = Rodux.makeActionCreator("GET_FRIENDS_SUCCEEDED_ACTION", function(p1, p2, p3) -- line: 8
	return {
		responseBody = {
			data = p2
		},
		namedIds = {
			users = p1
		},
		queryArgs = {
			userSort = p3
		}
	}
end)
local v4 = Rodux.makeActionCreator("GET_FRIENDS_COUNT_SUCCEEDED_ACTION", function(p4, p5) -- line: 20
	return {
		responseBody = {
			count = p5
		},
		namedIds = {
			users = p4
		}
	}
end)
local v5 = Rodux.makeActionCreator("GET_REQUEST_COUNT", function(p6) -- line: 29
	return {
		responseBody = {
			count = p6
		}
	}
end)
local v6 = Rodux.makeActionCreator("GET_NEW_FRIEND_REQUEST_COUNT", function(p7) -- line: 38
	return {
		responseBody = {
			count = p7
		}
	}
end)
local v7 = Rodux.makeActionCreator("GET_NEW_FRIEND_REQUEST_COUNT", function(p8) -- line: 47
	return {
		responseBody = {
			status = p8
		}
	}
end)
local v8 = Rodux.makeActionCreator("UNFRIEND_TARGET_USER_ID", function(p9) -- line: 56
	return {
		namedIds = {
			users = p9.targetUserId
		},
		additionalData = {
			currentUserId = p9.currentUserId
		}
	}
end)
local v9 = Rodux.makeActionCreator("ACCEPT_REQUEST_FROM_USER_ID", function(p10) -- line: 66
	return {
		ids = p10.ids,
		additionalData = {
			currentUserId = p10.currentUserId
		}
	}
end)
local v10 = Rodux.makeActionCreator("REQUEST_FRIENDSHIP_FROM_USER_ID", function(p11) -- line: 75
	return {
		namedIds = {
			users = p11.users
		},
		additionalData = {
			currentUserId = p11.currentUserId
		}
	}
end)
local v11 = Rodux.makeActionCreator("REQUEST_FRIENDSHIP_FROM_CONTACT_ID", function(p12) -- line: 85
	return {
		namedIds = {
			contacts = p12.contacts
		},
		additionalData = {
			currentUserId = p12.currentUserId
		}
	}
end)
local v12 = Rodux.makeActionCreator("DECLINE_REQUEST_FROM_USER_ID", function(p13) -- line: 96
	return {
		ids = p13.ids
	}
end)
local v13 = Rodux.makeActionCreator("GET_FRIEND_REQUESTS", function(p14) -- line: 104
	return {
		responseBody = p14 and p14.data or {
			previousPageCursor = nil,
			nextPageCursor = "637699238608300000-46587081730_1_986dd841c63787446d580a8055b3fa73",
			data = {
				{
					mutualFriendsList = nil,
					description = "me dan robux :) gracias",
					created = "2021-01-19T02:01:21.997Z",
					isBanned = false,
					externalAppDisplayName = nil,
					id = 123,
					name = "TestUser_1",
					displayName = "TestUser_1",
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 123,
						sourceUniverseId = nil,
						contactName = "Name",
						senderNickname = "nickname"
					}
				},
				{
					description = "me dan robux :) gracias",
					created = "2021-01-19T02:01:21.997Z",
					isBanned = false,
					externalAppDisplayName = nil,
					id = 456,
					name = "TestUser_2",
					displayName = "TestUser_2",
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 456,
						sourceUniverseId = 2092410051,
						contactName = nil,
						senderNickname = nil,
						originSourceType = "qrCode"
					},
					mutualFriendsList = {
						123,
						345
					}
				}
			}
		},
		additionalData = {
			currentUserId = p14 and p14.currentUserId or nil
		}
	}
end)
local v14 = Rodux.makeActionCreator("DECLINE_ALL_FRIEND_REQUESTS", function(p15) -- line: 152
	return {
		ids = p15.ids
	}
end)
local v15 = Rodux.makeActionCreator("GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID", function(p16, p17) -- line: 161
	return {
		responseBody = {
			data = p17 or {
				{
					friendRequest = nil,
					rank = 2,
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 89,
					name = "red",
					displayName = "coolDisplayName",
					mutualFriendsList = {
						"1",
						"2"
					}
				},
				{
					friendRequest = nil,
					rank = 4,
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 19,
					name = "reputation",
					contextType = "MutualFriends",
					displayName = "anotherCoolName",
					mutualFriendsList = {}
				},
				{
					rank = 3,
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 25,
					name = "reputation",
					contextType = "MutualFriends",
					displayName = "anotherCoolName",
					mutualFriendsList = {},
					friendRequest = {
						sentAt = "2021-10-22T23:20:18.163Z",
						senderId = 123,
						sourceUniverseId = nil,
						contactName = nil
					}
				},
				{
					rank = 1,
					description = "string",
					created = "2022-02-25T21:22:29.217Z",
					isBanned = true,
					externalAppDisplayName = "string",
					id = 0,
					contactId = "contactId",
					name = "reputation",
					contextType = "Contacts",
					displayName = "Contact Name",
					mutualFriendsList = {},
					thumbnailEntities = {
						avatarImageUrl = "avatarImageUrl",
						headshotImageUrl = "headshotImageUrl"
					}
				}
			}
		},
		namedIds = {
			users = p16 or 678
		}
	}
end)
local v16 = Rodux.makeActionCreator("GET_FRIENDSHIP_STATUS", function(_) -- line: 236
	return {
		responseBody = {
			data = {
				{
					id = 123,
					status = "NotFriends"
				},
				{
					id = 355,
					status = "Friends"
				}
			}
		}
	}
end)
local v17 = Rodux.makeActionCreator("GET_FRIENDSHIP_STATUSES", function(_) -- line: 254
	return {
		responseBody = {
			data = {
				{
					id = 123,
					status = "NotFriends"
				},
				{
					id = 355,
					status = "Friends"
				}
			}
		}
	}
end)
local v18 = Rodux.makeActionCreator("GET_EXTENDED_FRIENDSHIP_STATUS", function(p20, p21) -- line: 274
	return {
		responseBody = p21,
		ids = { p20 }
	}
end)
local v19 = Rodux.makeActionCreator("BLOCK_USER_BY_ID", function(p22, p23) -- line: 283
	return {
		responseBody = p23,
		namedIds = {
			users = p22.userId
		},
		additionalData = {
			currentUserId = p22.currentUserId
		}
	}
end)
local v20 = Rodux.makeActionCreator("GET_FOLLOWING_EXISTS", function(_, _) -- line: 292
	return {
		responseBody = {
			followings = {
				{
					userId = 123,
					isFollowing = true,
					isFollowed = true
				},
				{
					userId = 355,
					isFollowing = false,
					isFollowed = true
				}
			}
		}
	}
end)
local t1 = {
	GetFriendshipStatus = {
		Succeeded = {
			name = "GET_FRIENDSHIP_STATUS"
		}
	},
	GetFriendshipStatuses = {
		Succeeded = {
			name = "GET_FRIENDSHIP_STATUSES"
		}
	},
	GetFriendsFromUserId = {
		Succeeded = {
			name = "GET_FRIENDS_SUCCEEDED_ACTION"
		}
	},
	GetFriendsCountFromUserId = {
		Succeeded = {
			name = "GET_FRIENDS_COUNT_SUCCEEDED_ACTION"
		}
	},
	UnfriendTargetUserId = {
		Succeeded = {
			name = "UNFRIEND_TARGET_USER_ID"
		}
	},
	GetFriendRequestsCount = {
		Succeeded = {
			name = "GET_REQUEST_COUNT"
		}
	},
	GetNewFriendRequestsCount = {
		Succeeded = {
			name = "GET_NEW_FRIEND_REQUEST_COUNT"
		}
	},
	ClearNewFriendRequests = {
		Succeeded = {
			name = "CLEAR_NEW_FRIEND_REQUEST_COUNT"
		}
	},
	AcceptFriendRequestFromUserId = {
		Succeeded = {
			name = "ACCEPT_REQUEST_FROM_USER_ID"
		}
	},
	DeclineFriendRequestFromUserId = {
		Succeeded = {
			name = "DECLINE_REQUEST_FROM_USER_ID"
		}
	},
	GetFriendRequests = {
		Succeeded = {
			name = "GET_FRIEND_REQUESTS"
		}
	},
	DeclineAllFriendRequests = {
		Succeeded = {
			name = "DECLINE_ALL_FRIEND_REQUESTS"
		}
	},
	GetFriendRecommendationsFromUserId = {
		Succeeded = {
			name = "GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID"
		}
	},
	RequestFriendshipFromUserId = {
		Succeeded = {
			name = "REQUEST_FRIENDSHIP_FROM_USER_ID"
		}
	},
	RequestFriendshipFromContactId = {
		Succeeded = {
			name = "REQUEST_FRIENDSHIP_FROM_CONTACT_ID"
		}
	},
	GetExtendedFriendshipStatus = {
		Succeeded = {
			name = "GET_EXTENDED_FRIENDSHIP_STATUS"
		}
	},
	GetFollowingExists = {
		Succeeded = {
			name = "GET_FOLLOWING_EXISTS"
		}
	}
}
local t2 = {
	BlockUserById = {
		Succeeded = {
			name = "BLOCK_USER_BY_ID"
		}
	}
}
local t3 = {
	BlockUserById = {
		Succeeded = {
			name = "BLOCK_USER_BY_ID"
		}
	}
}

return {
	mockGetFriendsFromUserId = "GET_FRIENDS_SUCCEEDED_ACTION",
	mockGetFriendsFromUserIdAction = v3,
	mockGetFriendsCountFromUserId = "GET_FRIENDS_COUNT_SUCCEEDED_ACTION",
	mockGetFriendsCountFromUserIdAction = v4,
	mockRequestCount = "GET_REQUEST_COUNT",
	mockRequestCountAction = v5,
	mockGetNewRequestsCount = "GET_NEW_FRIEND_REQUEST_COUNT",
	mockNewFriendRequestsCountAction = v6,
	mockClearNewFriendRequests = "CLEAR_NEW_FRIEND_REQUEST_COUNT",
	mockClearNewFriendRequestsAction = v7,
	mockUnfriendTargetUserId = "UNFRIEND_TARGET_USER_ID",
	mockUnfriendTargetUserIdAction = v8,
	mockAcceptFriendRequestFromUserId = "ACCEPT_REQUEST_FROM_USER_ID",
	mockAcceptFriendRequestFromUserIdAction = v9,
	mockRequestFriendshipFromUserId = "REQUEST_FRIENDSHIP_FROM_USER_ID",
	mockRequestFriendshipFromUserIdAction = v10,
	mockRequestFriendshipFromContactId = "REQUEST_FRIENDSHIP_FROM_CONTACT_ID",
	mockRequestFriendshipFromContactIdAction = v11,
	mockDeclineFriendRequestFromUserId = "DECLINE_REQUEST_FROM_USER_ID",
	mockDeclineFriendRequestFromUserIdAction = v12,
	mockGetFriendRequests = "GET_FRIEND_REQUESTS",
	mockGetFriendRequestsAction = v13,
	mockDeclineAllFriendRequests = "DECLINE_ALL_FRIEND_REQUESTS",
	mockDeclineAllFriendRequestsAction = v14,
	mockGetFriendRecommendationsFromUserId = "GET_FRIEND_RECOMMENDATIONS_FROM_USER_ID",
	mockGetFriendRecommendationsFromUserIdAction = v15,
	mockGetFriendshipStatus = "GET_FRIENDSHIP_STATUS",
	mockGetFriendshipStatusAction = v16,
	mockGetFriendshipStatuses = "GET_FRIENDSHIP_STATUSES",
	mockGetFriendshipStatusesAction = v17,
	mockGetUserExtendedFriendshipStatus = "GET_EXTENDED_FRIENDSHIP_STATUS",
	mockGetUserExtendedFriendshipStatusAction = v18,
	mockGetFollowingExists = "GET_FOLLOWING_EXISTS",
	mockGetFollowingExistsAction = v20,
	mockBlockUserById = "BLOCK_USER_BY_ID",
	mockBlockUserByIdAction = v19,
	friendsNetworkingMock = t1,
	networkingBlockingMock = t2,
	userBlockingNetworkingMock = t3
}
