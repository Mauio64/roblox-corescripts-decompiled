local Parent = script:FindFirstAncestor("GameDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, _) -- line: 13
	return {
		universeId = p1,
		errorType = p2
	}
end)
