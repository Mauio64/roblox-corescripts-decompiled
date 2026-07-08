local Parent = script:FindFirstAncestor("SquadsCore").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function() -- line: 6
	return {}
end)
