local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(parent.util.BoundsCalculator)

local AssetBoundsValid = {}

AssetBoundsValid.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD,
	ValidationEnums.UploadCategory.FULL_BODY
}

AssetBoundsValid.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadEnum
}

AssetBoundsValid.conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData }

AssetBoundsValid.expectedFailures = {}

local function getScaleTypeFromInstance(instance) -- 2 equivalent calls inferred from this helper
	local avatarPartScaleType = instance:FindFirstChild("AvatarPartScaleType")

	if avatarPartScaleType and Constants.AvatarPartScaleTypes[avatarPartScaleType.Value] then
		return avatarPartScaleType.Value
	end

	return nil
end

local function getConsistentScaleType(rootInstance, assetType, object)
	local v = Constants.ASSET_TYPE_INFO[assetType]
	local v2 = nil

	if Enum.AssetType.DynamicHead == assetType then
		return getScaleTypeFromInstance(rootInstance) -- inferred equivalent call
	end

	for childName in pairs(v.subParts) do
		local child = rootInstance:FindFirstChild(childName)

		if not child then
			continue
		end

		local scaleTypeFromInstance = getScaleTypeFromInstance(child) -- inferred equivalent call

		if not scaleTypeFromInstance then
			continue
		end

		if v2 == nil then
			v2 = scaleTypeFromInstance
		elseif v2 ~= scaleTypeFromInstance then
			object:fail(ErrorSourceStrings.Keys.AssetBounds_InconsistentScaleType, nil, rootInstance)
			return nil
		end
	end

	return v2
end

local function validateMinBounds(minSize: Vector3, assetName: string, p, object, rootInstance)
	local v = p.maxMeshCorner - p.minMeshCorner

	for _, axis in { "X", "Y", "Z" } do
		local v2 = v[axis]
		local v3 = minSize[axis]

		if v2 < v3 then
			object:fail(
				ErrorSourceStrings.Keys.AssetBounds_TooSmall,
				{
					assetName = assetName,
					axis = axis,
					currentSize = string.format("%.2f", v2),
					minSize = string.format("%.2f", v3)
				},
				rootInstance
			)
		end
	end
end

local function validateMaxBounds(maxSize: Vector3, assetName: string, p, object, rootInstance)
	local v = p.maxOverall - p.minOverall

	for _, axis in { "X", "Y", "Z" } do
		local v2 = v[axis]
		local v3 = maxSize[axis]

		if v3 < v2 then
			object:fail(
				ErrorSourceStrings.Keys.AssetBounds_TooLarge,
				{
					assetName = assetName,
					axis = axis,
					currentSize = string.format("%.2f", v2),
					maxSize = string.format("%.2f", v3)
				},
				rootInstance
			)
		end
	end
end

local function createAllBodyPartsFromRootInstance(rootInstance)
	local partsByName = {}

	for _, part in rootInstance:GetChildren() do
		if part:IsA("MeshPart") then
			partsByName[part.Name] = part
		end
	end

	return partsByName
end

local function getFullBodyConsistentScaleType(allBodyPartsFromRootInstance, object, rootInstance)
	local v = nil

	for _, item in allBodyPartsFromRootInstance do
		local avatarPartScaleType = item:FindFirstChild("AvatarPartScaleType")

		if not avatarPartScaleType then
			continue
		end

		if not Constants.AvatarPartScaleTypes[avatarPartScaleType.Value] then
			object:fail(ErrorSourceStrings.Keys.ScaleTypeInvalid, { ParentName = item.Name }, item)

			return nil
		end

		local value = avatarPartScaleType.Value

		if v == nil then
			v = value
		elseif v ~= value then
			object:fail(ErrorSourceStrings.Keys.AssetBounds_InconsistentScaleType, nil, rootInstance)
			return nil
		end
	end

	return v
end

function AssetBoundsValid.run(object, data)
	local rootInstance = data.rootInstance
	local renderMeshesData = data.renderMeshesData

	if data.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
		if not renderMeshesData then
			return
		end

		local allBodyPartsFromRootInstance = createAllBodyPartsFromRootInstance(rootInstance)

		if not next(allBodyPartsFromRootInstance) then
			return
		end

		local fullBodyConsistentScaleType = getFullBodyConsistentScaleType(
			allBodyPartsFromRootInstance,
			object,
			rootInstance
		)

		if not fullBodyConsistentScaleType then
			return
		end

		local v = Constants.FULL_BODY_BOUNDS[fullBodyConsistentScaleType]

		if not v then
			return
		end

		local fullBodyBoundsFromData, _, v2 = BoundsCalculator.calculateFullBodyBoundsFromData(
			allBodyPartsFromRootInstance,
			renderMeshesData
		)

		if not fullBodyBoundsFromData then
			object:fetchError("Failed to calculate full body bounds")
			return
		end

		validateMinBounds(v.minSize, "Full body", v2, object, rootInstance)
		validateMaxBounds(v.maxSize, "Full body", v2, object, rootInstance)
	else
		local assetType = data.uploadEnum.assetType

		local consistentScaleType = getConsistentScaleType(rootInstance, assetType, object)

		if not consistentScaleType then
			return
		end

		local v = Constants.ASSET_TYPE_INFO[assetType]

		if not (v and v.bounds and v.bounds[consistentScaleType] and renderMeshesData) then
			return
		end

		local assetBoundsFromData, _, v2 = BoundsCalculator.calculateAssetBoundsFromData(
			rootInstance,
			assetType,
			renderMeshesData
		)

		if not assetBoundsFromData then
			object:fetchError("Failed to calculate asset bounds for " .. assetType.Name)
			return
		end

		local name = assetType.Name
		validateMinBounds(v.bounds[consistentScaleType].minSize, name, v2, object, rootInstance)
		validateMaxBounds(v.bounds[consistentScaleType].maxSize, name, v2, object, rootInstance)
	end
end

return AssetBoundsValid
