local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

require(Parent.MomentsCommon)

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 13
	return {
		trimEdit = p1
	}
end)
