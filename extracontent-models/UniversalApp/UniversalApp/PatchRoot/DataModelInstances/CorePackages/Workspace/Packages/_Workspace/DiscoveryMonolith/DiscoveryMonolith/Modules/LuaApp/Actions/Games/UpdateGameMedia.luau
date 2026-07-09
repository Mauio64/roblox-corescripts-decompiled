local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator("UpdateGameMedia", function(p1, p2) -- line: 5
	return {
		universeId = p1,
		entries = p2
	}
end)
