local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local tryYield = require(ParentParent.util.tryYield)
local getEditableMeshFromContext = require(ParentParent.util.getEditableMeshFromContext)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local RasterUtil = require(ParentParent.util.RasterUtil)
local TransparencyUtil = require(ParentParent.util.TransparencyUtil)
local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)
local ConstantsTransparencyValidation = require(ParentParent.ConstantsTransparencyValidation)

local function getViews() -- line: 23
	-- upvalues: ConstantsTransparencyValidation (copy)
	return {
		{
			axis1 = Vector3.new(1, 0, 0),
			axis2 = Vector3.new(0, 1, 0),
			normal = Vector3.new(0, 0, 1),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Front
		},
		{
			axis1 = Vector3.new(1, 0, 0),
			axis2 = Vector3.new(0, 1, 0),
			normal = Vector3.new(0, 0, -1),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Back
		},
		{
			axis1 = Vector3.new(0, 0, 1),
			axis2 = Vector3.new(0, 1, 0),
			normal = Vector3.new(-1, 0, 0),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Left
		},
		{
			axis1 = Vector3.new(0, 0, 1),
			axis2 = Vector3.new(0, 1, 0),
			normal = Vector3.new(1, 0, 0),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Right
		},
		{
			axis1 = Vector3.new(1, 0, 0),
			axis2 = Vector3.new(0, 0, 1),
			normal = Vector3.new(0, -1, 0),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Top
		},
		{
			axis1 = Vector3.new(1, 0, 0),
			axis2 = Vector3.new(0, 0, 1),
			normal = Vector3.new(0, 1, 0),
			viewId = ConstantsTransparencyValidation.CAMERA_ANGLES.Bottom
		}
	}
end
local function getAspectRatio(vector3: Vector3, p1) -- line: 64
	-- upvalues: ConstantsTransparencyValidation (copy)
	if p1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Front or p1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Back then
		return vector3.X / vector3.Y
	end

	if p1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Left or p1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Right then
		return vector3.Z / vector3.Y
	end

	return vector3.X / vector3.Z
end
local function getScaleFactor(p2, p3) -- line: 81
	-- upvalues: ConstantsTransparencyValidation (copy)
	local v24 = if p3 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Front and p3 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Back then if p3 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Left and p3 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Right then p2.X / p2.Z else p2.Z / p2.Y else p2.X / p2.Y
	local v25, ASSET_TRANSPARENCY_RASTER_SIZE

	if v24 > 1 then
		v25 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE / v24
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	elseif v24 < 1 then
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE * v24
		v25 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	else
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
		v25 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	end

	local vector2 = Vector2.new(ASSET_TRANSPARENCY_RASTER_SIZE / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE, v25 / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE)
	local v28 = math.max(vector2.X, vector2.Y)

	if v28 > 1 then
		return vector2 / v28
	end

	return vector2
end
local function addTransformedTriangle(p4, p5, p6, cFrame: CFrame, vector3: Vector3?) -- line: 108
	-- upvalues: TransparencyUtil (copy)
	local t1 = {
		orderedVerts = {}
	}
	local FaceVertices = p4:GetFaceVertices(p6)
	local Position = p4:GetPosition(FaceVertices[1])
	local Position2 = p4:GetPosition(FaceVertices[2])
	local Position3 = p4:GetPosition(FaceVertices[3])
	local v39, v40, v41, v42 = TransparencyUtil.transformTriangleToWorld(Position, Position2, Position3, cFrame, vector3)

	table.insert(t1.orderedVerts, v39)
	table.insert(t1.orderedVerts, v40)
	table.insert(t1.orderedVerts, v41)
	t1.normal = v42
	table.insert(p5, t1)

	return t1
end
local function updateMinMaxBounds(p7, p8) -- line: 137
	local minX = p7.min.X
	local maxX = p7.max.X
	local minY = p7.min.Y
	local maxY = p7.max.Y
	local minZ = p7.min.Z
	local maxZ = p7.max.Z
	local v51 = p8.orderedVerts[1]
	local v52 = p8.orderedVerts[2]
	local v53 = p8.orderedVerts[3]
	local v54 = math.min(v51.X, v52.X, v53.X, minX)
	local v55 = math.max(v51.X, v52.X, v53.X, maxX)
	local v56 = math.min(v51.Y, v52.Y, v53.Y, minY)
	local v57 = math.max(v51.Y, v52.Y, v53.Y, maxY)
	local v58 = math.min(v51.Z, v52.Z, v53.Z, minZ)
	local v59 = math.max(v51.Z, v52.Z, v53.Z, maxZ)

	p7.min = Vector3.new(v54, v56, v58)
	p7.max = Vector3.new(v55, v57, v59)
