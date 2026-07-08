local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 10
	return {
		description = s1
	}
end)
