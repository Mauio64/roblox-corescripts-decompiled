local Parent = script:FindFirstAncestor("UserLib").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		user = p1
	}
end)
