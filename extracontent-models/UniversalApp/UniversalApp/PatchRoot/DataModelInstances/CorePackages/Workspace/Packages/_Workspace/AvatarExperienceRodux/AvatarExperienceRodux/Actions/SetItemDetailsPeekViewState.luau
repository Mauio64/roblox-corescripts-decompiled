local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator("SetItemDetailsPeekViewState", function(p1) -- line: 5
	return {
		viewState = p1
	}
end)
