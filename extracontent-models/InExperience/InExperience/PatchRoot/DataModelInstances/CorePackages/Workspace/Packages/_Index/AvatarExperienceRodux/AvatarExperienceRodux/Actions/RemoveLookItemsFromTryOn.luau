local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}, t2: {[any]: any}?) -- line: 16
	return {
		lookId = s1,
		assetIds = t1,
		bundleIds = t2
	}
end)
