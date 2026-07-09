local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator("SetItemTryOnPeekViewState", function(p1) -- line: 14
	return {
		viewState = p1
	}
end)
