local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	Contact = "contact",
	MutualFriends = "mutualFriends",
	Frequents = "frequents",
	None = "none",
	Contacts = "Contacts",
	Classmates = "Classmates"
})
