local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent
local React = require(parent.React)

require(FriendsMenu.friendsMenuModalType)

return (React.createContext({
	friends = {},
	hasFriends = false,
	isFetchingFriends = false,
	isFriendsListFetchFailed = false,
	searchFriends = function()
		return {}
	end,
	fetchMoreFriends = function()
		return {}
	end,
	searchFriendsString = "",
	friendsNames = { loading = true }
}))
