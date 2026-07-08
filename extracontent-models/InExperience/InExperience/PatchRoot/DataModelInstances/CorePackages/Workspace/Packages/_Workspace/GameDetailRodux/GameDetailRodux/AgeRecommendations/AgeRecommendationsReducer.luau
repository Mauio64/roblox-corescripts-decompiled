local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Cryo = require(GameDetailRoduxParent.Cryo)
local SetAgeRecommendation = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendation)

return function(p1, p2) -- line: 7
	-- upvalues: SetAgeRecommendation (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetAgeRecommendation.name then
		local ageRecommendationDetails = p2.ageRecommendationDetails

		v7 = Cryo.Dictionary.join(v7, {
			[p2.universeId] = ageRecommendationDetails
		})
	end

	return v7
end
