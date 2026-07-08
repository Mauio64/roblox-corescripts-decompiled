local Parent = script:FindFirstAncestor("FormFactor").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		formFactor = p1
	}
end)
