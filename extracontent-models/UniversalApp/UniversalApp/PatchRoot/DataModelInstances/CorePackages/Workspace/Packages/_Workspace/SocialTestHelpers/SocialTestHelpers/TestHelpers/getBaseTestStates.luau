local Parent = script:FindFirstAncestor("SocialTestHelpers").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local Presence = LuaSocialLibrariesDeps.RoduxPresence.config({}).Models.Presence
local User = LuaSocialLibrariesDeps.RoduxUsers.config({}).Models.User
local RecommendationContextType = require(Parent.FriendsRodux).config().Enums.RecommendationContextType
local t1 = {}

for i = 1, 40 do
	local v9 = User.mock({
		hasVerifiedBadge = false,
		id = tostring(i),
		displayName = "displayName" .. tostring(i),
		username = "username" .. tostring(i)
	})

	t1[v9.id] = v9
end

local v10 = llama.Dictionary.keys(t1)

t1["40"].displayName = "offlineFriend1"
t1["39"].displayName = "offlineFriend2"
t1["38"].displayName = "onlineFriend"
t1["37"].displayName = "inGameFriend"
t1["36"].displayName = "inStudioFriend"

local t2 = {
	t1["40"].id,
	t1["39"].id,
	t1["38"].id,
	t1["37"].id,
	t1["36"].id
}

llama.List.reduce(t1, function(p1, p2) -- line: 36
	-- upvalues: llama (copy), Presence (copy)
	return llama.Dictionary.join(p1, {
		[p2.id] = Presence.format(Presence.mock({
			userPresenceType = 0
		}))
	})
end)

local t3 = {
	recom1 = {
		id = "recom1",
		rank = 3,
		mutualFriendsList = {},
		contextType = RecommendationContextType.MutualFriends
	},
	recom2 = {
		id = "recom2",
		rank = 1,
		mutualFriendsList = {},
		contextType = RecommendationContextType.MutualFriends
	},
	recom3 = {
		id = "recom3",
		rank = 5,
		mutualFriendsList = {},
		contextType = RecommendationContextType.MutualFriends
	},
	recom4 = {
		id = "recom4",
		rank = 4,
		mutualFriendsList = {},
		contextType = RecommendationContextType.MutualFriends
	}
}
local v13 = llama.List.reduce(llama.Dictionary.keys(t3), function(p3, p4) -- line: 69
	-- upvalues: t3 (copy)
	p3[p4] = {
		id = tostring(p4),
		displayName = "displayName" .. tostring(p4),
		username = "username" .. tostring(p4),
		rank = t3[p4].rank,
		contextType = t3[p4].contextType
	}

	return p3
end, {})
local t4 = {
	["40"] = Presence.format(Presence.mock({
		userPresenceType = 0
	})),
	["39"] = Presence.format(Presence.mock({
		userPresenceType = 0
	})),
	["38"] = Presence.format(Presence.mock({
		userPresenceType = 1
	})),
	["37"] = Presence.format(Presence.mock({
		userPresenceType = 2
	})),
	["36"] = Presence.format(Presence.mock({
		userPresenceType = 3
	}))
}

return function(p5) -- line: 99
	-- upvalues: t2 (copy), t1 (copy), t4 (ref), v10 (copy), t3 (copy), llama (copy), v13 (copy)
	local v20 = p5 and p5.roduxKey or "FriendsLanding"

	return {
		noFriends = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {},
					countsByUserId = {}
				},
				Users = {},
				Presence = {},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		},
		smallNumbersOfFriends = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {
						test = t2
					},
					countsByUserId = {
						test = #t2
					},
					friendsRankByUserId = {
						test = {
							["36"] = 10,
							["37"] = 1,
							["38"] = 3,
							["39"] = 2,
							["40"] = 5
						}
					},
					recommendations = {}
				},
				Users = {
					byUserId = t1
				},
				Presence = {
					byUserId = t4
				},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		},
		manyFriends = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {
						test = v10
					},
					countsByUserId = {
						test = #v10
					},
					requests = {
						receivedCount = 12
					},
					recommendations = {}
				},
				Users = {
					byUserId = t1
				},
				Presence = {
					byUserId = t4
				},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done",
					["https://friends.roblox.com/v1/users/test/friends/inactive"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		},
		deletedFriends = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {},
					countsByUserId = {}
				},
				DeletedUsers = {
					byUserId = {}
				},
				Users = {},
				Presence = {},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(600, 300)
		},
		friendsAndRecommendations = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {
						test = t2
					},
					countsByUserId = {
						test = #t2
					},
					recommendations = {
						byUserId = {
							test = t3
						},
						bySource = {}
					},
					requests = {
						receivedCount = 28
					},
					friendshipStatus = {
						recom1 = Enum.FriendStatus.NotFriend,
						recom2 = Enum.FriendStatus.NotFriend,
						recom3 = Enum.FriendStatus.Unknown,
						recom4 = Enum.FriendStatus.FriendRequestSent
					}
				},
				Users = {
					byUserId = llama.Dictionary.join(t1, v13)
				},
				Presence = {
					byUserId = t4
				},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		},
		recommendationsOnly = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {},
					countsByUserId = {},
					recommendations = {
						byUserId = {
							test = t3
						},
						bySource = {
							AddFriendsPage = {
								recom1 = true,
								recom2 = true,
								recom3 = true,
								recom4 = true
							}
						}
					},
					requests = {
						receivedCount = 28
					},
					friendshipStatus = {
						recom1 = Enum.FriendStatus.NotFriend,
						recom2 = Enum.FriendStatus.NotFriend,
						recom3 = Enum.FriendStatus.Unknown,
						recom4 = Enum.FriendStatus.FriendRequestSent
					}
				},
				Users = {
					byUserId = llama.Dictionary.join(t1, v13)
				},
				Presence = {
					byUserId = t4
				},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		},
		manyFriendsAndRecommendations = {
			LocalUserId = "test",
			GlobalGuiInset = {
				top = 20,
				bottom = 20,
				left = 20,
				right = 20
			},
			[v20] = {
				Friends = {
					byUserId = {
						test = v10
					},
					countsByUserId = {
						test = #v10
					},
					recommendations = {
						byUserId = {
							test = t3
						},
						bySource = {}
					}
				},
				Users = {
					byUserId = llama.Dictionary.join(t1, v13)
				},
				Presence = {
					byUserId = t4
				},
				NetworkStatus = {
					["https://friends.roblox.com/v1/users/test/friends"] = "Done"
				}
			},
			ScreenSize = Vector2.new(1000, 100)
		}
	}
end
