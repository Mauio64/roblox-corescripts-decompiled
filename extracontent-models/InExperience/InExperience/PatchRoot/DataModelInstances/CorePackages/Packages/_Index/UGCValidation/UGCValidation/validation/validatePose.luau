local ParentParent = script.Parent.Parent
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local canBeNormalized = require(ParentParent.util.canBeNormalized)
local prettyPrintVector3 = require(ParentParent.util.prettyPrintVector3)

require(ParentParent.util.Types)

local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local v6 = game:DefineFastInt("UGCValidatePoseDegFromXYPlane", 20)
local v7 = game:DefineFastInt("UGCValidatePoseArmMinDegFromXVectorOnXYPlane", -90)
local v8 = game:DefineFastInt("UGCValidatePoseArmMaxDegFromXVectorOnXYPlane", 30)
local v9 = game:DefineFastInt("UGCValidatePoseLegMinDegFromXVectorOnXYPlane", -93)
local v10 = game:DefineFastInt("UGCValidatePoseLegMaxDegFromXVectorOnXYPlane", -60)

local function validateAngleFromXYPlane(p1, vector3: Vector3, vector3_2: Vector3) -- line: 24
	-- upvalues: FailureReasonsAccumulator (copy), v6 (copy)
	local v17 = FailureReasonsAccumulator.new()
	local v18 = math.deg((math.acos((vector3:Dot(vector3_2)))))

	if v18 > v6 then
		v17:updateReasons(false, { string.format("%s is at a %d degree angle from the X,Y plane, it must be within %d degrees. Make sure the character is in I pose, A pose, or T pose", p1.Name, v18, v6) })
	end

	return v17:getFinalResults()
end
local function validateAngleFromWorldXVectorOnXYPlane(p2, vector3: Vector3, vector3_3: Vector3, n1: number, n2: number) -- line: 45
	-- upvalues: FailureReasonsAccumulator (copy), prettyPrintVector3 (copy)
	local v24 = math.deg((math.acos((vector3:Dot(vector3_3)))))

	if not (vector3.Y > 0) then
		v24 = -v24
	end

	local v25 = FailureReasonsAccumulator.new()

	if v24 < n1 or n2 < v24 then
		v25:updateReasons(false, { string.format("%s is at a %d angle of the [%s] vector on the X,Y plane, it must be between %d and %d degrees. Make sure the character is in I pose, A pose, or T pose", p2.Name, v24, prettyPrintVector3(vector3_3), n1, n2) })
	end

	return v25:getFinalResults()
end
local function validatePose(p3, p4) -- line: 72
	-- upvalues: AssetCalculator (copy), canBeNormalized (copy), FailureReasonsAccumulator (copy), validateAngleFromXYPlane (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), validateAngleFromWorldXVectorOnXYPlane (copy)
	local assetTypeEnum = p4.assetTypeEnum

	assert(assetTypeEnum)

	if assetTypeEnum ~= Enum.AssetType.LeftArm and assetTypeEnum ~= Enum.AssetType.RightArm and assetTypeEnum ~= Enum.AssetType.LeftLeg and assetTypeEnum ~= Enum.AssetType.RightLeg then
		return true
	end

	local v29 = AssetCalculator.calculateAssetCFrame(assetTypeEnum, p3)

	if not v29 then
		return false, { string.format("Failed to calculate %s asset CFrame. Make sure the character is in I pose, A pose, or T pose, and the parts are not all in the same position", assetTypeEnum.Name) }
	end

	local v30 = v29.YVector.Unit - Vector3.new(0, 0, 1) * v29.YVector.Unit:Dot((Vector3.new(0, 0, 1)))

	if not canBeNormalized(v30) then
		return false, { string.format("%s is pointing along the world Z vector. Make sure the character is in I pose, A pose, or T pose", assetTypeEnum.Name) }
	end

	local v31 = -v30.Unit
	local v32 = -v29.YVector.Unit
	local v33 = FailureReasonsAccumulator.new()

	v33:updateReasons(validateAngleFromXYPlane(assetTypeEnum, v31, v32))

	local v34 = if assetTypeEnum ~= Enum.AssetType.RightArm and assetTypeEnum ~= Enum.AssetType.RightLeg then Vector3.new(-1, -0, -0) else Vector3.new(1, 0, 0)
	local v35, v36

	if assetTypeEnum == Enum.AssetType.RightArm or assetTypeEnum == Enum.AssetType.LeftArm then
		v35 = v7
		v36 = v8
	else
		v35 = v9
		v36 = v10
	end

	v33:updateReasons(validateAngleFromWorldXVectorOnXYPlane(assetTypeEnum, v31, v34, v35, v36))

	return v33:getFinalResults()
end

return validatePose
