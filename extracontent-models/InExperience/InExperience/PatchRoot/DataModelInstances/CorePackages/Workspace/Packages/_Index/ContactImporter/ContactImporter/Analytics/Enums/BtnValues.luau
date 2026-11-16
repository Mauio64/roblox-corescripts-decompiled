local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	RequestFriendship = "requestFriendship",
	InviteContact = "inviteContact",
	CloseContactListButton = "closeContactListButton",
	CloseContactListCross = "closeContactListCross",
	ContactImporter = "contactImporter",
	AddFriends = "addFriendsUniversal",
	Close = "closeX",
	FindFriendsButton = "findFriends"
})
