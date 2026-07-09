local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 6
	return {
		searchUuid = s1
	}
end)
