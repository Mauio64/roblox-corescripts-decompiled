local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(universeId: string, ageRecommendationDetails)
	return { universeId = universeId, ageRecommendationDetails = ageRecommendationDetails }
end)
