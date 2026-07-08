local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local Cryo = require(ReactSceneUnderstanding.Parent.Cryo)
local SceneUnderstanding = require(ReactSceneUnderstanding.Parent.SceneUnderstanding)

local function sortByAudibleVolume(t1: {[any]: any}) -- line: 6
	-- upvalues: Cryo (copy), SceneUnderstanding (copy)
	local v6 = Cryo.List.filter(t1, SceneUnderstanding.isAudible)

	return Cryo.List.sort(v6, function(p1, p2) -- line: 9
		-- upvalues: SceneUnderstanding (copy)
		return SceneUnderstanding.calculatePotentialAudibility(p1) > SceneUnderstanding.calculatePotentialAudibility(p2)
	end)
end

return sortByAudibleVolume
