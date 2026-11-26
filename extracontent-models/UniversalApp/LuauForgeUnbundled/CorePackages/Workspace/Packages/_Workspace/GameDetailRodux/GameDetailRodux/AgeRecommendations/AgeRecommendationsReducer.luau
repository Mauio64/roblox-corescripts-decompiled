local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Cryo")
local SetAgeRecommendation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/SetAgeRecommendation")

return function(options, data)
	local v5 = options or {}

	if data.type ~= SetAgeRecommendation.name then
		return v5
	end

	local ageRecommendationDetails = data.ageRecommendationDetails
	v5 = Cryo.Dictionary.join(v5, { [data.universeId] = ageRecommendationDetails })

	return v5
end
