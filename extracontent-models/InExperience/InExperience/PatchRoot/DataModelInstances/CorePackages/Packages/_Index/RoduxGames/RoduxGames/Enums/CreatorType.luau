local Parent = script:FindFirstAncestor("RoduxGames").Parent

return require(Parent.enumerate)(script.Name, {
	User = "User",
	Group = "Group"
})
