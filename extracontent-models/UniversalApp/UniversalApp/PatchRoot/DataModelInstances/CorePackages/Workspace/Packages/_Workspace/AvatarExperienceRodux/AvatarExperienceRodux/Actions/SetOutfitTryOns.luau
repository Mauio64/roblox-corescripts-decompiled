local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		outfitTryOns = p1
	}
end)
