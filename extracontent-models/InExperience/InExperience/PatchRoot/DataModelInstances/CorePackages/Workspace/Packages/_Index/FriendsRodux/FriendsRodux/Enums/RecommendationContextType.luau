local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	None = "None",
	MutualFriends = "MutualFriends",
	Frequents = "Frequents",
	Contacts = "Contacts"
})
