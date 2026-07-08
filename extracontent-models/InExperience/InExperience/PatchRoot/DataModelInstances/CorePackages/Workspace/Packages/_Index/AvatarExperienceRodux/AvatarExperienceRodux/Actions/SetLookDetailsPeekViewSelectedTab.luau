local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator("SetLookDetailsPeekViewSelectedTab", function(p1) -- line: 10
	return {
		selectedTab = p1
	}
end)
