local Parent = script:FindFirstAncestor("Http").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		key = p1,
		status = p2
	}
end)
