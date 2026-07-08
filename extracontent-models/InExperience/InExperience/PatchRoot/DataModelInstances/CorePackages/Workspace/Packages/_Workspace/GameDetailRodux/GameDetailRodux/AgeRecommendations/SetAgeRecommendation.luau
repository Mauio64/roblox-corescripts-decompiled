local Parent = script:FindFirstAncestor("GameDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, p1) -- line: 6
	return {
		universeId = s1,
		ageRecommendationDetails = p1
	}
end)
