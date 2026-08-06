local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 6
	return {
		state = b1
	}
end)
