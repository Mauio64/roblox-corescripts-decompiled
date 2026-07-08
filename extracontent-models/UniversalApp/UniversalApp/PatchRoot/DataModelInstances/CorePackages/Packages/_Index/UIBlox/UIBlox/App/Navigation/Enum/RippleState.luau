local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)(script.Name, {
	"State1",
	"State2",
	"State3",
	"State4"
})
