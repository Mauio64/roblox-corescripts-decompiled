local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local Cryo = require(parent.Cryo)
local SetAgeRecommendationHeaders = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendationHeaders)

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
