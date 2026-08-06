local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 13
	return {
		bundleId = p1,
		bundleInfo = p2
	}
end)
