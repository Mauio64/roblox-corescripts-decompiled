local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local enumerate = dependencies.enumerate
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return enumerate("BtnValues", {
	RequestFriendship = "requestFriendship",
	OpenPeopleList = "openPeopleList",
	AcceptFriendship = "acceptFriendship",
	FindFriends = getFFlagPYMKAddFriendsEntry() and "findFriends" or "",
	SeeAll = getFFlagPYMKAddFriendsEntry() and "seeAll" or ""
})
