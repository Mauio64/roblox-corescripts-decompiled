local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local React = require(FriendsMenuParent.React)

require(FriendsMenu.friendsMenuModalType)

return (React.createContext({
	hasFriends = false,
	isFetchingFriends = false,
	isFriendsListFetchFailed = false,
	searchFriendsString = "",
	friends = {},
	searchFriends = function() -- line: 15
		return {}
	end,
	fetchMoreFriends = function() -- line: 18
		return {}
	end,
	friendsNames = {
		loading = true
	}
}))
