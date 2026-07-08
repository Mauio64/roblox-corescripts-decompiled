local AssetService = game:GetService("AssetService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local tryYield = require(ParentParent.util.tryYield)
local t1 = {}

local function orthoProjectCoordinate(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3) -- line: 29
	local v11 = vector3:Dot(vector3_3)
	local v12 = vector3_2:Dot(vector3_3)

	return Vector2.new(v11, v12)
end
local function shouldRenderTriangle(vector3: Vector3, vector3_4: Vector3) -- line: 36
	return vector3:Dot(vector3_4) < 0
end

function t1.shouldRenderTriangle_UNIT_TEST(vector3: Vector3, vector3_5: Vector3) -- line: 40
	return vector3:Dot(vector3_5) < 0
end

local function getScreenCoordinatesForTriangle(t2: {[any]: any}, vector2: Vector2, t3: {[any]: any}, vector3: Vector3, vector3_6: Vector3) -- line: 44
	local v22 = t2[1]
	local v23 = t2[2]
	local v24 = t2[3]
	local v25 = CFrame.new(vector3):Inverse() * v22
	local v26 = CFrame.new(vector3):Inverse() * v23
	local v27 = CFrame.new(vector3):Inverse() * v24
	local v28 = vector3_6 / 2
	local v29 = (v25 + v28) / vector3_6
	local v30 = (v26 + v28) / vector3_6
	local v31 = (v27 + v28) / vector3_6
	local axis1 = t3.axis1
	local axis2 = t3.axis2
	local v34 = axis1:Dot(v29)
	local v35 = axis2:Dot(v29)
	local v36 = Vector2.new(v34, v35) * (vector2 - Vector2.new(1, 1))
	local axis1_2 = t3.axis1
	local axis2_2 = t3.axis2
	local v39 = axis1_2:Dot(v30)
	local v40 = axis2_2:Dot(v30)
	local v41 = Vector2.new(v39, v40) * (vector2 - Vector2.new(1, 1))
	local axis1_3 = t3.axis1
	local axis2_3 = t3.axis2
	local v44 = axis1_3:Dot(v31)
	local v45 = axis2_3:Dot(v31)

	return v36, v41, Vector2.new(v44, v45) * (vector2 - Vector2.new(1, 1))
end

function t1.rasterMesh(t4: {[any]: any}, vector2: Vector2, t5: {[any]: any}, vector3: Vector3, vector3_7: Vector3, p1) -- line: 71
	-- upvalues: AssetService (copy), getScreenCoordinatesForTriangle (copy), tryYield (copy)
	local v52 = AssetService:CreateEditableImage({
		Size = vector2
	})

	for _, v54 in t4 do
		if v54.normal:Dot(t5.normal) < 0 then
			local v55, v56, v57 = getScreenCoordinatesForTriangle(v54.orderedVerts, v52.Size, t5, vector3, vector3_7)

			v52:DrawTriangle(v55, v56, v57, Color3.new(1, 1, 1), 0)
			tryYield(p1)
		end
	end

	return v52
end

return t1
