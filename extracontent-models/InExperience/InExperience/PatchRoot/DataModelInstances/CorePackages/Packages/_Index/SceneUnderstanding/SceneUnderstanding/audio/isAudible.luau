local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local calculatePotentialAudibility = require(SceneUnderstanding.audio.calculatePotentialAudibility)

local function isAudible(p1) -- line: 19
	-- upvalues: calculatePotentialAudibility (copy)
	return calculatePotentialAudibility(p1) > 0.01
end

return isAudible
