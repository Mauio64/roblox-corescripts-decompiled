local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local isWirable = require(SceneUnderstanding.wiring.isWirable)

require(SceneUnderstanding.wiring.types)

local function toWirableInstance(p1) -- line: 8
	-- upvalues: isWirable (copy)
	if p1 and isWirable(p1) then
		return p1
	end

	return nil
end

return toWirableInstance
