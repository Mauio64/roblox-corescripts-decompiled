local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local RasterUtil = require(ParentParent.util.RasterUtil)
local TransparencyUtil = require(ParentParent.util.TransparencyUtil)
local tryYield = require(ParentParent.util.tryYield)
local ConstantsTransparencyValidation = require(ParentParent.ConstantsTransparencyValidation)
local getFFlagUGCValidateMigrateTextureTransparency = require(ParentParent.flags.getFFlagUGCValidateMigrateTextureTransparency)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = getFFlagUGCValidateMigrateTextureTransparency,
	expectedFailures = {}
}

local function getViews() -- line: 31
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
local function getAspectRatio(vector3: Vector3, s1: string) -- line: 72
	-- upvalues: ConstantsTransparencyValidation (copy)
	if s1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Front or s1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Back then
		return vector3.X / vector3.Y
	end

	if s1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Left or s1 == ConstantsTransparencyValidation.CAMERA_ANGLES.Right then
		return vector3.Z / vector3.Y
	end

	return vector3.X / vector3.Z
end
local function getScaleFactor(vector3: Vector3, s2: string) -- line: 88
	-- upvalues: ConstantsTransparencyValidation (copy)
	local v22 = if s2 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Front and s2 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Back then if s2 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Left and s2 ~= ConstantsTransparencyValidation.CAMERA_ANGLES.Right then vector3.X / vector3.Z else vector3.Z / vector3.Y else vector3.X / vector3.Y
	local v23, ASSET_TRANSPARENCY_RASTER_SIZE

	if v22 > 1 then
		v23 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE / v22
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	elseif v22 < 1 then
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE * v22
		v23 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	else
		ASSET_TRANSPARENCY_RASTER_SIZE = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
		v23 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	end

	local vector2 = Vector2.new(ASSET_TRANSPARENCY_RASTER_SIZE / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE, v23 / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE)
	local v26 = math.max(vector2.X, vector2.Y)

	if v26 > 1 then
		return vector2 / v26
	end

	return vector2
end
local function addTransformedTriangle(p1, p2, p3, cFrame: CFrame, vector3: Vector3) -- line: 115
	-- upvalues: TransparencyUtil (copy)
	local t2 = {
		orderedVerts = {}
	}
	local FaceVertices = p1:GetFaceVertices(p3)
	local Position = p1:GetPosition(FaceVertices[1])
	local Position2 = p1:GetPosition(FaceVertices[2])
	local Position3 = p1:GetPosition(FaceVertices[3])
	local v37, v38, v39, v40 = TransparencyUtil.transformTriangleToWorld(Position, Position2, Position3, cFrame, vector3)

	table.insert(t2.orderedVerts, v37)
	table.insert(t2.orderedVerts, v38)
	table.insert(t2.orderedVerts, v39)
	t2.normal = v40
	table.insert(p2, t2)

	return t2
end
local function updateMinMaxBounds(p4, p5) -- line: 138
	local minX = p4.min.X
	local maxX = p4.max.X
	local minY = p4.min.Y
	local maxY = p4.max.Y
	local minZ = p4.min.Z
	local maxZ = p4.max.Z
	local v49 = p5.orderedVerts[1]
	local v50 = p5.orderedVerts[2]
	local v51 = p5.orderedVerts[3]
	local v52 = math.min(v49.X, v50.X, v51.X, minX)
	local v53 = math.max(v49.X, v50.X, v51.X, maxX)
	local v54 = math.min(v49.Y, v50.Y, v51.Y, minY)
	local v55 = math.max(v49.Y, v50.Y, v51.Y, maxY)
	local v56 = math.min(v49.Z, v50.Z, v51.Z, minZ)
	local v57 = math.max(v49.Z, v50.Z, v51.Z, maxZ)

	p4.min = Vector3.new(v52, v54, v56)
	p4.max = Vector3.new(v53, v55, v57)
end
local function getOpacity(p6) -- line: 161
	local v59 = p6:ReadPixelsBuffer(Vector2.new(0, 0), p6.Size)
	local n1 = 0
	local n2 = 0

	for i = 0, buffer.len(v59) - 1, 4 do
		local v63 = buffer.readu8(v59, i)
		local v64 = buffer.readu8(v59, i + 1)
		local v65 = buffer.readu8(v59, i + 2)

		if v63 == 0 and v64 == 0 and v65 == 0 then
			n2 += 1
		end

		n1 += 1
	end

	if n1 == 0 then
		return false, 0
	end

	return true, 1 - n2 / n1
