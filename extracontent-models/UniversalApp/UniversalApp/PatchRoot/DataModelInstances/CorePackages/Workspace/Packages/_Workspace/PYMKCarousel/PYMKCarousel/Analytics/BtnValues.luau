local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local enumerate = dependencies.enumerate
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return enumerate(script.Name, {
	RequestFriendship = "requestFriendship",
	OpenPeopleList = "openPeopleList",
	AcceptFriendship = "acceptFriendship",
	FindFriends = not getFFlagPYMKAddFriendsEntry() and "" or "findFriends",
	SeeAll = not getFFlagPYMKAddFriendsEntry() and "" or "seeAll"
})
