local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	Invalid = "Invalid"
})
