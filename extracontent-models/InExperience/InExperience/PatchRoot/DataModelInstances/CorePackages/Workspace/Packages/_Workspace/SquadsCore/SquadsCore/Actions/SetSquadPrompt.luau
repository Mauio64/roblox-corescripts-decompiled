local Parent = script:FindFirstAncestor("SquadsCore").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		arguments = p1
	}
end)
