local parent = script.Parent.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate(script.Name, {
	Expired = "Expired",
	InviterNotInExperience = "InviterNotInExperience",
	Valid = "Valid"
})
