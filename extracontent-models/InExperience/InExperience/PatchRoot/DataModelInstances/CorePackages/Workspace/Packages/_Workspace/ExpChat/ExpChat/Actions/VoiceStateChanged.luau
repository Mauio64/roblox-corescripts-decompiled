local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, s1: string) -- line: 13
	return {
		userId = tostring(p1),
		newState = s1
	}
end)
