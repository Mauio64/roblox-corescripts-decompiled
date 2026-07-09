local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local React = require(UserSearchParent.React)
local Dash = require(UserSearchParent.Dash)
local mockedUsersInfo = require(UserSearch.TestHelpers.mockedUsersInfo)
local UserSearchTile = require(UserSearch.Components.UserSearchTile)
local users = mockedUsersInfo.users
local t1 = {}
local t2 = {
	user = users.yourself
}
local user = t2.user

function t1.yourself(p1) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user (copy), t2 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user.id,
				name = user.name or "Name:" .. user.id,
				displayName = user.displayName or "DisplayName:" .. user.id,
				previousUsernames = user.previousUsernames or {}
			},
			profileInsight = user.profileInsight,
			searchParameters = t2.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t2.shouldUseCompactTiles
		}, p1))
	})
end

local t3 = {
	user = users.following
}
local user2 = t3.user

function t1.following(p2) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user2 (copy), t3 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user2.id,
				name = user2.name or "Name:" .. user2.id,
				displayName = user2.displayName or "DisplayName:" .. user2.id,
				previousUsernames = user2.previousUsernames or {}
			},
			profileInsight = user2.profileInsight,
			searchParameters = t3.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t3.shouldUseCompactTiles
		}, p2))
	})
end

local t4 = {
	user = users.friend
}
local user3 = t4.user

function t1.friend(p3) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user3 (copy), t4 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user3.id,
				name = user3.name or "Name:" .. user3.id,
				displayName = user3.displayName or "DisplayName:" .. user3.id,
				previousUsernames = user3.previousUsernames or {}
			},
			profileInsight = user3.profileInsight,
			searchParameters = t4.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t4.shouldUseCompactTiles
		}, p3))
	})
end

local t5 = {
	user = users.incomingFriendship
}
local user4 = t5.user

function t1.incomingFriendship(p4) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user4 (copy), t5 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user4.id,
				name = user4.name or "Name:" .. user4.id,
				displayName = user4.displayName or "DisplayName:" .. user4.id,
				previousUsernames = user4.previousUsernames or {}
			},
			profileInsight = user4.profileInsight,
			searchParameters = t5.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t5.shouldUseCompactTiles
		}, p4))
	})
end

local t6 = {
	user = users.outgoingFriendship
}
local user5 = t6.user

function t1.outgoingFriendship(p5) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user5 (copy), t6 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user5.id,
				name = user5.name or "Name:" .. user5.id,
				displayName = user5.displayName or "DisplayName:" .. user5.id,
				previousUsernames = user5.previousUsernames or {}
			},
			profileInsight = user5.profileInsight,
			searchParameters = t6.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t6.shouldUseCompactTiles
		}, p5))
	})
end

local t7 = {
	user = users.previousUserName,
	searchParameters = {
		searchKeyword = "searchKeyword"
	}
}
local user6 = t7.user

function t1.previousUserName(p6) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user6 (copy), t7 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user6.id,
				name = user6.name or "Name:" .. user6.id,
				displayName = user6.displayName or "DisplayName:" .. user6.id,
				previousUsernames = user6.previousUsernames or {}
			},
			profileInsight = user6.profileInsight,
			searchParameters = t7.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t7.shouldUseCompactTiles
		}, p6))
	})
end

local t8 = {
	user = users.random
}
local user7 = t8.user

function t1.random(p7) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user7 (copy), t8 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user7.id,
				name = user7.name or "Name:" .. user7.id,
				displayName = user7.displayName or "DisplayName:" .. user7.id,
				previousUsernames = user7.previousUsernames or {}
			},
			profileInsight = user7.profileInsight,
			searchParameters = t8.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t8.shouldUseCompactTiles
		}, p7))
	})
end

local t9 = {
	user = users.notFriend
}
local user8 = t9.user

function t1.notFriend(p8) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user8 (copy), t9 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user8.id,
				name = user8.name or "Name:" .. user8.id,
				displayName = user8.displayName or "DisplayName:" .. user8.id,
				previousUsernames = user8.previousUsernames or {}
			},
			profileInsight = user8.profileInsight,
			searchParameters = t9.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t9.shouldUseCompactTiles
		}, p8))
	})
end

