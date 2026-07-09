local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string?) -- line: 12
	return {
		itemId = s1,
		outfitId = s2
	}
end)
