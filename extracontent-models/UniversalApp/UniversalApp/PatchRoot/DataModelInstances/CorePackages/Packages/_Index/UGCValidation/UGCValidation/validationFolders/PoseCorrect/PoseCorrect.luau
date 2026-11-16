local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local AssetCalculator = require(parent.util.AssetCalculator)
local canBeNormalized = require(parent.util.canBeNormalized)
local prettyPrintVector3 = require(parent.util.prettyPrintVector3)

local defineFastInt = game:DefineFastInt("UGCValidatePoseDegFromXYPlane", 20)

local defineFastInt2 = game:DefineFastInt("UGCValidatePoseArmMinDegFromXVectorOnXYPlane", -90)

local defineFastInt3 = game:DefineFastInt("UGCValidatePoseArmMaxDegFromXVectorOnXYPlane", 30)

local defineFastInt4 = game:DefineFastInt("UGCValidatePoseLegMinDegFromXVectorOnXYPlane", -93)

local defineFastInt5 = game:DefineFastInt("UGCValidatePoseLegMaxDegFromXVectorOnXYPlane", -60)

local PoseCorrect = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {}
}

local function validateAngleFromXYPlane(object, assetTypeFromUploadEnum, vector: Vector3, vector3: Vector3)
	local v = math.deg((math.acos((vector:Dot(vector3)))))

	if defineFastInt < v then
		object:fail(ErrorSourceStrings.Keys.Pose_AngleFromXYPlane, {
			assetName = assetTypeFromUploadEnum.Name,
			angle = string.format("%d", v),
			limit = string.format("%d", defineFastInt)
		})
	end
end

local function validateAngleFromWorldXVectorOnXYPlane(object, assetTypeFromUploadEnum, vector: Vector3, vector3: Vector3, p: number, p2: number)
	local v = math.deg((math.acos((vector:Dot(vector3)))))

	if not (vector.Y > 0) then
		v = -v
	end

	if v < p or p2 < v then
		object:fail(ErrorSourceStrings.Keys.Pose_AngleOnXYPlane, {
			assetName = assetTypeFromUploadEnum.Name,
			angle = string.format("%d", v),
			xVector = prettyPrintVector3(vector3),
			minAngle = string.format("%d", p),
			maxAngle = string.format("%d", p2)
		})
	end
end

local function getAssetTypeFromUploadEnum(p) -- 1 equivalent call inferred from this helper
	if p.uploadEnum and p.uploadEnum.assetType then
		return p.uploadEnum.assetType
	end

	return nil
end

function PoseCorrect.run(object, p)
	local rootInstance = p.rootInstance
	local assetTypeFromUploadEnum = getAssetTypeFromUploadEnum(p) -- inferred equivalent call

	if
		not assetTypeFromUploadEnum
		or assetTypeFromUploadEnum ~= Enum.AssetType.LeftArm
		and assetTypeFromUploadEnum ~= Enum.AssetType.RightArm
		and assetTypeFromUploadEnum ~= Enum.AssetType.LeftLeg
		and assetTypeFromUploadEnum ~= Enum.AssetType.RightLeg
	then
		return
	end

	local assetCFrame = AssetCalculator.calculateAssetCFrame(assetTypeFromUploadEnum, rootInstance)

	if not assetCFrame then
		object:fail(ErrorSourceStrings.Keys.Pose_CFrameCalculationFailed, {
			assetName = assetTypeFromUploadEnum.Name
		})

		return
	end

	local v = assetCFrame.YVector.Unit - Vector3.new(0, 0, 1) * assetCFrame.YVector.Unit:Dot(Vector3.new(0, 0, 1))

	if not canBeNormalized(v) then
		object:fail(ErrorSourceStrings.Keys.Pose_PointingAlongZVector, {
			assetName = assetTypeFromUploadEnum.Name
		})

		return
	end

	local v2 = -v.Unit
	validateAngleFromXYPlane(object, assetTypeFromUploadEnum, v2, -assetCFrame.YVector.Unit)

	local v3 = (assetTypeFromUploadEnum == Enum.AssetType.RightArm or assetTypeFromUploadEnum == Enum.AssetType.RightLeg)
		and Vector3.new(1, 0, 0)
		or -Vector3.new(1, 0, 0)
	local v4, v5

	if assetTypeFromUploadEnum == Enum.AssetType.RightArm or assetTypeFromUploadEnum == Enum.AssetType.LeftArm then
		v4 = defineFastInt2
		v5 = defineFastInt3
	else
		v4 = defineFastInt4
		v5 = defineFastInt5
	end

	validateAngleFromWorldXVectorOnXYPlane(object, assetTypeFromUploadEnum, v2, v3, v4, v5)
end

return PoseCorrect
