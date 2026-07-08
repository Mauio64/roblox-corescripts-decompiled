local ParentParent = script.Parent.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	"Bottom",
	"Top",
	"Right",
	"Left"
})
