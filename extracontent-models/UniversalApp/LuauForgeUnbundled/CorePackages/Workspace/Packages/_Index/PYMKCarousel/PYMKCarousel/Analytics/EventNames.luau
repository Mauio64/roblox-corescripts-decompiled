local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
return dependencies.enumerate("EventNames", {
	CarouselLoadedWithUsers = "CarouselLoadedWithUsers",
	PYMKCarouselLoadingTime = "PYMKCarouselLoadingTime",
	UserSeen = "UserSeen",
	UserSeenCollection = "UserSeenCollection",
	UserPressed = "UserPressed",
	RequestFriendship = "RequestFriendship",
	AcceptFriendship = "AcceptFriendship",
	CarouselGenericTileClicked = dependencies.getFFlagPYMKAddFriendsEntry() and "CarouselGenericTileClicked" or nil,
	PYMKUserPresenceLoad = "PYMKUserPresenceLoad"
})
