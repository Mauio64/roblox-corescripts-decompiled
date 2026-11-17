local parent = script.Parent.Parent

require(parent.util.Types)
local tryYield = require(parent.util.tryYield)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)

local AssetCalculator = require(parent.util.AssetCalculator)
local getAssetMeshesValidationSpaceTransforms = AssetCalculator.getAssetMeshesValidationSpaceTransforms

local AssetService = game:GetService("AssetService")

local getFIntUGCValidationBodyAssetMaskHeightPixels = require(parent.flags.getFIntUGCValidationBodyAssetMaskHeightPixels)
local getFFlagUGCValidateTinyTrianglesIntersectFix = require(parent.flags.getFFlagUGCValidateTinyTrianglesIntersectFix)

local BodyAssetMasksRenderer = {}
BodyAssetMasksRenderer.__index = BodyAssetMasksRenderer

BodyAssetMasksRenderer.viewIds = {
	Front = "Front",
	Back = "Back",
	Left = "Left",
	Right = "Right",
	Top = "Top",
	Bottom = "Bottom"
}

if getFFlagUGCValidateTinyTrianglesIntersectFix() then
	BodyAssetMasksRenderer.opposingViewIds = {
		Front = BodyAssetMasksRenderer.viewIds.Back,
		Back = BodyAssetMasksRenderer.viewIds.Front,
		Left = BodyAssetMasksRenderer.viewIds.Right,
		Right = BodyAssetMasksRenderer.viewIds.Left,
		Top = BodyAssetMasksRenderer.viewIds.Bottom,
		Bottom = BodyAssetMasksRenderer.viewIds.Top
	}
end

BodyAssetMasksRenderer.viewDirections = {
	[BodyAssetMasksRenderer.viewIds.Front] = Vector3.new(0, 0, 1),
	[BodyAssetMasksRenderer.viewIds.Back] = Vector3.new(0, 0, -1),
	[BodyAssetMasksRenderer.viewIds.Left] = Vector3.new(-1, 0, 0),
	[BodyAssetMasksRenderer.viewIds.Right] = Vector3.new(1, 0, 0),
	[BodyAssetMasksRenderer.viewIds.Top] = Vector3.new(0, -1, 0),
	[BodyAssetMasksRenderer.viewIds.Bottom] = Vector3.new(0, 1, 0)
}

BodyAssetMasksRenderer.views = nil

function BodyAssetMasksRenderer.getViewToWorldTransforms()
	if BodyAssetMasksRenderer.views then
		return BodyAssetMasksRenderer.views
	end

	BodyAssetMasksRenderer.views = {}

	for _, viewId in BodyAssetMasksRenderer.viewIds do
		local viewDirection = BodyAssetMasksRenderer.viewDirections[viewId]
		local v = Vector3.new(0, 1, 0)

		if math.abs((viewDirection:Dot(v))) > 0.99 then
			v = BodyAssetMasksRenderer.viewDirections[BodyAssetMasksRenderer.viewIds.Front]
		end

		local cframe = CFrame.lookAlong(Vector3.new(0, 0, 0), viewDirection, v)

		BodyAssetMasksRenderer.views[viewId] = cframe
	end

	return BodyAssetMasksRenderer.views
end

function BodyAssetMasksRenderer.getViewSpacePositionFromNormalized(vector2: Vector2, p)
	local v = (vector2 - Vector2.new(0.5, 0.5)) * Vector2.new(2, -2)
	local v2 = (p.max - p.min) / 2
	return p.min + v2 + v2 * Vector3.new(v.X, v.Y, 0)
end

local function populateViewsToRender(items)
	local viewToWorldTransforms = BodyAssetMasksRenderer.getViewToWorldTransforms()
	local result = {}

	if not items then
		return viewToWorldTransforms
	end

	for k, item in items do
		if item and viewToWorldTransforms[k] then
			result[k] = viewToWorldTransforms[k]
		end
	end

	return result
end

local function addTransformedTriangle(object, face: number, p, list)
	local faceVertices = object:GetFaceVertices(face)

	local v = {}

	for i = 1, 3 do
		local v2 = object:GetPosition(faceVertices[i]) * p.scale
		table.insert(v, p.CFrame * v2)
	end

	table.insert(list, v)
end

local function pushTransformedMesh(object, assetMeshesValidationSpaceTransform, p, p2)
	local faces = object:GetFaces()

	for _, face in faces do
		addTransformedTriangle(object, face, assetMeshesValidationSpaceTransform, p2)
		tryYield(p)
	end
end

local function getViewSpaceMesh(items, item: CFrame)
	local inverse = item:Inverse()

	local result = {
		min = Vector3.new(1e999, 1e999, 1e999),
		max = Vector3.new(-1e999, -1e999, -1e999)
	}

	local result2 = {}

	for _, item2 in items do
		local v = {}

		for _, v2 in item2 do
			local v3 = inverse * v2
			table.insert(v, inverse * v2)
			result.min = result.min:Min(v3)
			result.max = result.max:Max(v3)
		end

		table.insert(result2, v)
	end

	return result2, result
