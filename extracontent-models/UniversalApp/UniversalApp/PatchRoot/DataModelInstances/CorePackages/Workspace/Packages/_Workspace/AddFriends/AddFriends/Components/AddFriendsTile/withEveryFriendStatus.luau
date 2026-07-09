local Parent = script:FindFirstAncestor("AddFriends").Parent
local Rodux = require(Parent.Rodux)
local llama = require(Parent.llama)
local FriendshipOriginSourceType = require(Parent.FriendsNetworking).Enums.FriendshipOriginSourceType
local AddFriendsState = require(Parent.AddFriendsState)
local RoduxFriends = AddFriendsState.RoduxFriends
local RoduxUsers = AddFriendsState.RoduxUsers
local PresenceType = AddFriendsState.RoduxPresence.Enums.PresenceType
local RecommendationContextType = RoduxFriends.Enums.RecommendationContextType
local User = RoduxUsers.Models.User
local t1 = {
	["36"] = Enum.FriendStatus.NotFriend,
	["37"] = Enum.FriendStatus.FriendRequestSent,
	["38"] = Enum.FriendStatus.FriendRequestReceived,
	["39"] = Enum.FriendStatus.Friend,
	["40"] = Enum.FriendStatus.FriendRequestReceived,
	["41"] = Enum.FriendStatus.FriendRequestReceived
}
local v12 = Rodux.Store.new(function() -- line: 30
	-- upvalues: t1 (copy), FriendshipOriginSourceType (copy)
	return {
		LocalUserId = "0",
		FriendStatuses = t1,
		ScreenSize = Vector2.new(500, 500),
		AddFriends = {
			RequestsFromOriginSourceType = {
				["41"] = FriendshipOriginSourceType.QrCode.rawValue()
			},
			IsUserFollowing = {
				["36"] = {
					isFollowing = false,
					isFollowed = false
				},
				["37"] = {
					isFollowing = false,
					isFollowed = true
				},
				["38"] = {
					isFollowing = true,
					isFollowed = false
				},
				["39"] = {
					isFollowing = true,
					isFollowed = true
				},
				["40"] = {
					isFollowing = false,
					isFollowed = false
				},
				["41"] = {
					isFollowing = false,
					isFollowed = false
				}
			},
			Friends = {
				requests = {
					sourceUniverseIds = {
						["36"] = 0,
						["37"] = 0,
						["38"] = 0,
						["39"] = 0,
						["40"] = 1,
						["41"] = 0
					},
					mutualFriends = {
						["36"] = {
							1,
							2,
							4,
							4
						},
						["37"] = {},
						["38"] = {},
						["39"] = {},
						["40"] = {},
						["41"] = {}
					}
				}
			},
			Games = {
				byGameId = {
					["1"] = {
						name = "someGameName"
					}
				}
			},
			NetworkStatus = {}
		}
	}
end, {}, { Rodux.thunkMiddleware })
local t2 = {
	tileProps = {
		sentFromExperienceName = "TestSentFrom",
		amIFollowingUser = true,
		isUserFollowingMe = true
	},
	userProps = {
		lastLocation = "TestLastLocation",
		mutualFriends = {
			{},
			{},
			{}
		},
		userPresenceType = PresenceType.InGame
	}
}

return {
	localUserId = "0",
	friendWithContextInfo = {
		FriendWithFullContextInfo = llama.Dictionary.joinDeep(t2, {
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithFullContextInfo"
			}
		}),
		FriendWithMutualFriends = {
			tileProps = {},
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithMutualFriends",
				mutualFriends = t2.userProps.mutualFriends
			}
		},
		Contact = {
			tileProps = {},
			userProps = {
				entityDisplayName = "entityDisplayName",
				thumbnailEntities = {
					avatarImageUrl = "avatarImageUrl"
				},
				contextType = RecommendationContextType.Contacts
			}
		},
		FriendWithSentFrom = {
			tileProps = {
				sentFromExperienceName = t2.tileProps.sentFromExperienceName
			},
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithSentContext",
				id = "40"
			}
		},
		FriendYouAreFollowing = {
			tileProps = {
				amIFollowingUser = t2.tileProps.amIFollowingUser
			},
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithYouAreFollowing",
				id = "38"
			}
		},
		FriendFollowingMe = {
			tileProps = {
				isUserFollowingMe = t2.tileProps.isUserFollowingMe
			},
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithFollowingMe",
				id = "37",
				followers = {}
			}
		},
		FriendViaQRCode = {
			tileProps = {
				originSourceType = FriendshipOriginSourceType.QrCode.rawValue()
			},
			userProps = {
				username = "FriendRequestReceived",
				displayName = "WithQRCode",
				id = "41"
			}
		},
		FriendNoFriend = {
			tileProps = {},
			userProps = {
				username = "NotFriend",
				displayName = "Friend to add"
			}
		},
		FriendNoFriendWithNickname = {
			tileProps = {},
			userProps = {
				username = "NotFriend",
				displayName = "Friend to add",
				senderNickname = "SenderNickname"
			}
		},
		FriendPending = {
			tileProps = {},
			userProps = {
				username = "FriendRequestSent",
				displayName = "Friend pending"
			}
		}
	},
	fullContextInfo = t2,
	userForStatus = function(p1, p2) -- line: 97
		-- upvalues: llama (copy), t1 (copy), User (copy)
		local v16 = llama.Dictionary.flip(t1)[p1]

		return llama.Dictionary.join(User.mock({
			id = v16
		}), p2)
	end,
	baseStore = v12
}
