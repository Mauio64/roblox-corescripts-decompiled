local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 6
	return {
		headShapeName = s1
	}
end)
