local ParentParent = script.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	OpenPeopleList = "openPeopleList",
	RequestFriendship = "requestFriendship",
	RevokeFriendRequest = "revokeFriendRequest",
	FriendsLanding = "friendsLanding",
	AddFriendsButton = "AddFriendsButton"
})
