local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		capture = p1
	}
end)