end

local function getNormalizedCoordinates(item, vector3: Vector3, vector3_2: Vector3) -- 1 equivalent call inferred from this helper
	local normalizedCoordinates = {}

	for _, item2 in item do
		table.insert(normalizedCoordinates, (item2 - vector3) / vector3_2)
	end

	return normalizedCoordinates
end

local function getIsNormalizedTriangleVisible(normalizedCoordinates): boolean -- 1 equivalent call inferred from this helper
	return (normalizedCoordinates[2] - normalizedCoordinates[1]):Cross(normalizedCoordinates[3] - normalizedCoordinates[1]).Z > 0.001
end

local function normalizedSpaceToScreenSpace(normalizedCoordinate: Vector3, floor: Vector2)
	return (Vector2.new(normalizedCoordinate.X, normalizedCoordinate.Y) * Vector2.new(0.5, -0.5) + Vector2.new(0.5, 0.5)) * (floor - Vector2.new(1, 1))
end

local function rasterMesh(viewSpaceMesh, p, fIntUGCValidationBodyAssetMaskHeightPixels: number, p2)
	local v = p.max - p.min
	local v2 = v / 2
	local v3 = p.min + v2

	local v4 = v.X / v.Y * fIntUGCValidationBodyAssetMaskHeightPixels
	local vector2 = Vector2.new(v4, fIntUGCValidationBodyAssetMaskHeightPixels)

	local floor = (vector2 * math.min(1024 / math.max(vector2.X, vector2.Y), 1) + Vector2.new(0.5)):Floor()

	local editableImage = AssetService:CreateEditableImage({ Size = floor })

	for _, item in viewSpaceMesh do
		local normalizedCoordinates = getNormalizedCoordinates(item, v3, v2) -- inferred equivalent call

		if not getIsNormalizedTriangleVisible(normalizedCoordinates) then -- inferred equivalent call
			continue
		end

		local v5 = {}

		for _, normalizedCoordinate in normalizedCoordinates do
			table.insert(v5, normalizedSpaceToScreenSpace(normalizedCoordinate, floor))
		end

		editableImage:DrawTriangle(v5[1], v5[2], v5[3], Color3.new(1, 1, 1), 0)
		tryYield(p2)
	end

	return editableImage
end

local function createBodyAssetMasks(part, items, p)
	local assetTypeEnum = p.assetTypeEnum

	local parts = {}

	if part:IsA("MeshPart") and p.assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(parts, part)
	else
		for _, part2 in part:GetChildren() do
			if part2:IsA("MeshPart") then
				table.insert(parts, part2)
			end
		end
	end

	local assetMeshesValidationSpaceTransforms = getAssetMeshesValidationSpaceTransforms(part, p)

	local v = {}

	for _, v2 in parts do
		local editableMeshFromContext, v3 = getEditableMeshFromContext(v2, "MeshId", p)

		if not editableMeshFromContext then
			local v4 = string.format(
				"Failed to load mesh for MeshPart '%s'. Make sure mesh exists and try again.",
				v2.Name
			)

			if not p.isServer then
				return false, { v4 }
			end

			error(v4)
		end

		v3:Triangulate()

		pushTransformedMesh(v3, assetMeshesValidationSpaceTransforms[v2.Name], p, v)
	end

	if #v == 0 then
		return false, { string.format("Mesh for %s has no triangles.", assetTypeEnum.Name) }
	end

	local result = {}

	for k, item in items do
		local viewSpaceMesh, viewSpaceBounds = getViewSpaceMesh(v, item)
		result[k] = {
			viewId = k,
			mask = rasterMesh(viewSpaceMesh, viewSpaceBounds, getFIntUGCValidationBodyAssetMaskHeightPixels(), p),
			view = item,
			viewSpaceBounds = viewSpaceBounds
		}
	end

	return true, result
end

function BodyAssetMasksRenderer.new(p, p2, p3)
	local self = setmetatable({}, BodyAssetMasksRenderer)
	local bodyAssetMasks, bodyAssetMasks2 = createBodyAssetMasks(p, populateViewsToRender(p2), p3)

	if not bodyAssetMasks then
		return false, bodyAssetMasks2
	end

	self.bodyAssetMasks = bodyAssetMasks2
	return true, self
end

function BodyAssetMasksRenderer.destroyBodyAssetMasks(p)
	for _, bodyAssetMask in p.bodyAssetMasks do
		if not bodyAssetMask.mask then
			continue
		end

		bodyAssetMask.mask:Destroy()
		bodyAssetMask.mask = nil
	end
end

return BodyAssetMasksRenderer
