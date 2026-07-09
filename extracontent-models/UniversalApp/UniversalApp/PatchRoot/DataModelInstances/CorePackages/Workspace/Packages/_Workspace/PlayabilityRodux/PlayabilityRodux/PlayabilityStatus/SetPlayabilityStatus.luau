local Parent = script:FindFirstAncestor("PlayabilityRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 18
	assert(type(p1) == "table", "SetPlayabilityStatus action expects playabilityStatus to be a table")

	return {
		playabilityStatus = p1
	}
end)
