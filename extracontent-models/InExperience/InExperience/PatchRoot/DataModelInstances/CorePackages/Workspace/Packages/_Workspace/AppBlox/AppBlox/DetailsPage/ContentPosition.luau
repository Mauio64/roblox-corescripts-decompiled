local Parent = script:FindFirstAncestor("AppBlox").Parent

return require(Parent.enumerate)("ContentPosition", {
	"Left",
	"Right"
})
