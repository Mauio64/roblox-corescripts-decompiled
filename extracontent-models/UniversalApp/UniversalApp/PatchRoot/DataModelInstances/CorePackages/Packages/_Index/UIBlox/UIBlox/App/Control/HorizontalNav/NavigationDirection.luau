local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return (require(ParentParent.enumerate)("NavigationDirection", {
	"IsLeft",
	"IsRight"
}))
