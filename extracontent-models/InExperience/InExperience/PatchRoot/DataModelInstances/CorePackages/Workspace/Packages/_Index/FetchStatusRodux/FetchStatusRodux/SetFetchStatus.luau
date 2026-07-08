local Parent = script:FindFirstAncestor("FetchStatusRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 6
	return {
		fetchNamespace = p1,
		fetchKey = p2,
		fetchStatus = p3
	}
end)
