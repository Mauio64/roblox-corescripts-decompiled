local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)("ButtonType", {
	"Alert",
	"PrimaryContextual",
	"PrimarySystem",
	"Secondary"
})
