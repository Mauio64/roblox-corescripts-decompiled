local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean?) -- line: 9
	return {
		retainTryOnColor = b1
	}
end)
