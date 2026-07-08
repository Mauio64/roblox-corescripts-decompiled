local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local validateScaleType = require(ParentParent.validation.validateScaleType)

local function forEachMeshPart(p1, p2, p3, p4: ((...any) -> ...any)) -- line: 16
	-- upvalues: Constants (copy)
	local v16 = p2 and p3

	assert(p1 ~= nil ~= (v16 ~= nil))

	if p1 then
		for _, v18 in p1 do
			if not p4(v18) then
				return false
			end
		end
	else
		local v19 = Constants.ASSET_TYPE_INFO[p3]

		assert(v19)

		if p3 == Enum.AssetType.DynamicHead then
			return p4(p2)
		end

		for k in pairs(v19.subParts) do
			local k2 = p2:FindFirstChild(k)

			assert(k2)

			if not p4(k2) then
				return false
			end
		end
	end

	return true
end
local function getScaleType(p5, p6, p7, p8) -- line: 50
	-- upvalues: forEachMeshPart (copy), Analytics (copy), validateScaleType (copy)
	local v26 = p6 and p7

	assert(p5 ~= nil ~= (v26 ~= nil))

	local u27 = nil

	if not forEachMeshPart(p5, p6, p7, function(p9) -- line: 60
		-- upvalues: u27 (ref)
		local AvatarPartScaleType = p9:FindFirstChild("AvatarPartScaleType")

		assert(AvatarPartScaleType)

		if not u27 then
			u27 = AvatarPartScaleType

			return true
		end

		return u27.Value == AvatarPartScaleType.Value
	end) then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetBounds_InconsistentAvatarPartScaleType, nil, p8)

		return false, { "All MeshParts must have the same value in their AvatarPartScaleType child. Please verify the values match." }, nil
	end

	local v28, v29 = validateScaleType(u27, p8)

	return v28, v29, if not v28 then nil else u27.Value
end
local function validateMinBoundsInternal(vector3: Vector3, p10, p11, p12) -- line: 88
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy)
	local v34 = FailureReasonsAccumulator.new()
	local v35 = false
	local v36 = p11.maxMeshCorner - p11.minMeshCorner

	for _, v38 in {
		"X",
		"Y",
		"Z"
	} do
		local v39 = v36[v38]
		local v40 = vector3[v38]
		local v41 = v40 <= v39

		if not v41 and not v35 then
			Analytics.reportFailure(Analytics.ErrorType.validateAssetBounds_AssetSizeTooSmall, nil, p12)
			v35 = true
		end

		v34:updateReasons(v41, { string.format("%s meshes %s axis size of '%.2f' is smaller than the min allowed bounding box %s axis size of '%.2f'. You need to scale up the meshes.", not p10 and "Full body" or p10.Name, v38, v39, v38, v40) })
	end

	return v34:getFinalResults()
end
local function validateMaxBoundsInternal(vector3: Vector3, p13, p14, p15) -- line: 126
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy)
	local v46 = FailureReasonsAccumulator.new()
	local v47 = false
	local v48 = p14.maxOverall - p14.minOverall

	for _, v50 in {
		"X",
		"Y",
		"Z"
	} do
		local v51 = v48[v50]
		local v52 = vector3[v50]
		local v53 = v51 <= v52

		if not v53 and not v47 then
			Analytics.reportFailure(Analytics.ErrorType.validateAssetBounds_AssetSizeTooBig, nil, p15)
			v47 = true
		end

		v46:updateReasons(v53, { string.format("%s meshes and joints %s axis size of '%.2f' is larger than the max allowed bounding box %s axis size of '%.2f'. You need to scale down the meshes/joints", not p13 and "Full body" or p13.Name, v50, v51, v50, v52) })
	end

	return v46:getFinalResults()
end
local function validateAssetBounds(p16, p17, p18) -- line: 164
	-- upvalues: BoundsCalculator (copy), getScaleType (copy), FailureReasonsAccumulator (copy), Constants (copy), validateMinBoundsInternal (copy), validateMaxBoundsInternal (copy), Analytics (copy)
	local timestamp = tick()
	local assetTypeEnum = p18.assetTypeEnum
	local v59 = p17 and assetTypeEnum

	assert(p16 ~= nil ~= (v59 ~= nil))

	local v60, v61, v62

	if p16 then
		v60, v61, v62 = BoundsCalculator.calculateFullBodyBounds(p16, p18)
	else
		v60, v61, v62 = BoundsCalculator.calculateAssetBounds(p17, p18)
	end

	if not v60 then
		return v60, v61
	end

	local v63, v64, v65 = getScaleType(p16, p17, assetTypeEnum, p18)

	if not v63 then
		return v63, v64
	end

	local v66 = FailureReasonsAccumulator.new()
	local minSize, maxSize

	if p16 then
		minSize = Constants.FULL_BODY_BOUNDS[v65].minSize
		maxSize = Constants.FULL_BODY_BOUNDS[v65].maxSize
	else
		minSize = Constants.ASSET_TYPE_INFO[assetTypeEnum].bounds[v65].minSize
		maxSize = Constants.ASSET_TYPE_INFO[assetTypeEnum].bounds[v65].maxSize
	end

	v66:updateReasons(validateMinBoundsInternal(minSize, assetTypeEnum, v62, p18))
	v66:updateReasons(validateMaxBoundsInternal(maxSize, assetTypeEnum, v62, p18))
	Analytics.recordScriptTime(script.Name, timestamp, p18)

	return v66:getFinalResults()
end

return validateAssetBounds
