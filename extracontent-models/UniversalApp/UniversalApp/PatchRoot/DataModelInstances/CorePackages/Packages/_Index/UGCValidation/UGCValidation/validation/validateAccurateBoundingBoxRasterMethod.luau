local AssetService = game:GetService("AssetService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)
local bodyAssetMasksRenderer = require(parent.util.bodyAssetMasksRenderer)
local nelderMead = require(parent.util.nelderMead)
local SummedAreaTable = require(parent.util.SummedAreaTable)
local FailureReasonsAccumulator = require(parent.util.FailureReasonsAccumulator)
local AssetCalculator = require(parent.util.AssetCalculator)
local getEditableMeshFromContext = require(parent.util.getEditableMeshFromContext)
local getMeshVerts = require(parent.util.getMeshVerts)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)
require(parent.util.Types)
local FloatVector = require(parent.util.FloatVector)
local Extents = require(parent.util.Extents)
local tryYield = require(parent.util.tryYield)

local validateAccurateBoundingBoxFlags = require(parent.flags.validateAccurateBoundingBoxFlags)
local getFFlagUGCValidateTinyTrianglesIntersectFix = require(parent.flags.getFFlagUGCValidateTinyTrianglesIntersectFix)

local function getHeadNeckAttachmentMeshLocalPosition(instance) -- 1 equivalent call inferred from this helper
	local neckRigAttachment = instance:FindFirstChild("NeckRigAttachment", true)

	if not neckRigAttachment then
		return nil
	end

	local attachmentCFrameInPartSpace = getAttachmentCFrameInPartSpace(neckRigAttachment)
	local v = instance.Size / instance.MeshSize
	return attachmentCFrameInPartSpace.Position / v
end

local function projectMeshLocalPointToImageRow(headNeckAttachmentMeshLocalPosition: Vector3, data)
	local v = data.view:Inverse() * headNeckAttachmentMeshLocalPosition

	local viewSpaceBounds = data.viewSpaceBounds
	local midpointY = (viewSpaceBounds.max.Y + viewSpaceBounds.min.Y) / 2
	local v2 = (viewSpaceBounds.max.Y - viewSpaceBounds.min.Y) / 2
	local v3 = (v.Y - midpointY) / v2

	local size = data.mask.Size
	return (v3 * -0.5 + 0.5) * (size.Y - 1)
end

local function cloneMaskZeroedBelowRow(mask, p: number)
	local size = mask.Size
	local x = size.X
	local y = size.Y

	local pixelsBuffer = mask:ReadPixelsBuffer(Vector2.zero, size)

	local v = math.max(0, (math.min(y, math.floor(p) + 1)))

	if v < y then
		local v2 = v * x * 4
		local v3 = (y - v) * x * 4
		buffer.fill(pixelsBuffer, v2, 0, v3)
	end

	local editableImage = AssetService:CreateEditableImage({ Size = size })
	editableImage:WritePixelsBuffer(Vector2.zero, size, pixelsBuffer)
	return editableImage
end

local function sampleAreaTable(object, p, p2, p3, p4) -- 1 equivalent call inferred from this helper
	local vector2 = Vector2.new(p, p3)
	local vector2_2 = Vector2.new(p2, p4)
	local v = vector2 * object.size
	return (object:GetAreaDensityContinuous(v, vector2_2 * object.size - v))
end

local function shrinkBounds(list, fn, size: Vector2)
	local function fn2(i: number) -- 1 equivalent call inferred from this helper
		if i % 2 == 0 then
			return i - 1
		end

		return i + 1
	end

	for i = 1, 4 do
		local v = list[fn2(i)] -- inferred equivalent call

		local v2 = 1 / size[i < 3 and "X" or "Y"]

		local v3 = FloatVector.new(list)
		local v4 = fn(list)
		local v5 = list[i]

		while v2 <= math.abs(v5 - v) do
			local midpoint = (v5 + v) / 2
			v3[i] = midpoint
			local v6 = fn(v3)

			if v6 < v4 then
				v3[i] = midpoint + (v - midpoint) * 0.01

				if fn(v3) - v6 > 0 then
					v = v5
				end

				v4 = v6
				v5 = midpoint
			else
				v = midpoint
			end
		end

		list[i] = v5
	end
