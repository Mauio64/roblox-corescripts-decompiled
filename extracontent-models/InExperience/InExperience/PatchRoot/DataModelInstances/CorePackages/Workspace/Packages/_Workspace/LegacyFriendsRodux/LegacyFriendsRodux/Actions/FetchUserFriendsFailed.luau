local Parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		userId = p1,
		response = p2
	}
end)
