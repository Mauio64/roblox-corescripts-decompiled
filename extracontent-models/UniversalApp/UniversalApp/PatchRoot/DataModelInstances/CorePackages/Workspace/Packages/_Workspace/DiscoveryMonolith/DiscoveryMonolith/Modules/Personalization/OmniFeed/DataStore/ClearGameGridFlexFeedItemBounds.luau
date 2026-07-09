local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 5
	return {
		topicId = p1,
		sortIndex = p2,
		itemsPerRow = p3,
		entries = p4
	}
end)