end

local function createSimplex(p, p2: number)
	local simplex = {}
	table.insert(simplex, p)
	table.insert(simplex, p + FloatVector.new(p2, 0, 0, 0))
	table.insert(simplex, p + FloatVector.new(0, p2, 0, 0))
	table.insert(simplex, p + FloatVector.new(0, 0, p2, 0))
	table.insert(simplex, p + FloatVector.new(0, 0, 0, p2))
	return simplex
end

local function calculateMinimumBoundsForView(item, p)
	local simplex = createSimplex(FloatVector.new(0, 1, 0, 1), 0.9)

	local mask = item.mask
	local size = mask.Size
	local v = SummedAreaTable.new(size, function(data): number
		if data.R > 0 or data.G > 0 or data.B > 0 then
			return 1
		end

		return 0
	end)

	v:BuildSummedAreaTable(mask)
	local areaDensity = v:GetAreaDensity(Vector2.zero, size)

	if areaDensity <= 0 then
		return
			false,
			{ string.format(
					"%s asset not visible from the %s, cannot determine quality of asset bounding box",
					p.assetTypeEnum.Name,
					item.viewId
				) }
	end

	local targetPercentage = validateAccurateBoundingBoxFlags.targetPercentage()
	local percentageWeight = validateAccurateBoundingBoxFlags.percentageWeight()

	local function fn(list)
		assert(list:getSize() == 4)
		local v2

		if list[1] <= list[2] and list[3] <= list[4] then
			v2 = sampleAreaTable(v, list[1], list[2], list[3], list[4]) -- inferred equivalent call
		else
			v2 = 0
		end

		local v3 = math.abs(v2 / areaDensity * 100 - targetPercentage) * percentageWeight

		local vector2 = Vector2.new(list[2] - list[1], list[4] - list[3])
		return v3 + (vector2.X + vector2.Y)
	end

	local maxIterations = validateAccurateBoundingBoxFlags.maxIterations()
	local vector2 = Vector2.new(1 / size.X, 1 / size.Y)
	local convergedLength = validateAccurateBoundingBoxFlags.convergedLength()
	local v2 = vector2.Magnitude * convergedLength
	local function fn2(p2, p3: number): boolean
		if maxIterations <= p3 or nelderMead.calculateMaxLengthBetweenVertices(p2) <= v2 then
			return true
		end

		tryYield(p)
		return false
	end

	local v3 = nelderMead.new(simplex, fn, fn2)
	v3:evaluate()

	local v4 = v3.simplex[1]
	shrinkBounds(v4, fn, size)

	return
		true,
		(FloatVector.new(
			math.clamp(v4[1], 0, 1),
			math.clamp(v4[2], 0, 1),
			math.clamp(v4[3], 0, 1),
			(math.clamp(v4[4], 0, 1))
		))
end

local function transformIsAlignedWithAxis(cframe: CFrame, vector: Vector3): boolean -- 3 equivalent calls inferred from this helper
	if vector:FuzzyEq(cframe.XVector:Abs()) or vector:FuzzyEq(cframe.YVector:Abs()) then
		return true
	end

	return false
end

local function alignedExtentsFromReprojectedPoint(vector3: Vector3, view: CFrame)
	local v = { X = -1e999, Y = -1e999, Z = -1e999 }
	local v2 = { X = 1e999, Y = 1e999, Z = 1e999 }

	if transformIsAlignedWithAxis(view, Vector3.new(1, 0, 0)) then -- inferred equivalent call
		v.X = math.max(v.X, vector3.X)
		v2.X = math.min(v2.X, vector3.X)
	end

	if transformIsAlignedWithAxis(view, Vector3.new(0, 1, 0)) then -- inferred equivalent call
		v.Y = math.max(v.Y, vector3.Y)
		v2.Y = math.min(v2.Y, vector3.Y)
	end

	if transformIsAlignedWithAxis(view, Vector3.new(0, 0, 1)) then -- inferred equivalent call
		v.Z = math.max(v.Z, vector3.Z)
		v2.Z = math.min(v2.Z, vector3.Z)
	end

	return Extents.fromMinMax(Vector3.new(v2.X, v2.Y, v2.Z), (Vector3.new(v.X, v.Y, v.Z)))
