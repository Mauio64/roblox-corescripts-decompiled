local parent = script.Parent.Parent
local valueToString = require(script.Parent.valueToString)
local floatEquals = require(parent.util.floatEquals)
local CFrameUtils = {}

function CFrameUtils.fuzzyEq(cframe: CFrame, cframe2: CFrame, p: number?)
	local components, v, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11 = cframe:GetComponents()
	local components2, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22 = cframe2:GetComponents()
	return floatEquals(components, components2, p)
		and floatEquals(v, v12, p)
		and floatEquals(v2, v13, p)
		and floatEquals(v3, v14, p)
		and floatEquals(v4, v15, p)
		and floatEquals(v5, v16, p)
		and floatEquals(v6, v17, p)
		and floatEquals(v7, v18, p)
		and floatEquals(v8, v19, p)
		and floatEquals(v9, v20, p)
		and floatEquals(v10, v21, p)
		and floatEquals(v11, v22, p)
end

function CFrameUtils.getRotationString(cframe: CFrame)
	local vector3 = Vector3.new(cframe:ToOrientation())
	return valueToString((Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))))
end

return CFrameUtils
