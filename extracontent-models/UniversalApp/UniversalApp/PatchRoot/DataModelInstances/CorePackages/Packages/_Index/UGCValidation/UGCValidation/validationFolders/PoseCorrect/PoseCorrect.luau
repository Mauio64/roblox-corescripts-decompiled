local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local AssetCalculator = require(ParentParent.util.AssetCalculator)
local canBeNormalized = require(ParentParent.util.canBeNormalized)
local prettyPrintVector3 = require(ParentParent.util.prettyPrintVector3)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)
local v8 = game:DefineFastInt("UGCValidatePoseDegFromXYPlane", 20)
local v9 = game:DefineFastInt("UGCValidatePoseArmMinDegFromXVectorOnXYPlane", -90)
local v10 = game:DefineFastInt("UGCValidatePoseArmMaxDegFromXVectorOnXYPlane", 30)
local v11 = game:DefineFastInt("UGCValidatePoseLegMinDegFromXVectorOnXYPlane", -93)
local v12 = game:DefineFastInt("UGCValidatePoseLegMaxDegFromXVectorOnXYPlane", -60)
local t1 = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigratePoseBlocking,
	expectedFailures = {}
}

local function validateAngleFromXYPlane(p1, p2, vector3: Vector3, vector3_2: Vector3) -- line: 42
	-- upvalues: v8 (copy), ErrorSourceStrings (copy)
	local v21 = math.deg((math.acos((vector3:Dot(vector3_2)))))

	if v21 > v8 then
		p1:fail(ErrorSourceStrings.Keys.Pose_AngleFromXYPlane, {
			assetName = p2.Name,
			angle = string.format("%d", v21),
			limit = string.format("%d", v8)
		})
	end
end
local function validateAngleFromWorldXVectorOnXYPlane(p3, p4, vector3: Vector3, vector3_3: Vector3, n1: number, n2: number) -- line: 58
	-- upvalues: ErrorSourceStrings (copy), prettyPrintVector3 (copy)
	local v28 = math.deg((math.acos((vector3:Dot(vector3_3)))))

	if not (vector3.Y > 0) then
		v28 = -v28
	end

	if v28 < n1 or n2 < v28 then
		p3:fail(ErrorSourceStrings.Keys.Pose_AngleOnXYPlane, {
			assetName = p4.Name,
			angle = string.format("%d", v28),
			xVector = prettyPrintVector3(vector3_3),
			minAngle = string.format("%d", n1),
			maxAngle = string.format("%d", n2)
		})
	end
end
local function getAssetTypeFromUploadEnum(p5) -- line: 80
	if p5.uploadEnum and p5.uploadEnum.assetType then
		return p5.uploadEnum.assetType
	end

	return nil
end

function t1.run(p6, p7) -- line: 87
	-- upvalues: AssetCalculator (copy), ErrorSourceStrings (copy), canBeNormalized (copy), validateAngleFromXYPlane (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), validateAngleFromWorldXVectorOnXYPlane (copy)
	local rootInstance = p7.rootInstance
	local v33 = if not p7.uploadEnum or not p7.uploadEnum.assetType then nil else p7.uploadEnum.assetType

	if not v33 then
		return
	end

	if v33 ~= Enum.AssetType.LeftArm and v33 ~= Enum.AssetType.RightArm and v33 ~= Enum.AssetType.LeftLeg and v33 ~= Enum.AssetType.RightLeg then
		return
	end

	local v34 = AssetCalculator.calculateAssetCFrame(v33, rootInstance)

	if not v34 then
		p6:fail(ErrorSourceStrings.Keys.Pose_CFrameCalculationFailed, {
			assetName = v33.Name
		})

		return
	end

	local v35 = v34.YVector.Unit - Vector3.new(0, 0, 1) * v34.YVector.Unit:Dot((Vector3.new(0, 0, 1)))

	if not canBeNormalized(v35) then
		p6:fail(ErrorSourceStrings.Keys.Pose_PointingAlongZVector, {
			assetName = v33.Name
		})

		return
	end

	local v36 = -v35.Unit
	local v37 = -v34.YVector.Unit

	validateAngleFromXYPlane(p6, v33, v36, v37)

	local v38 = if v33 ~= Enum.AssetType.RightArm and v33 ~= Enum.AssetType.RightLeg then Vector3.new(-1, -0, -0) else Vector3.new(1, 0, 0)
	local v39, v40

	if v33 == Enum.AssetType.RightArm or v33 == Enum.AssetType.LeftArm then
		v39 = v9
		v40 = v10
	else
		v39 = v11
		v40 = v12
	end

	validateAngleFromWorldXVectorOnXYPlane(p6, v33, v36, v38, v39, v40)
end

return t1