end

local function calculateValidBounds(items, p)
	local v = Extents.new()

	local v2 = getFFlagUGCValidateTinyTrianglesIntersectFix() and {} or nil

	for k, item in items do
		local v3, v4 = calculateMinimumBoundsForView(item, p)

		if not v3 then
			return false, v4
		end

		local vector2 = Vector2.new(v4[2], v4[3])
		local vector2_2 = Vector2.new(v4[1], v4[4])

		local viewSpacePositionFromNormalized = bodyAssetMasksRenderer.getViewSpacePositionFromNormalized(
			vector2,
			item.viewSpaceBounds
		)
		local v5 = item.view * viewSpacePositionFromNormalized

		local viewSpacePositionFromNormalized2 = bodyAssetMasksRenderer.getViewSpacePositionFromNormalized(
			vector2_2,
			item.viewSpaceBounds
		)
		local v6 = item.view * viewSpacePositionFromNormalized2

		local v7 = alignedExtentsFromReprojectedPoint(v5, item.view)

		local v8 = alignedExtentsFromReprojectedPoint(v6, item.view)

		if getFFlagUGCValidateTinyTrianglesIntersectFix() then
			local unionExtents = Extents.new():unionExtents(v7):unionExtents(v8)

			local opposingViewId = bodyAssetMasksRenderer.opposingViewIds[k]

			if v2[opposingViewId] then
				v2[opposingViewId] = unionExtents:intersectExtents(v2[opposingViewId])
			else
				v2[k] = unionExtents
			end
		else
			v = v:unionExtents(v7):unionExtents(v8)
		end
	end

	if getFFlagUGCValidateTinyTrianglesIntersectFix() then
		for _, v3 in v2 do
			v = v:unionExtents(v3)
		end

		assert(v:isValid())
	end

	return true, v
end

local function worldSpacePositionFromPointInMeshPart(vector3: Vector3, instance) -- 1 equivalent call inferred from this helper
	return instance.CFrame * (vector3 * (instance.Size / instance.MeshSize))
end

local function getHighestInflatingPointInEachAxis(object, assetMeshesValidationSpaceTransforms, items, findMeshHandle, p)
	local size = object:size()
	local v = {
		X = {
			positive = { inflationScale = 0, furthestPointWorldSpace = nil },
			negative = { inflationScale = 0, furthestPointWorldSpace = nil }
		},
		Y = {
			positive = { inflationScale = 0, furthestPointWorldSpace = nil },
			negative = { inflationScale = 0, furthestPointWorldSpace = nil }
		},
		Z = {
			positive = { inflationScale = 0, furthestPointWorldSpace = nil },
			negative = { inflationScale = 0, furthestPointWorldSpace = nil }
		}
	}

	for k, item in items do
		local meshVerts, v2, v3 = getMeshVerts({ editableMesh = item, fullName = k }, p)

		if not meshVerts then
			return false, v2
		end

		local v4 = assetMeshesValidationSpaceTransforms[k]

		for _, v5 in v3 do
			local v6 = v5 * v4.scale
			local v7 = v4.CFrame * v6
			local furthestPointWorldSpace = worldSpacePositionFromPointInMeshPart(v5, findMeshHandle(k)) -- inferred equivalent call
			local v8 = (v7 - object.max) / size
			local v9 = (object.min - v7) / size

			for _, v10 in { "X", "Y", "Z" } do
				local v11 = v[v10]
				local positive = v11.positive
				local inflationScale = v8[v10]

				if positive.inflationScale < inflationScale then
					positive.furthestPointWorldSpace = furthestPointWorldSpace
					positive.inflationScale = inflationScale
				end

				local negative = v11.negative
				local inflationScale2 = v9[v10]

				if not (negative.inflationScale < inflationScale2) then
					continue
				end

				negative.furthestPointWorldSpace = furthestPointWorldSpace
				negative.inflationScale = inflationScale2
			end
		end
	end

	return true, v
