local Parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		count = p1
	}
end)
