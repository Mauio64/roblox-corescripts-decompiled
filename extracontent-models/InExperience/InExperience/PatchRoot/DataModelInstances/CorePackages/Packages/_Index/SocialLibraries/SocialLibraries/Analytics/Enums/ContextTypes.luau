local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	Contact = "contact",
	MutualFriends = "mutualFriends",
	Frequents = "frequents",
	None = "none"
})
