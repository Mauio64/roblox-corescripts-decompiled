local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	"Up",
	"Down",
	"Left",
	"Right"
})
