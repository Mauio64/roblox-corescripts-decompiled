local parent = script.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	None = "None",
	MutualFriends = "MutualFriends",
	Frequents = "Frequents",
	Contacts = "Contacts"
})
