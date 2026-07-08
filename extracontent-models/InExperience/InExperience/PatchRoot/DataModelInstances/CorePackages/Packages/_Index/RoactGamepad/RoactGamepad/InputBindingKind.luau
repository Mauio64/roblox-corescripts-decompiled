local ParentParent = script.Parent.Parent

return require(ParentParent.enumerate)("InputBindingKind", {
	"Begin",
	"End",
	"Step",
	"MoveStep"
})
