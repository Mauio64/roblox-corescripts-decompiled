local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local tryYield = require(ParentParent.util.tryYield)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local getAssetMeshesValidationSpaceTransforms = require(ParentParent.util.AssetCalculator).getAssetMeshesValidationSpaceTransforms
local AssetService = game:GetService("AssetService")
local getFIntUGCValidationBodyAssetMaskHeightPixels = require(ParentParent.flags.getFIntUGCValidationBodyAssetMaskHeightPixels)
local getFFlagUGCValidateTinyTrianglesIntersectFix = require(ParentParent.flags.getFFlagUGCValidateTinyTrianglesIntersectFix)
local t1 = {}

t1.__index = t1
t1.viewIds = {
	Front = "Front",
	Back = "Back",
	Left = "Left",
	Right = "Right",
	Top = "Top",
	Bottom = "Bottom"
}

if getFFlagUGCValidateTinyTrianglesIntersectFix() then
	t1.opposingViewIds = {
		Front = t1.viewIds.Back,
		Back = t1.viewIds.Front,
		Left = t1.viewIds.Right,
		Right = t1.viewIds.Left,
		Top = t1.viewIds.Bottom,
		Bottom = t1.viewIds.Top
	}
end

t1.viewDirections = {
	[t1.viewIds.Front] = Vector3.new(0, 0, 1),
	[t1.viewIds.Back] = Vector3.new(0, 0, -1),
	[t1.viewIds.Left] = Vector3.new(-1, 0, 0),
	[t1.viewIds.Right] = Vector3.new(1, 0, 0),
	[t1.viewIds.Top] = Vector3.new(0, -1, 0),
	[t1.viewIds.Bottom] = Vector3.new(0, 1, 0)
}
t1.views = nil

function t1.getViewToWorldTransforms() -- line: 73
	-- upvalues: t1 (copy)
	if not t1.views then
		t1.views = {}

		for _, v19 in t1.viewIds do
			local v20 = t1.viewDirections[v19]
			local vector3 = Vector3.new(0, 1, 0)

			if math.abs((v20:Dot(vector3))) > 0.99 then
				vector3 = t1.viewDirections[t1.viewIds.Front]
			end

			local v22 = CFrame.lookAlong(Vector3.new(0, 0, 0), v20, vector3)

			t1.views[v19] = v22
		end
	end

	return t1.views
end
function t1.getViewSpacePositionFromNormalized(vector2: Vector2, t2: {[any]: any}) -- line: 92
	local v25 = (vector2 - Vector2.new(0.5, 0.5)) * Vector2.new(2, -2)
	local v26 = (t2.max - t2.min) / 2

	return t2.min + v26 + v26 * Vector3.new(v25.X, v25.Y, 0)
end

local function populateViewsToRender(t3: {[any]: any}?) -- line: 104
	-- upvalues: t1 (copy)
	local v28 = t1.getViewToWorldTransforms()
	local t4 = {}

	if t3 then
		for v30, v31 in t3 do
			if v31 and v28[v30] then
				t4[v30] = v28[v30]
			end
		end

		return t4
	end

	return v28
end
local function addTransformedTriangle(p1, n1: number, t5: {[any]: any}, t6: {[any]: any}) -- line: 120
	local FaceVertices = p1:GetFaceVertices(n1)
	local t7 = {}

	for i = 1, 3 do
		local v39 = p1:GetPosition(FaceVertices[i]) * t5.scale

		table.insert(t7, t5.CFrame * v39)
	end

	table.insert(t6, t7)
end
local function pushTransformedMesh(p2, t8: {[any]: any}, p3, t9: {[any]: any}) -- line: 139
	-- upvalues: addTransformedTriangle (copy), tryYield (copy)
	for _, v45 in (p2:GetFaces()) do
		addTransformedTriangle(p2, v45, t8, t9)
		tryYield(p3)
	end
end
local function getViewSpaceMesh(t10: {[any]: any}, cFrame: CFrame) -- line: 152
	local v48 = cFrame:Inverse()
	local t11 = {
		min = Vector3.new(1e999, 1e999, 1e999),
		max = Vector3.new(-1e999, -1e999, -1e999)
	}
	local t12 = {}

	for _, v52 in t10 do
		local t13 = {}

		for _, v55 in v52 do
			local v56 = v48 * v55

			table.insert(t13, v48 * v55)
			t11.min = t11.min:Min(v56)
			t11.max = t11.max:Max(v56)
		end

		table.insert(t12, t13)
	end

	return t12, t11
