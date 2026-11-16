local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local Cryo = require(parent.Cryo)
local SetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendation)

return function(options, data)
	local v = options or {}

	if data.type ~= SetAgeRecommendation.name then
		return v
	end

	local ageRecommendationDetails = data.ageRecommendationDetails
	return (Cryo.Dictionary.join(v, { [data.universeId] = ageRecommendationDetails }))
end