end

local function getBodyPartAssetEditableMeshes(part, p)
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

	local result = {}

	for _, v in parts do
		local editableMeshFromContext, v2 = getEditableMeshFromContext(v, "MeshId", p)

		if not editableMeshFromContext then
			local v3 = string.format(
				"Failed to load mesh for MeshPart '%s'. Make sure mesh exists and try again.",
				v.Name
			)

			if not p.isServer then
				return false, { v3 }
			end

			error(v3)
		end

		result[v.Name] = v2
	end

	return true, result
end

local function tryReportInflationError(p, assetTypeEnum)
	local v = FailureReasonsAccumulator.new()
	local assetTypeToAxisThreshold = validateAccurateBoundingBoxFlags.AssetTypeToAxisThresholds[assetTypeEnum]

	for _, v2 in { "X", "Y", "Z" } do
		local v3 = p[v2]
		local v4 = v3.negative.inflationScale + v3.positive.inflationScale
		local v5 = assetTypeToAxisThreshold[v2]

		if not (v5 < v4) then
			continue
		end

		local furthestPointWorldSpaces = {}
		local inflationScale = v3.positive.inflationScale

		if v5 * 0.2 < inflationScale then
			table.insert(furthestPointWorldSpaces, v3.positive.furthestPointWorldSpace)
		end

		local inflationScale2 = v3.negative.inflationScale

		if v5 * 0.2 < inflationScale2 then
			table.insert(furthestPointWorldSpaces, v3.negative.furthestPointWorldSpace)
		end

		local v6

		if #furthestPointWorldSpaces > 0 then
			v6 = " near " .. string.format(
				"{%.4f, %.4f, %.4f}",
				furthestPointWorldSpaces[1].X,
				furthestPointWorldSpaces[1].Y,
				furthestPointWorldSpaces[1].Z
			)

			if #furthestPointWorldSpaces > 1 then
				v6 ..= string.format(
					", and {%.4f, %.4f, %.4f}",
					furthestPointWorldSpaces[2].X,
					furthestPointWorldSpaces[2].Y,
					furthestPointWorldSpaces[2].Z
				)
			end
		else
			v6 = ""
		end

		local v7 = v4 * 100
		local v8 = v5 * 100

		v:updateReasons(false, {
			string.format(
				"Detected low visibility geometry%s that increases %s bounding box size by %.2f%% (threshold is %.2f%%) in the %s axis. Remove the geometry or increase its size so that it is more visible",
				v6,
				assetTypeEnum.Name,
				v7,
				v8,
				v2
			)
		})
	end

	return v
end

local ValidateAccurateBoundingBoxRasterMethod = {}

local v = nil

function ValidateAccurateBoundingBoxRasterMethod.getBoundsViewsForAssetType(p)
	local function fn() -- 4 equivalent calls inferred from this helper
		local viewIdSet = {}

		for _, viewId in bodyAssetMasksRenderer.viewIds do
			viewIdSet[viewId] = true
		end

		return viewIdSet
	end

	if v then
		return v[p]
	end

	local viewIdSet = fn() -- inferred equivalent call
	viewIdSet[bodyAssetMasksRenderer.viewIds.Left] = false
	viewIdSet[bodyAssetMasksRenderer.viewIds.Bottom] = false
	local viewIdSet2 = fn() -- inferred equivalent call
	viewIdSet2[bodyAssetMasksRenderer.viewIds.Right] = false
	viewIdSet2[bodyAssetMasksRenderer.viewIds.Bottom] = false
	local viewIdSet3 = fn() -- inferred equivalent call
	viewIdSet3[bodyAssetMasksRenderer.viewIds.Left] = false
	viewIdSet3[bodyAssetMasksRenderer.viewIds.Bottom] = false
	local viewIdSet4 = fn() -- inferred equivalent call
	viewIdSet4[bodyAssetMasksRenderer.viewIds.Right] = false
	viewIdSet4[bodyAssetMasksRenderer.viewIds.Bottom] = false

	v = {
		[Enum.AssetType.DynamicHead] = nil,
		[Enum.AssetType.Torso] = nil,
		[Enum.AssetType.LeftArm] = viewIdSet,
		[Enum.AssetType.RightArm] = viewIdSet2,
		[Enum.AssetType.LeftLeg] = viewIdSet3,
		[Enum.AssetType.RightLeg] = viewIdSet4
	}

	return v[p]
