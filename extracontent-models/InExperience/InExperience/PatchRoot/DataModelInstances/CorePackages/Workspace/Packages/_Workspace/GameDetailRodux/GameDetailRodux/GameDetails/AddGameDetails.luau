local Parent = script:FindFirstAncestor("GameDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		gameDetails = p1
	}
end)
