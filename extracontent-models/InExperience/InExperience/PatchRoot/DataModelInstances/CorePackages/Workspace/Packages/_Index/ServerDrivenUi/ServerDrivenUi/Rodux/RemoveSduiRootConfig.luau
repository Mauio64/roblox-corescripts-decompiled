local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 9
	return {
		feedStoreKey = s1
	}
end)
