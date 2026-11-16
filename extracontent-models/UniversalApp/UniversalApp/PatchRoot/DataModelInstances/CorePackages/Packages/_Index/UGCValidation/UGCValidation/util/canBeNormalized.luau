local parent = script.Parent.Parent

local floatEquals = require(parent.util.floatEquals)

local function canBeNormalized(vector3: Vector3): boolean
	return not (floatEquals(vector3.X, 0) and floatEquals(vector3.Y, 0) and floatEquals(vector3.Z, 0))
end

return canBeNormalized
