local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		id = p1,
		isLeaving = p2
	}
end)
