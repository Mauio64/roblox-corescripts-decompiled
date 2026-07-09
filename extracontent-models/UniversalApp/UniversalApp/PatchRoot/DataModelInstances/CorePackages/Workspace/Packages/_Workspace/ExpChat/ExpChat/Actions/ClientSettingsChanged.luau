local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, p1) -- line: 10
	return {
		property = s1,
		value = p1
	}
end)
