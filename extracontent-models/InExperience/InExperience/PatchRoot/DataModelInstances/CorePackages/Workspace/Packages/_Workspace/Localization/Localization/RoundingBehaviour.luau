local Parent = script:FindFirstAncestor("Localization").Parent

return require(Parent.enumerate)("RoundingBehaviour", {
	"RoundToClosest",
	"Truncate"
})
