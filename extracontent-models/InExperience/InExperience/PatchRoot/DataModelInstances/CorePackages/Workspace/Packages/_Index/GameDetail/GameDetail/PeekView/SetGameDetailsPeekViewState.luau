local Parent = script:FindFirstAncestor("GameDetail").Parent

return require(Parent.Rodux).makeActionCreator("SetGameDetailsPeekViewState", function(p1) -- line: 5
	return {
		viewState = p1
	}
end)
