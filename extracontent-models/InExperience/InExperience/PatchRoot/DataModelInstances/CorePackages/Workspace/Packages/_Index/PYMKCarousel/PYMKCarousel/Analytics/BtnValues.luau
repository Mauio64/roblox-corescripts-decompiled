local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local enumerate = dependencies.enumerate
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return enumerate(script.Name, {
	RequestFriendship = "requestFriendship",
	OpenPeopleList = "openPeopleList",
	AcceptFriendship = "acceptFriendship",
	FindFriends = getFFlagPYMKAddFriendsEntry() and "findFriends" or "",
	SeeAll = getFFlagPYMKAddFriendsEntry() and "seeAll" or ""
})
