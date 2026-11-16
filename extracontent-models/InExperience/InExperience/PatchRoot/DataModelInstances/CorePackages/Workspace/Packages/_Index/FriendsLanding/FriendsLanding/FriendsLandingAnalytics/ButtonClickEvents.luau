local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

return dependencies.enumerate(script.Name, {
	AddFriendsNoFriends = "addFriendsNoFriends",
	AddFriendsNoFriendsEmptyView = "addFriendsNoFriendsEmptyView",
	AddFriends = "addFriends",
	PlayerTile = "playerTile",
	FriendFilterPill = "friendFilterPill",
	LoadMoreUsers = "loadMoreUsers",
	FriendFilterApply = "friendFilterApply",
	FriendTileUnfriendButton = "friendTileUnfriendButton",
	IgnoreAllButton = "ignoreAll",
	ConnectWithFriends = "connectWithFriends",
	PlayerProfile = "playerProfile",
	PeopleSearchBar = "peopleSearchBar",
	ProfileQRCode = "shareProfileQRCode",
	RequestFriendship = "requestFriendship",
	DeclineFriendship = "declineFriendship",
	AcceptFriendship = "acceptFriendship"
})
