local ParentParent = script.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	CarouselLoadedWithUsers = "CarouselLoadedWithUsers",
	UserSeen = "UserSeen",
	UserPressed = "UserPressed",
	RequestFriendship = "RequestFriendship",
	RevokeFriendRequest = "RevokeFriendRequest",
	ViewAllFriends = "ViewAllFriends",
	ViewAddFriends = "ViewAddFriends",
	CarouselLoadingTime = "CarouselLoadingTime",
	ContactImporterOnAddFriends = "ContactImporterOnAddFriends",
	PaginatedFriendsCarouselLoadingTime = "PaginatedFriendsCarouselLoadingTime",
	FriendsEndpointLoadingTime = "FriendsEndpointLoadingTime",
	FriendsCarouselUILoadingTime = "FriendsCarouselUILoadingTime",
	OnlineFriendsRefetchOnPresenceUpdate = "OnlineFriendsRefetchOnPresenceUpdate",
	OnlineFriendsRefetchOnFriendshipUpdate = "OnlineFriendsRefetchOnFriendshipUpdate"
})
