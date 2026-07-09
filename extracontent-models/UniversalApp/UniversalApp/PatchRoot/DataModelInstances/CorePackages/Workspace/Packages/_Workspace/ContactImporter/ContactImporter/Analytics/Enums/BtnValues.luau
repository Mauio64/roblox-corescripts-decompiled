local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	RequestFriendship = "requestFriendship",
	InviteContact = "inviteContact",
	CloseContactListButton = "closeContactListButton",
	CloseContactListCross = "closeContactListCross",
	ContactImporter = "contactImporter",
	AddFriends = "addFriendsUniversal",
	Close = "closeX",
	FindFriendsButton = "findFriends"
})
