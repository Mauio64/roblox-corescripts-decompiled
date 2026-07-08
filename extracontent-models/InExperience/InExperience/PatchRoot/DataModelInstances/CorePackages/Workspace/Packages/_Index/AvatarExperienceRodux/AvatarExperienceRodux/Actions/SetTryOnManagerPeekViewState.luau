local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator("SetTryOnManagerPeekViewState", function(p1) -- line: 11
	return {
		viewState = p1
	}
end)
