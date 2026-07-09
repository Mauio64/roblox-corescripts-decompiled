local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 5
	return {
		nextPageId = s1
	}
end)
