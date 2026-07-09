local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(n1: number) -- line: 9
	return {
		selectedIndex = n1
	}
end)
