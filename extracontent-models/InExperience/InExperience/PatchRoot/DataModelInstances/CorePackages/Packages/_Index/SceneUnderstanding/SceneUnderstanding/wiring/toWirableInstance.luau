local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local isWirable = require(SceneUnderstanding.wiring.isWirable)
require(SceneUnderstanding.wiring.types)

local function toWirableInstance(p)
	return if p and isWirable(p) then p else nil
end

return toWirableInstance
