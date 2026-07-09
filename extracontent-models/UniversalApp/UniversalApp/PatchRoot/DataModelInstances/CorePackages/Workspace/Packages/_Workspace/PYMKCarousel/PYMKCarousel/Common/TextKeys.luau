local v1 = game:DefineFastFlag("PYMKFriendsToastRename", false)

return {
	FriendRequestSentToast = "Feature.Friends.Action.FriendRequestSent",
	SomethingIsWrongToast = "Feature.Toast.NetworkingError.SomethingIsWrong",
	FriendAddedToast = "Feature.AddFriends.Action.FriendAdded",
	FriendRequestContext = "Feature.Friends.Label.FriendRequest",
	ConnectionRequestContext = "Feature.Friends.Label.ConnectionRequest",
	FindFriendsLabel = "Feature.Friends.Action.FindFriends",
	SeeAllLabel = "Feature.Home.ActionSeeAll",
	NewText = "Feature.Catalog.Label.New",
	FindFriendsTooltipTitle = "Feature.AddFriends.Title.AddFriendsTooltipTitle",
	FindFriendsTooltipBody = "Feature.AddFriends.Label.AddFriendsTooltip",
	FromContacts = "Feature.Friends.Description.FromContacts",
	ConnectionRequestSentToast = not v1 and "Feature.Friends.Action.ConnectionRequestSent" or "Feature.Friends.Action.FriendRequestSent",
	ConnectionAddedToast = not v1 and "Feature.Friends.Action.ConnectionAdded" or "Feature.Friends.Action.FriendAdded"
}
