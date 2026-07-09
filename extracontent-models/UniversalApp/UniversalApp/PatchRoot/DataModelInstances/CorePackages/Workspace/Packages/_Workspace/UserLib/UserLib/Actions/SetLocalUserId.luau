local Parent = script:FindFirstAncestor("UserLib").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 6
	return {
		userId = s1
	}
end)
