local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 12
	return {
		searchUuid = p1,
		searchInGames = p2
	}
end)
