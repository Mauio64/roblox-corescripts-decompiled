local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local enumerate = dependencies.enumerate
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return enumerate(script.Name, {
	CarouselLoadedWithUsers = "CarouselLoadedWithUsers",
	PYMKCarouselLoadingTime = "PYMKCarouselLoadingTime",
	UserSeen = "UserSeen",
	UserSeenCollection = "UserSeenCollection",
	UserPressed = "UserPressed",
	RequestFriendship = "RequestFriendship",
	AcceptFriendship = "AcceptFriendship",
	CarouselGenericTileClicked = getFFlagPYMKAddFriendsEntry() and "CarouselGenericTileClicked" or nil,
	PYMKUserPresenceLoad = "PYMKUserPresenceLoad"
})
