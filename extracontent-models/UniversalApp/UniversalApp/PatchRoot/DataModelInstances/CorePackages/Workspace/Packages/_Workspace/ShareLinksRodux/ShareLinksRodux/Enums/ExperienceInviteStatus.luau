local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	Expired = "Expired",
	InviterNotInExperience = "InviterNotInExperience",
	Valid = "Valid"
})
