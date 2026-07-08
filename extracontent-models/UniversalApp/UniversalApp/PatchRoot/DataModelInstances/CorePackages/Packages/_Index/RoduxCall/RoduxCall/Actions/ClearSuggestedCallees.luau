local Parent = script:FindFirstAncestor("RoduxCall").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function() -- line: 5
	return {
		payload = {}
	}
end)
