local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local Cryo = require(ReactSceneUnderstanding.Parent.Cryo)
local SceneUnderstanding = require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local function sortByAudibleVolume(p)
	local filtered = Cryo.List.filter(p, SceneUnderstanding.isAudible)

	return Cryo.List.sort(filtered, function(p2, p3): boolean
		return SceneUnderstanding.calculatePotentialAudibility(p2) > SceneUnderstanding.calculatePotentialAudibility(p3)
	end)
end

return sortByAudibleVolume
