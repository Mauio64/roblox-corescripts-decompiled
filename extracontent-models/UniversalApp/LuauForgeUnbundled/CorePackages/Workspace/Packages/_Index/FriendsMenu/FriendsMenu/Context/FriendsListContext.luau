local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/friendsMenuModalType")

return React.createContext({
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
})
