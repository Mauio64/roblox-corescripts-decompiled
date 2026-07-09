local Parent = script:FindFirstAncestor("ExperienceSongsRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		experienceSongs = p1
	}
end)
