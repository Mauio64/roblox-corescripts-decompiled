local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 14
	return {
		groupId = p1,
		sorts = p2,
		sortsTopicLayoutData = p3
	}
end)
