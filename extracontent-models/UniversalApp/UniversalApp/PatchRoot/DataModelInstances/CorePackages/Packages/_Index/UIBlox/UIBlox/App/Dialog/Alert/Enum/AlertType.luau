local ParentParent = script.Parent.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)("AlertType", {
	"Informative",
	"Interactive",
	"Loading"
})