end
local function getCombinedMeshData(p9, p10, cFrame: CFrame, p11, vector3: Vector3?, p12) -- line: 160
	-- upvalues: addTransformedTriangle (copy), updateMinMaxBounds (copy), tryYield (copy)
	for _, v67 in (p9:GetFaces()) do
		local v68 = addTransformedTriangle(p9, p10, v67, cFrame, vector3)

		updateMinMaxBounds(p11, v68)
		tryYield(p12)
	end
end
local function getOpacity(p13) -- line: 176
	local v70 = p13:ReadPixelsBuffer(Vector2.new(0, 0), p13.Size)
	local n1 = 0
	local n2 = 0

	for i = 0, buffer.len(v70) - 1, 4 do
		local v74 = buffer.readu8(v70, i)
		local v75 = buffer.readu8(v70, i + 1)
		local v76 = buffer.readu8(v70, i + 2)

		if v74 == 0 and v75 == 0 and v76 == 0 then
			n2 += 1
		end

		n1 += 1
	end

	if n1 == 0 then
		return false, 0
	end

	return true, 1 - n2 / n1
end
local function checkPartsTransparency(p14) -- line: 199
	local t2 = {}

	for _, v80 in p14 do
		if v80.Transparency ~= 0 then
			table.insert(t2, v80.Name)
		end
	end

	if #t2 > 0 then
		return false, { string.format("The following parts have a non-zero transparency: %s. Part transparency should always be exactly zero.", table.concat(t2, ", ")) }
	end

	return true, {}
end
local function validateAssetTransparency(p15, p16) -- line: 220
	-- upvalues: checkPartsTransparency (copy), BoundsCalculator (copy), getEditableMeshFromContext (copy), getExpectedPartSize (copy), getCombinedMeshData (copy), FailureReasonsAccumulator (copy), getViews (copy), ConstantsTransparencyValidation (copy), getScaleFactor (copy), RasterUtil (copy), getOpacity (copy), Analytics (copy)
	local assetTypeEnum = p16.assetTypeEnum
	local t3 = {}

	if p15:IsA("MeshPart") and p16.assetTypeEnum == Enum.AssetType.DynamicHead then
		table.insert(t3, p15)
	else
		assert(p15:IsA("Folder") and p16.assetTypeEnum ~= Enum.AssetType.DynamicHead, string.format("BodyPart %s is not in the correct format.", p15:GetFullName()))

		for _, child in p15:GetChildren() do
			assert(child:IsA("MeshPart"), string.format("BodyPart %s contained child that is not a MeshPart.", p15:GetFullName()))
			table.insert(t3, child)
		end
	end

	local v87, v88 = checkPartsTransparency(t3)

	if not v87 then
		return false, v88
	end

	local v89, v90, v91 = BoundsCalculator.calculateIndividualAssetPartsData(p15, p16)

	if not v89 then
		return false, v90
	end

	local t4 = {}
	local t5 = {
		min = Vector3.new(1e999, 1e999, 1e999),
		max = Vector3.new(-1e999, -1e999, -1e999)
	}

	for _, v95 in t3 do
		local v96, v97 = getEditableMeshFromContext(v95, "MeshId", p16)

		if not v96 then
			return false, { string.format("Failed to load mesh for MeshPart '%s'. Make sure mesh exists and try again.", v95.Name) }
		end

		v97:Triangulate()

		local v98 = getExpectedPartSize(v95, p16) / getExpectedPartSize(v95, p16, true)

		getCombinedMeshData(v97, t4, v91[v95.Name].cframe, t5, v98, p16)
	end

	if (t5.max - t5.min).Magnitude == 0 then
		return false, { string.format("Meshes %s should not have zero size", assetTypeEnum.Name) }
	end

	local v99 = FailureReasonsAccumulator.new()

	for _, v101 in (getViews()) do
		if #t4 == 0 then
			v99:updateReasons(false, { string.format("Mesh for %s has no triangles.", assetTypeEnum.Name) })
		else
			local v102 = t5.max - t5.min
			local v103 = t5.min + v102 / 2
			local v104 = Vector2.new(ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE, ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE) * getScaleFactor(v102, v101.viewId)
			local v105 = RasterUtil.rasterMesh(t4, v104, v101, v103, v102, p16)
			local v106 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[assetTypeEnum][v101.viewId]
			local v107, v108 = getOpacity(v105)

			if not v107 then
				v99:updateReasons(false, { string.format("Mesh for %s is completely invisible.", assetTypeEnum.Name) })
				v105:Destroy()
			else
				if v108 < v106 then
					v99:updateReasons(false, { string.format("%s is not opaque enough from the %s. Opacity is %.2f but needs to be above %.2f.", assetTypeEnum.Name, v101.viewId, v108, v106) })
				end

				v105:Destroy()
			end
		end
	end

	if not v99:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetTransparency_AssetTransparencyThresholds, nil, p16)
	end

	return v99:getFinalResults()
end

return validateAssetTransparency
