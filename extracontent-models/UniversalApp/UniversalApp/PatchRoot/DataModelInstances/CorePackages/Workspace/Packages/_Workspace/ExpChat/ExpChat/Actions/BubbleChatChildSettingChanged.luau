local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, p1) -- line: 11
	return {
		childName = s1,
		property = s2,
		value = p1
	}
end)
