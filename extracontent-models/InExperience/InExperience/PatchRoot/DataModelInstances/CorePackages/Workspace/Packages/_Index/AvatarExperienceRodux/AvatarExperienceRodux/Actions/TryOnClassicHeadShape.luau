local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string?) -- line: 10
	return {
		headShape = s1
	}
end)
