local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 13
	return {
		position = p1,
		rotation = p2,
		scale = p3,
		itemId = p4
	}
end)
