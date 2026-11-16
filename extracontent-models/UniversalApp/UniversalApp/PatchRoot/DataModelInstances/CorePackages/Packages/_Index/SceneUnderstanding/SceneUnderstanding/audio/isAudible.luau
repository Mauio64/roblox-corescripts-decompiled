local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local calculatePotentialAudibility = require(SceneUnderstanding.audio.calculatePotentialAudibility)

local function isAudible(p): boolean
	return calculatePotentialAudibility(p) > 0.01
end

return isAudible
