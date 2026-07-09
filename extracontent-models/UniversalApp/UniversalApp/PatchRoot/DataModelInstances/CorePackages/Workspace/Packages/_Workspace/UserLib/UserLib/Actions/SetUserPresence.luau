local Parent = script:FindFirstAncestor("UserLib").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 6
	return {
		userId = tostring(p1),
		presence = p2,
		lastLocation = p3
	}
end)
