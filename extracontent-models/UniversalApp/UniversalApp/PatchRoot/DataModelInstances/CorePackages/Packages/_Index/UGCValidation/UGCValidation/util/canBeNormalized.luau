local ParentParent = script.Parent.Parent
local floatEquals = require(ParentParent.util.floatEquals)

local function canBeNormalized(vector3: Vector3) -- line: 9
	-- upvalues: floatEquals (copy)
	return not floatEquals(vector3.X, 0) or (not floatEquals(vector3.Y, 0) or not floatEquals(vector3.Z, 0))
end

return canBeNormalized