end

local t3 = {
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}

function t1.run(p7, p8) -- line: 191
	-- upvalues: ValidationEnums (copy), ErrorSourceStrings (copy), AssetCalculator (copy), t3 (copy), addTransformedTriangle (copy), updateMinMaxBounds (copy), tryYield (copy), getViews (copy), ConstantsTransparencyValidation (copy), getScaleFactor (copy), RasterUtil (copy), getOpacity (copy)
	local rootInstance = p8.rootInstance
	local assetType = p8.uploadEnum.assetType
	local renderMeshesData = p8.renderMeshesData
	local t4 = {
		shouldYield = p8.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.Backend,
		lastTickSeconds = tick()
	}
	local t5 = {}

	if rootInstance:IsA("MeshPart") and assetType == Enum.AssetType.DynamicHead then
		table.insert(t5, rootInstance)
	else
		for _, child in rootInstance:GetChildren() do
			if child:IsA("MeshPart") then
				table.insert(t5, child)
			end
		end
	end

	local t6 = {}

	for _, v77 in t5 do
		if v77.Transparency ~= 0 then
			table.insert(t6, v77.Name)
		end
	end

	if #t6 > 0 then
		for _, v79 in t6 do
			p7:fail(ErrorSourceStrings.Keys.AssetOpacity_NonZeroTransparency, {
				PartName = v79
			})
		end

		return
	end

	local v80 = AssetCalculator.calculateAllTransformsForAsset(assetType, rootInstance)

	if t3[assetType] then
		local function findMeshHandle(s3: string) -- line: 236
			-- upvalues: rootInstance (copy)
			return (rootInstance:FindFirstChild(s3))
		end

		for v82, v83 in (AssetCalculator.calculateStraightenedLimb(assetType, v80, findMeshHandle)) do
			v80[v82] = v83
		end
	end

	local t7 = {}
	local t8 = {
		min = Vector3.new(1e999, 1e999, 1e999),
		max = Vector3.new(-1e999, -1e999, -1e999)
	}

	for _, v87 in t5 do
		local v88 = renderMeshesData[v87.Name]

		if not v88 then
			p7:fail(ErrorSourceStrings.Keys.AssetOpacity_MeshLoadFailed, {
				PartName = v87.Name
			})

			return
		end

		local editable = v88.editable

		editable:Triangulate()

		local v90 = v87.Size / v87.MeshSize
		local v91 = v80[v87.Name] or CFrame.new()

		for _, v93 in (editable:GetFaces()) do
			local v94 = addTransformedTriangle(editable, t7, v93, v91, v90)

			updateMinMaxBounds(t8, v94)
			tryYield(t4)
		end
	end

	if (t8.max - t8.min).Magnitude == 0 then
		p7:fail(ErrorSourceStrings.Keys.AssetOpacity_ZeroSize, {
			AssetName = assetType.Name
		})

		return
	end

	for _, v96 in (getViews()) do
		if #t7 == 0 then
			p7:fail(ErrorSourceStrings.Keys.AssetOpacity_NoTriangles, {
				AssetName = assetType.Name
			})
		else
			local v97 = t8.max - t8.min
			local v98 = t8.min + v97 / 2
			local v99 = Vector2.new(ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE, ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE) * getScaleFactor(v97, v96.viewId)
			local v100 = RasterUtil.rasterMesh(t7, v99, v96, v98, v97, t4)
			local v101 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[assetType][v96.viewId]
			local v102, v103 = getOpacity(v100)

			if not v102 then
				p7:fail(ErrorSourceStrings.Keys.AssetOpacity_Invisible, {
					AssetName = assetType.Name
				})
				v100:Destroy()
			else
				if v103 < v101 then
					p7:fail(ErrorSourceStrings.Keys.AssetOpacity_BelowThreshold, {
						AssetName = assetType.Name,
						ViewName = v96.viewId,
						Opacity = string.format("%.2f", v103),
						Threshold = string.format("%.2f", v101)
					})
				end

				v100:Destroy()
			end
		end
	end
end

return t1
