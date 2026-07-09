local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		pageType = p1,
		refreshTime = p2
	}
end)
