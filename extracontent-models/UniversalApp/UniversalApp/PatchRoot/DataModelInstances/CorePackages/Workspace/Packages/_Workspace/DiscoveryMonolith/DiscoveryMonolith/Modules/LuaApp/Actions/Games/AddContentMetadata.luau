local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		contentMetadata = p1
	}
end)
