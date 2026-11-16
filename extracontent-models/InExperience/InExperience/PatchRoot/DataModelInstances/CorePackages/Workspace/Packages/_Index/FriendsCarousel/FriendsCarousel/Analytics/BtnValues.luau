local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	OpenPeopleList = "openPeopleList",
	RequestFriendship = "requestFriendship",
	RevokeFriendRequest = "revokeFriendRequest",
	FriendsLanding = "friendsLanding",
	AddFriendsButton = "AddFriendsButton"
})
