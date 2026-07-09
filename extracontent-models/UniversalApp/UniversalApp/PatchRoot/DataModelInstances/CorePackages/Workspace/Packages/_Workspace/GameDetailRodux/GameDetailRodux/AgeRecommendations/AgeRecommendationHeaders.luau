local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Cryo = require(GameDetailRoduxParent.Cryo)
local SetAgeRecommendationHeaders = require(GameDetailRodux.AgeRecommendations.SetAgeRecommendationHeaders)

return function(p1, p2) -- line: 7
	-- upvalues: SetAgeRecommendationHeaders (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetAgeRecommendationHeaders.name then
		v7 = Cryo.Dictionary.join(v7, {
			headerDisplayName = p2.headerDisplayName,
			headerDisplayNameShort = p2.headerDisplayNameShort
		})
	end

	return v7
end
