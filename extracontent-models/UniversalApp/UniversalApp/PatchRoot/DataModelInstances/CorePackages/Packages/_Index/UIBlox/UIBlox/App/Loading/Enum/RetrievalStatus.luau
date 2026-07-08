local ParentParent = script.Parent.Parent.Parent.Parent.Parent

return require(ParentParent.enumerate)("RetrievalStatus", {
	"NotStarted",
	"Fetching",
	"Done",
	"Failed"
})
