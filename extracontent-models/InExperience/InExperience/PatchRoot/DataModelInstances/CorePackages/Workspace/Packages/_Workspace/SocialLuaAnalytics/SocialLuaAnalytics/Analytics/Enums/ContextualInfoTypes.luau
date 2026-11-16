local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	IsMyself = "isMyself",
	PreviousUsername = "previousUsername",
	Friend = "friend",
	Following = "following",
	MutualFriends = "mutualFriends",
	Frequents = "frequents"
})
