local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 9
	return {
		autocompleteType = s1
	}
end)
