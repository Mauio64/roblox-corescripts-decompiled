local AssetService = game:GetService("AssetService")

local parent = script.Parent.Parent

require(parent.util.Types)
local tryYield = require(parent.util.tryYield)

local function orthoProjectCoordinate(axis1: Vector3, axis2: Vector3, vector3: Vector3) -- 3 equivalent calls inferred from this helper
	local dot = axis1:Dot(vector3)
	local dot2 = axis2:Dot(vector3)

	return Vector2.new(dot, dot2)
end

local function shouldRenderTriangle(vector: Vector3, vector3: Vector3): boolean -- 2 equivalent calls inferred from this helper
	return vector:Dot(vector3) < 0
end

local function getScreenCoordinatesForTriangle(orderedVerts, size: Vector2, p, position: Vector3, vector3: Vector3)
	local item = orderedVerts[1]
	local item2 = orderedVerts[2]
	local item3 = orderedVerts[3]

	local v = CFrame.new(position):Inverse() * item
	local v2 = CFrame.new(position):Inverse() * item2
	local v3 = CFrame.new(position):Inverse() * item3

	local v4 = vector3 / 2
	local v5 = (v + v4) / vector3
	local v6 = (v2 + v4) / vector3
	local v7 = (v3 + v4) / vector3

	return
		orthoProjectCoordinate(p.axis1, p.axis2, v5) * (size - Vector2.new(1, 1)), -- inferred equivalent call
		orthoProjectCoordinate(p.axis1, p.axis2, v6) * (size - Vector2.new(1, 1)), -- inferred equivalent call
		orthoProjectCoordinate(p.axis1, p.axis2, v7) * (size - Vector2.new(1, 1)) -- inferred equivalent call
end

local RasterUtil = {}

function RasterUtil.shouldRenderTriangle_UNIT_TEST(vector: Vector3, vector3: Vector3)
	return shouldRenderTriangle(vector, vector3) -- inferred equivalent call
end

function RasterUtil.rasterMesh(items, size: Vector2, p, vector3: Vector3, vector3_2: Vector3, p2)
	local editableImage = AssetService:CreateEditableImage({ Size = size })

	for _, item in items do
		if not shouldRenderTriangle(item.normal, p.normal) then -- inferred equivalent call
			continue
		end

		local screenCoordinatesForTriangle, v, v2 = getScreenCoordinatesForTriangle(
			item.orderedVerts,
			editableImage.Size,
			p,
			vector3,
			vector3_2
		)
		editableImage:DrawTriangle(screenCoordinatesForTriangle, v, v2, Color3.new(1, 1, 1), 0)
		tryYield(p2)
	end

	return editableImage
end

return RasterUtil
