local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 14
	return {
		lookId = s1
	}
end)
