local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	IsMyself = "isMyself",
	PreviousUsername = "previousUsername",
	Friend = "friend",
	Following = "following",
	MutualFriends = "mutualFriends",
	Frequents = "frequents"
})
