local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local AssetCalculator = require(parent.util.AssetCalculator)
local RasterUtil = require(parent.util.RasterUtil)
local TransparencyUtil = require(parent.util.TransparencyUtil)
local tryYield = require(parent.util.tryYield)

local ConstantsTransparencyValidation = require(parent.ConstantsTransparencyValidation)

local AssetOpacityValid = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function getViews()
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

local function getAspectRatio(vector3: Vector3, p: string) -- 1 equivalent call inferred from this helper
	if
		p == ConstantsTransparencyValidation.CAMERA_ANGLES.Front
		or p == ConstantsTransparencyValidation.CAMERA_ANGLES.Back
	then
		return vector3.X / vector3.Y
	end

	if
		p == ConstantsTransparencyValidation.CAMERA_ANGLES.Left
		or p == ConstantsTransparencyValidation.CAMERA_ANGLES.Right
	then
		return vector3.Z / vector3.Y
	end

	return vector3.X / vector3.Z
end

local function getScaleFactor(vector3: Vector3, viewId: string)
	local aspectRatio = getAspectRatio(vector3, viewId) -- inferred equivalent call
	local v, v2

	if aspectRatio > 1 then
		v = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE / aspectRatio
		v2 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	else
		if aspectRatio < 1 then
			v2 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE * aspectRatio
		else
			v2 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
		end

		v = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	end

	local vector2 = Vector2.new(
		v2 / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE,
		v / ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
	)

	local v3 = math.max(vector2.X, vector2.Y)

	if v3 > 1 then
		return vector2 / v3
	end

	return vector2
end

local function addTransformedTriangle(editable, list, face, cframe: CFrame, vector3: Vector3)
	local v = { orderedVerts = {} }

	local faceVertices = editable:GetFaceVertices(face)

	local position = editable:GetPosition(faceVertices[1])
	local position2 = editable:GetPosition(faceVertices[2])
	local position3 = editable:GetPosition(faceVertices[3])

	local transformTriangleToWorld, v2, v3, normal = TransparencyUtil.transformTriangleToWorld(
		position,
		position2,
		position3,
		cframe,
		vector3
	)
	table.insert(v.orderedVerts, transformTriangleToWorld)
	table.insert(v.orderedVerts, v2)
	table.insert(v.orderedVerts, v3)
	v.normal = normal

	table.insert(list, v)

	return v
end

local function updateMinMaxBounds(state, p)
	local x = state.min.X
	local x2 = state.max.X
	local y = state.min.Y
	local y2 = state.max.Y
	local z = state.min.Z
	local z2 = state.max.Z

	local orderedVert = p.orderedVerts[1]
	local orderedVert2 = p.orderedVerts[2]
	local orderedVert3 = p.orderedVerts[3]

	local v = math.min(orderedVert.X, orderedVert2.X, orderedVert3.X, x)
	local v2 = math.max(orderedVert.X, orderedVert2.X, orderedVert3.X, x2)
	local v3 = math.min(orderedVert.Y, orderedVert2.Y, orderedVert3.Y, y)
	local v4 = math.max(orderedVert.Y, orderedVert2.Y, orderedVert3.Y, y2)
	local v5 = math.min(orderedVert.Z, orderedVert2.Z, orderedVert3.Z, z)
	local v6 = math.max(orderedVert.Z, orderedVert2.Z, orderedVert3.Z, z2)

	state.min = Vector3.new(v, v3, v5)
	state.max = Vector3.new(v2, v4, v6)
end

local function getOpacity(object)
	local pixelsBuffer = object:ReadPixelsBuffer(Vector2.new(0, 0), object.Size)
	local count = 0
	local count2 = 0

	for i = 0, buffer.len(pixelsBuffer) - 1, 4 do
		local v = buffer.readu8(pixelsBuffer, i)
		local v2 = buffer.readu8(pixelsBuffer, i + 1)
		local v3 = buffer.readu8(pixelsBuffer, i + 2)

		if v == 0 and v2 == 0 and v3 == 0 then
			count2 += 1
		end

		count += 1
	end

	if count == 0 then
		return false, 0
	end

	return true, 1 - count2 / count
