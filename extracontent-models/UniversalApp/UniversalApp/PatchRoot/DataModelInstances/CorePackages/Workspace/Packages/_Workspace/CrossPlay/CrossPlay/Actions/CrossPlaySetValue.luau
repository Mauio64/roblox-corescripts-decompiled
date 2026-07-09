local Parent = script:FindFirstAncestor("CrossPlay").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		crossPlayValue = p1
	}
end)
