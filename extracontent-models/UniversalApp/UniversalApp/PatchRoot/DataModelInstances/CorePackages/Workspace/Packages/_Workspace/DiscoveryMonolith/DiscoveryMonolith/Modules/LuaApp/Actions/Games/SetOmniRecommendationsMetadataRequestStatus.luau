local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 12
	return {
		contentIds = p1
	}
end)
