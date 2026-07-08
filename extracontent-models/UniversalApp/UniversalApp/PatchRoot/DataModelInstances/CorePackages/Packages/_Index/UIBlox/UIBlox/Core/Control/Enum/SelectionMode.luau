local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	"Single",
	"Multiple",
	"None"
})
