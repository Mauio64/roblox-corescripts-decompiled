local Parent = script:FindFirstAncestor("AppTabBarRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		isVisible = p1
	}
end)