end

function ValidateAccurateBoundingBoxRasterMethod.validate(instance, p, p2)
	local assetTypeEnum = p2.assetTypeEnum
	assert(assetTypeEnum)

	local function findMeshHandle(childName: string)
		if assetTypeEnum == Enum.AssetType.DynamicHead then
			return instance
		end

		return (instance:FindFirstChild(childName))
	end

	local boundsViewsForAssetType = ValidateAccurateBoundingBoxRasterMethod.getBoundsViewsForAssetType(assetTypeEnum)
	local v2 = {}

	if boundsViewsForAssetType then
		for k, v3 in boundsViewsForAssetType do
			if not v3 then
				continue
			end

			assert(p.bodyAssetMasks[k])
			v2[k] = p.bodyAssetMasks[k]
		end
	else
		v2 = p.bodyAssetMasks
	end

	local maskZeroedBelowRows = {}

	if assetTypeEnum == Enum.AssetType.DynamicHead and validateAccurateBoundingBoxFlags.neckAttachmentCrop() then
		local headNeckAttachmentMeshLocalPosition = getHeadNeckAttachmentMeshLocalPosition(instance) -- inferred equivalent call

		if headNeckAttachmentMeshLocalPosition then
			local neckAttachmentCropMargin = validateAccurateBoundingBoxFlags.neckAttachmentCropMargin()
			local v3 = {}

			for k, v4 in v2 do
				local v5

				if k == bodyAssetMasksRenderer.viewIds.Top then
					v5 = false
				else
					v5 = k ~= bodyAssetMasksRenderer.viewIds.Bottom
				end

				if v5 then
					local v6 = projectMeshLocalPointToImageRow(headNeckAttachmentMeshLocalPosition, v4)
					local mask = v4.mask
					local maskZeroedBelowRow = cloneMaskZeroedBelowRow(
						mask,
						v6 + neckAttachmentCropMargin * (mask.Size.Y - 1) / 2
					)
					table.insert(maskZeroedBelowRows, maskZeroedBelowRow)

					v3[k] = {
						mask = maskZeroedBelowRow,
						view = v4.view,
						viewSpaceBounds = v4.viewSpaceBounds,
						viewId = v4.viewId
					}
				else
					v3[k] = v4
				end
			end

			v2 = v3
		end
	end

	local v3, v4 = (function()
		local v3, v4 = calculateValidBounds(v2, p2)

		if not v3 then
			return false, v4
		end

		local assetMeshesValidationSpaceTransforms = AssetCalculator.getAssetMeshesValidationSpaceTransforms(
			instance,
			p2
		)

		local bodyPartAssetEditableMeshes, v5 = getBodyPartAssetEditableMeshes(instance, p2)

		if not bodyPartAssetEditableMeshes then
			return false, v5
		end

		local highestInflatingPointInEachAxis, v6 = getHighestInflatingPointInEachAxis(
			v4,
			assetMeshesValidationSpaceTransforms,
			v5,
			findMeshHandle,
			p2
		)

		if not highestInflatingPointInEachAxis then
			return false, v6
		end

		local v7 = tryReportInflationError(v6, assetTypeEnum)

		if not v7:getFinalResults() then
			Analytics.reportFailure(Analytics.ErrorType.validateAccurateBoundingBox, nil, p2)
		end

		return v7:getFinalResults()
	end)()

	for _, v5 in maskZeroedBelowRows do
		v5:Destroy()
	end

	return v3, v4
end

return ValidateAccurateBoundingBoxRasterMethod
