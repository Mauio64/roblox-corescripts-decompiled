local Parent = script:FindFirstAncestor("AppTopBanner").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		isDisabled = p1
	}
end)