end

local set = {
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}

function AssetOpacityValid.run(object, data)
	local rootInstance = data.rootInstance
	local assetType = data.uploadEnum.assetType
	local renderMeshesData = data.renderMeshesData
	local v = {
		shouldYield = data.consumerConfig.validationEnv ~= ValidationEnums.ValidationEnv.Backend,
		lastTickSeconds = tick()
	}

	local v2 = {}

	if rootInstance:IsA("MeshPart") and assetType == Enum.AssetType.DynamicHead then
		table.insert(v2, rootInstance)
	else
		for _, part in rootInstance:GetChildren() do
			if part:IsA("MeshPart") then
				table.insert(v2, part)
			end
		end
	end

	local names = {}

	for _, v3 in v2 do
		if v3.Transparency ~= 0 then
			table.insert(names, v3.Name)
		end
	end

	if #names > 0 then
		for _, partName in names do
			object:fail(ErrorSourceStrings.Keys.AssetOpacity_NonZeroTransparency, {
				PartName = partName
			})
		end
	else
		local allTransformsForAsset = AssetCalculator.calculateAllTransformsForAsset(assetType, rootInstance)

		if set[assetType] then
			local function findMeshHandle(childName: string)
				return (rootInstance:FindFirstChild(childName))
			end

			local straightenedLimb = AssetCalculator.calculateStraightenedLimb(
				assetType,
				allTransformsForAsset,
				findMeshHandle
			)

			for k, v3 in straightenedLimb do
				allTransformsForAsset[k] = v3
			end
		end

		local v3 = {}
		local v4 = {
			min = Vector3.new(1e999, 1e999, 1e999),
			max = Vector3.new(-1e999, -1e999, -1e999)
		}

		for _, v5 in v2 do
			local v6 = renderMeshesData[v5.Name]

			if not v6 then
				object:fail(ErrorSourceStrings.Keys.AssetOpacity_MeshLoadFailed, {
					PartName = v5.Name
				})

				return
			end

			local editable = v6.editable
			editable:Triangulate()

			local v7 = v5.Size / v5.MeshSize

			local v8 = allTransformsForAsset[v5.Name] or CFrame.new()
			local faces = editable:GetFaces()

			for _, face in faces do
				updateMinMaxBounds(v4, addTransformedTriangle(editable, v3, face, v8, v7))
				tryYield(v)
			end
		end

		if (v4.max - v4.min).Magnitude == 0 then
			object:fail(ErrorSourceStrings.Keys.AssetOpacity_ZeroSize, {
				AssetName = assetType.Name
			})

			return
		end

		local views = getViews()

		for _, view in views do
			if #v3 == 0 then
				object:fail(ErrorSourceStrings.Keys.AssetOpacity_NoTriangles, {
					AssetName = assetType.Name
				})
			else
				local v5 = v4.max - v4.min
				local v6 = v4.min + v5 / 2
				local v7 = Vector2.new(
					ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE,
					ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE
				) * getScaleFactor(v5, view.viewId)

				local rasterMesh = RasterUtil.rasterMesh(v3, v7, view, v6, v5, v)

				local v8 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[assetType][view.viewId]
				local opacity, v9 = getOpacity(rasterMesh)

				if opacity then
					if v9 < v8 then
						object:fail(ErrorSourceStrings.Keys.AssetOpacity_BelowThreshold, {
							AssetName = assetType.Name,
							ViewName = view.viewId,
							Opacity = string.format("%.2f", v9),
							Threshold = string.format("%.2f", v8)
						})
					end
				else
					object:fail(ErrorSourceStrings.Keys.AssetOpacity_Invisible, {
						AssetName = assetType.Name
					})
				end

				rasterMesh:Destroy()
			end
		end
	end
end

return AssetOpacityValid