end
local function getNormalizedCoordinates(t14: {[any]: any}, vector3: Vector3, vector3_2: Vector3) -- line: 179
	local t15 = {}

	for _, v62 in t14 do
		table.insert(t15, (v62 - vector3) / vector3_2)
	end

	return t15
end
local function getIsNormalizedTriangleVisible(t16: {[any]: any}) -- line: 193
	return (t16[2] - t16[1]):Cross(t16[3] - t16[1]).Z > 0.001
end
local function normalizedSpaceToScreenSpace(vector3: Vector3, vector2: Vector2) -- line: 204
	return (Vector2.new(vector3.X, vector3.Y) * Vector2.new(0.5, -0.5) + Vector2.new(0.5, 0.5)) * (vector2 - Vector2.new(1, 1))
end
local function rasterMesh(t17: {[any]: any}, t18: {[any]: any}, n2: number, p4) -- line: 211
	-- upvalues: AssetService (copy), normalizedSpaceToScreenSpace (copy), tryYield (copy)
	local v70 = t18.max - t18.min
	local v71 = v70 / 2
	local v72 = t18.min + v71
	local v73 = v70.X / v70.Y * n2
	local vector2 = Vector2.new(v73, n2)
	local v75 = (vector2 * math.min(1024 / math.max(vector2.X, vector2.Y), 1) + Vector2.new(0.5)):Floor()
	local v76 = AssetService:CreateEditableImage({
		Size = v75
	})

	for _, v78 in t17 do
		local t19 = {}

		for _, v81 in v78 do
			table.insert(t19, (v81 - v72) / v71)
		end

		if (t19[2] - t19[1]):Cross(t19[3] - t19[1]).Z > 0.001 then
			local t20 = {}

			for _, v84 in t19 do
				table.insert(t20, (normalizedSpaceToScreenSpace(v84, v75)))
			end

			v76:DrawTriangle(t20[1], t20[2], t20[3], Color3.new(1, 1, 1), 0)
			tryYield(p4)
		end
	end

	return v76
end
local function createBodyAssetMasks(p5, t21: {[any]: any}, p6) -- line: 250
	-- upvalues: getAssetMeshesValidationSpaceTransforms (copy), getEditableMeshFromContext (copy), pushTransformedMesh (copy), getViewSpaceMesh (copy), getFIntUGCValidationBodyAssetMaskHeightPixels (copy), rasterMesh (copy)
	local assetTypeEnum = p6.assetTypeEnum
	local t22 = {}

	if p5:IsA("MeshPart") and p6.assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(t22, p5)
	else
		for _, child in p5:GetChildren() do
			if child:IsA("MeshPart") then
				table.insert(t22, child)
			end
		end
	end

	local v92 = getAssetMeshesValidationSpaceTransforms(p5, p6)
	local t23 = {}

	for _, v95 in t22 do
		local v96, v97 = getEditableMeshFromContext(v95, "MeshId", p6)

		if not v96 then
			local v98 = string.format("Failed to load mesh for MeshPart '%s'. Make sure mesh exists and try again.", v95.Name)

			if not p6.isServer then
				return false, { v98 }
			end

			error(v98)
		end

		v97:Triangulate()

		local v99 = v92[v95.Name]

		pushTransformedMesh(v97, v99, p6, t23)
	end

	if #t23 == 0 then
		return false, { string.format("Mesh for %s has no triangles.", assetTypeEnum.Name) }
	end

	local t24 = {}

	for v101, v102 in t21 do
		local v103, v104 = getViewSpaceMesh(t23, v102)
		local v105 = getFIntUGCValidationBodyAssetMaskHeightPixels()
		local v106 = rasterMesh(v103, v104, v105, p6)

		t24[v101] = {
			viewId = v101,
			mask = v106,
			view = v102,
			viewSpaceBounds = v104
		}
	end

	return true, t24
end

function t1.new(p7, t25: {[any]: any}?, p8) -- line: 312
	-- upvalues: t1 (copy), populateViewsToRender (copy), createBodyAssetMasks (copy)
	local self = setmetatable({}, t1)
	local v111 = populateViewsToRender(t25)
	local v112, v113 = createBodyAssetMasks(p7, v111, p8)

	if not v112 then
		return false, v113
	end

	self.bodyAssetMasks = v113

	return true, self
end
function t1.destroyBodyAssetMasks(p9) -- line: 327
	for _, v116 in p9.bodyAssetMasks do
		if v116.mask then
			v116.mask:Destroy()
			v116.mask = nil
		end
	end
end

return t1
