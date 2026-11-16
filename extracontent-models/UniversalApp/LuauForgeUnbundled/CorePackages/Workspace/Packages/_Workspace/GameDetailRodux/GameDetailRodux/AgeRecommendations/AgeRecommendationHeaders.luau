local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Cryo")
local SetAgeRecommendationHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/AgeRecommendations/SetAgeRecommendationHeaders")

return function(options, data)
	local joined = options or {}

	if data.type == SetAgeRecommendationHeaders.name then
		joined = Cryo.Dictionary.join(joined, {
			headerDisplayName = data.headerDisplayName,
			headerDisplayNameShort = data.headerDisplayNameShort
		})
	end

	return joined
end
