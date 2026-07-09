local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 6
	return {
		isEnabled = b1
	}
end)
