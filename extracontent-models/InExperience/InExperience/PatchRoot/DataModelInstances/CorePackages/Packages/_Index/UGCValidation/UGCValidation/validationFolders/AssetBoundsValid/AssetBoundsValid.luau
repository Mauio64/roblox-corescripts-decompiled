local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.FULL_BODY
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = getFFlagUGCValidateMigrateBodyPartBounds,
	expectedFailures = {}
}

local function getScaleTypeFromInstance(p1) -- line: 28
	-- upvalues: Constants (copy)
	local AvatarPartScaleType = p1:FindFirstChild("AvatarPartScaleType")

	if AvatarPartScaleType and Constants.AvatarPartScaleTypes[AvatarPartScaleType.Value] then
		return AvatarPartScaleType.Value
	end

	return nil
end
local function getConsistentScaleType(p2, p3, p4) -- line: 36
	-- upvalues: Constants (copy), ErrorSourceStrings (copy)
	local v19 = Constants.ASSET_TYPE_INFO[p3]
	local v20 = nil

	if p3 == Enum.AssetType.DynamicHead then
		local AvatarPartScaleType = p2:FindFirstChild("AvatarPartScaleType")

		if AvatarPartScaleType and Constants.AvatarPartScaleTypes[AvatarPartScaleType.Value] then
			return AvatarPartScaleType.Value
		end

		return nil
	end

	for k in pairs(v19.subParts) do
		local k2 = p2:FindFirstChild(k)

		if not k2 then
			continue
		end

		local AvatarPartScaleType = k2:FindFirstChild("AvatarPartScaleType")
		local v25 = if not AvatarPartScaleType or not Constants.AvatarPartScaleTypes[AvatarPartScaleType.Value] then nil else AvatarPartScaleType.Value

		if not v25 then
			continue
		end

		if v20 ~= nil then
			if v20 == v25 then
				continue
			end

			p4:fail(ErrorSourceStrings.Keys.AssetBounds_InconsistentScaleType, nil, p2)

			return nil
		end

		v20 = v25
	end

	return v20
end
local function validateMinBounds(vector3: Vector3, s1: string, p5, p6, p7) -- line: 67
	-- upvalues: ErrorSourceStrings (copy)
	local v31 = p5.maxMeshCorner - p5.minMeshCorner

	for _, v33 in {
		"X",
		"Y",
		"Z"
	} do
		local v34 = v31[v33]
		local v35 = vector3[v33]

		if v34 < v35 then
			p6:fail(ErrorSourceStrings.Keys.AssetBounds_TooSmall, {
				assetName = s1,
				axis = v33,
				currentSize = string.format("%.2f", v34),
				minSize = string.format("%.2f", v35)
			}, p7)
		end
	end
end
local function validateMaxBounds(vector3: Vector3, s2: string, p8, p9, p10) -- line: 89
	-- upvalues: ErrorSourceStrings (copy)
	local v41 = p8.maxOverall - p8.minOverall

	for _, v43 in {
		"X",
		"Y",
		"Z"
	} do
		local v44 = v41[v43]
		local v45 = vector3[v43]

		if v45 < v44 then
			p9:fail(ErrorSourceStrings.Keys.AssetBounds_TooLarge, {
				assetName = s2,
				axis = v43,
				currentSize = string.format("%.2f", v44),
				maxSize = string.format("%.2f", v45)
			}, p10)
		end
	end
end
local function createAllBodyPartsFromRootInstance(p11) -- line: 111
	local t2 = {}

	for _, child in p11:GetChildren() do
		if child:IsA("MeshPart") then
			t2[child.Name] = child
		end
	end

	return t2
end
local function getFullBodyConsistentScaleType(p12, p13, p14) -- line: 121
	-- upvalues: Constants (copy), ErrorSourceStrings (copy)
	local v53 = nil

	for _, v55 in p12 do
		local AvatarPartScaleType = v55:FindFirstChild("AvatarPartScaleType")

		if not AvatarPartScaleType then
			continue
		end

		if not Constants.AvatarPartScaleTypes[AvatarPartScaleType.Value] then
			p13:fail(ErrorSourceStrings.Keys.ScaleTypeInvalid, {
				ParentName = v55.Name
			}, v55)

			return nil
		end

		local AvatarPartScaleTypeValue = AvatarPartScaleType.Value

		if v53 ~= nil then
			if v53 == AvatarPartScaleTypeValue then
				continue
			end

			p13:fail(ErrorSourceStrings.Keys.AssetBounds_InconsistentScaleType, nil, p14)

			return nil
		end

		v53 = AvatarPartScaleTypeValue
	end

	return v53
end

function t1.run(p15, p16) -- line: 149
	-- upvalues: ValidationEnums (copy), createAllBodyPartsFromRootInstance (copy), getFullBodyConsistentScaleType (copy), Constants (copy), BoundsCalculator (copy), validateMinBounds (copy), validateMaxBounds (copy), getConsistentScaleType (copy)
	local rootInstance = p16.rootInstance
	local renderMeshesData = p16.renderMeshesData

	if p16.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
		if not renderMeshesData then
			return
		end

		local v62 = createAllBodyPartsFromRootInstance(rootInstance)

		if not next(v62) then
			return
		end

		local v63 = getFullBodyConsistentScaleType(v62, p15, rootInstance)

		if not v63 then
			return
		end

		local v64 = Constants.FULL_BODY_BOUNDS[v63]

		if not v64 then
			return
		end

		local v65, _, v67 = BoundsCalculator.calculateFullBodyBoundsFromData(v62, renderMeshesData)

		if not v65 then
			p15:fetchError("Failed to calculate full body bounds")

			return
		end

		validateMinBounds(v64.minSize, "Full body", v67, p15, rootInstance)
		validateMaxBounds(v64.maxSize, "Full body", v67, p15, rootInstance)

		return
	end

	local assetType = p16.uploadEnum.assetType
	local v69 = getConsistentScaleType(rootInstance, assetType, p15)

	if not v69 then
		return
	end

	local v70 = Constants.ASSET_TYPE_INFO[assetType]

	if not v70 or not v70.bounds or not v70.bounds[v69] then
		return
	end

	if not renderMeshesData then
		return
	end

	local v71, _, v73 = BoundsCalculator.calculateAssetBoundsFromData(rootInstance, assetType, renderMeshesData)

	if not v71 then
		p15:fetchError("Failed to calculate asset bounds for " .. assetType.Name)

		return
	end

	local assetTypeName = assetType.Name

	validateMinBounds(v70.bounds[v69].minSize, assetTypeName, v73, p15, rootInstance)
	validateMaxBounds(v70.bounds[v69].maxSize, assetTypeName, v73, p15, rootInstance)
end

return t1
