local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	assert(type(p1) == "string", string.format("SetFetchHomePageDataStatusAll action expects status to be an string, was %s", (type(p1))))

	return {
		status = p1
	}
end)
