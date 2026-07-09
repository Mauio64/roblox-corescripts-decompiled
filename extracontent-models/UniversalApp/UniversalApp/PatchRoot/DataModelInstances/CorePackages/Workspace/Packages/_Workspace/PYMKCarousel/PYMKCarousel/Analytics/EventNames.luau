local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local enumerate = dependencies.enumerate
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return enumerate(script.Name, {
	CarouselLoadedWithUsers = "CarouselLoadedWithUsers",
	PYMKCarouselLoadingTime = "PYMKCarouselLoadingTime",
	UserSeen = "UserSeen",
	UserPressed = "UserPressed",
	RequestFriendship = "RequestFriendship",
	AcceptFriendship = "AcceptFriendship",
	PYMKUserPresenceLoad = "PYMKUserPresenceLoad",
	CarouselGenericTileClicked = if not getFFlagPYMKAddFriendsEntry() then nil else "CarouselGenericTileClicked"
})
