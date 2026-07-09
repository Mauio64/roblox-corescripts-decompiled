local Parent = script:FindFirstAncestor("UserLib").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		userId = p1,
		isFriend = p2
	}
end)