local t10 = {
	user = users.mutualFriends
}
local user9 = t10.user

function t1.mutualFriends(p9) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user9 (copy), t10 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user9.id,
				name = user9.name or "Name:" .. user9.id,
				displayName = user9.displayName or "DisplayName:" .. user9.id,
				previousUsernames = user9.previousUsernames or {}
			},
			profileInsight = user9.profileInsight,
			searchParameters = t10.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t10.shouldUseCompactTiles
		}, p9))
	})
end

local t11 = {
	user = users.frequents
}
local user10 = t11.user

function t1.frequents(p10) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user10 (copy), t11 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user10.id,
				name = user10.name or "Name:" .. user10.id,
				displayName = user10.displayName or "DisplayName:" .. user10.id,
				previousUsernames = user10.previousUsernames or {}
			},
			profileInsight = user10.profileInsight,
			searchParameters = t11.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t11.shouldUseCompactTiles
		}, p10))
	})
end

local t12 = {
	shouldUseCompactTiles = true,
	user = users.incomingFriendship
}
local user11 = t12.user

function t1.compactTileIncomingFriendship(p11) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user11 (copy), t12 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user11.id,
				name = user11.name or "Name:" .. user11.id,
				displayName = user11.displayName or "DisplayName:" .. user11.id,
				previousUsernames = user11.previousUsernames or {}
			},
			profileInsight = user11.profileInsight,
			searchParameters = t12.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t12.shouldUseCompactTiles
		}, p11))
	})
end

local t13 = {
	shouldUseCompactTiles = true,
	user = users.outgoingFriendship
}
local user12 = t13.user

function t1.compactTileOutgoingFriendship(p12) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user12 (copy), t13 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user12.id,
				name = user12.name or "Name:" .. user12.id,
				displayName = user12.displayName or "DisplayName:" .. user12.id,
				previousUsernames = user12.previousUsernames or {}
			},
			profileInsight = user12.profileInsight,
			searchParameters = t13.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t13.shouldUseCompactTiles
		}, p12))
	})
end

local t14 = {
	shouldUseCompactTiles = true,
	user = users.mutualFriends
}
local user13 = t14.user

function t1.compactTileMutualFriends(p13) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user13 (copy), t14 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user13.id,
				name = user13.name or "Name:" .. user13.id,
				displayName = user13.displayName or "DisplayName:" .. user13.id,
				previousUsernames = user13.previousUsernames or {}
			},
			profileInsight = user13.profileInsight,
			searchParameters = t14.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t14.shouldUseCompactTiles
		}, p13))
	})
end

local t15 = {
	user = users.friendInGame
}
local user14 = t15.user

function t1.friendInGame(p14) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user14 (copy), t15 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user14.id,
				name = user14.name or "Name:" .. user14.id,
				displayName = user14.displayName or "DisplayName:" .. user14.id,
				previousUsernames = user14.previousUsernames or {}
			},
			profileInsight = user14.profileInsight,
			searchParameters = t15.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t15.shouldUseCompactTiles
		}, p14))
	})
end

local t16 = {
	user = users.friendInStudio
}
local user15 = t16.user

function t1.friendInStudio(p15) -- line: 12
	-- upvalues: React (copy), UserSearchTile (copy), Dash (copy), user15 (copy), t16 (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 350)
	}, {
		UserSearchTile = React.createElement(UserSearchTile, Dash.join({
			index = 1,
			size = UDim2.new(0, 200, 0, 250),
			user = {
				id = user15.id,
				name = user15.name or "Name:" .. user15.id,
				displayName = user15.displayName or "DisplayName:" .. user15.id,
				previousUsernames = user15.previousUsernames or {}
			},
			profileInsight = user15.profileInsight,
			searchParameters = t16.searchParameters or {
				searchKeyword = ""
			},
			luaAppNetworkingRequests = {
				requestFriendship = function() -- line: 31
				end,
				acceptFriendRequest = function() -- line: 32
				end
			},
			luaAppNavigation = {
				navigateToUserInfo = function() -- line: 35
				end
			},
			fireAnalyticsEvent = Dash.noop,
			shouldUseCompactTiles = t16.shouldUseCompactTiles
		}, p15))
	})
end

return t1
