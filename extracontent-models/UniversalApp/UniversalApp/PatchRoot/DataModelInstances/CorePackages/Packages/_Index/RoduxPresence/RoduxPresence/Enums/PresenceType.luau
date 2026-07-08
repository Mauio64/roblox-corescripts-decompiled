local Parent = script:FindFirstAncestor("RoduxPresence").Parent

return require(Parent.enumerate)(script.Name, {
	Offline = 0,
	Online = 1,
	InGame = 2,
	InStudio = 3,
	Invisible = 4
})
