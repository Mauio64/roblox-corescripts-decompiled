local Parent = script:FindFirstAncestor("GameDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string?, s2: string?) -- line: 6
	return {
		headerDisplayName = s1,
		headerDisplayNameShort = s2
	}
end)
