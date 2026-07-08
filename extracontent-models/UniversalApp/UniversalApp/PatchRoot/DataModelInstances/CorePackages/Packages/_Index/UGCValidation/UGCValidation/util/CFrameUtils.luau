local ParentParent = script.Parent.Parent
local valueToString = require(script.Parent.valueToString)
local floatEquals = require(ParentParent.util.floatEquals)

return {
	fuzzyEq = function(cFrame: CFrame, cFrame2: CFrame, n1: number?) -- line: 7
		-- upvalues: floatEquals (copy)
		local v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18 = cFrame:GetComponents()
		local v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30 = cFrame2:GetComponents()

		return floatEquals(v7, v19, n1) and (floatEquals(v8, v20, n1) and (floatEquals(v9, v21, n1) and (floatEquals(v10, v22, n1) and (floatEquals(v11, v23, n1) and (floatEquals(v12, v24, n1) and (floatEquals(v13, v25, n1) and (floatEquals(v14, v26, n1) and (floatEquals(v15, v27, n1) and (floatEquals(v16, v28, n1) and (floatEquals(v17, v29, n1) and floatEquals(v18, v30, n1)))))))))))
	end,
	getRotationString = function(cFrame: CFrame) -- line: 24
		-- upvalues: valueToString (copy)
		local vector3 = Vector3.new(cFrame:ToOrientation())
		local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

		return valueToString(vector3_2)
	end
}
