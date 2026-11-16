local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)
local Vector3Utils = require(parent.util.Vector3Utils)
local valueToString = require(parent.util.valueToString)
local CFrameUtils = require(parent.util.CFrameUtils)
local getDiffBetweenOrientations = require(parent.util.getDiffBetweenOrientations)

local TposeAdjustmentSensible = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = require(parent.flags.getEngineFeatureEngineUGCValidateTPoseAdjustment)
}

local UGCValidationService = game:GetService("UGCValidationService")
local defineFastInt = game:DefineFastInt("UGCValidationTposeShoulderDegreeOffsetThreshold", 30)
local defineFastInt2 = game:DefineFastInt("UGCValidationTposeElbowDegreeOffsetThreshold", 30)
local defineFastInt3 = game:DefineFastInt("UGCValidationTposeWristDegreeOffsetThreshold", 30)
local defineFastInt4 = game:DefineFastInt("UGCValidationTposeClavicleDegreeOffsetThreshold", 30)
local defineFastInt5 = game:DefineFastInt("UGCValidationTposeFingerDegreeOffsetThreshold", 30)
local defineFastInt6 = game:DefineFastInt("UGCValidationTposeGeneralDegreeOffsetThreshold", 30)
local v = game:DefineFastInt("UGCValidationTposePositionOffsetPercentThreshold", 40) / 100

local defineFastInts = {
	[Enum.RigLabel.LeftShoulder] = defineFastInt,
	[Enum.RigLabel.RightShoulder] = defineFastInt,
	[Enum.RigLabel.LeftElbow] = defineFastInt2,
	[Enum.RigLabel.RightElbow] = defineFastInt2,
	[Enum.RigLabel.LeftWrist] = defineFastInt3,
	[Enum.RigLabel.RightWrist] = defineFastInt3,
	[Enum.RigLabel.LeftClavicle] = defineFastInt4,
	[Enum.RigLabel.RightClavicle] = defineFastInt4
}

local function checkJointTposeAdjustment(object, p, tposeAdjustment: CFrame, rootInstance, vector3: Vector3, degLimit: number)
	local expectedTposeRotation = UGCValidationService:GetExpectedTposeRotation(p, rootInstance)

	if degLimit < getDiffBetweenOrientations(tposeAdjustment.Rotation, expectedTposeRotation) then
		object:fail(ErrorSourceStrings.Keys.HrdTposeRotation, {
			jointName = p.Name,
			degLimit = degLimit,
			expectedOrientation = CFrameUtils.getRotationString(expectedTposeRotation)
		})
	end

	if not Vector3Utils.isInRange(tposeAdjustment.Position, vector3 * -1, vector3) then
		object:fail(ErrorSourceStrings.Keys.HrdTposePosition, {
			jointName = p.Name,
			offsetLimit = valueToString(vector3)
		})
	end
end

function TposeAdjustmentSensible.run(object, p)
	local rootInstance = p.rootInstance

	for _, v2 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local humanoidRigDescription = v2:FindFirstChildWhichIsA("HumanoidRigDescription")

		if humanoidRigDescription == nil then
			continue
		end

		object:setReportingInstance(v2)

		local v3 = p.renderMeshesData[v2.Name]
		local v4 = v3.originalSize * v3.scale * v
		local containedJointLabels = humanoidRigDescription:GetContainedJointLabels(v2.Name)

		for _, containedJointLabel in containedJointLabels do
			if humanoidRigDescription:GetJoint(containedJointLabel) then
				checkJointTposeAdjustment(
					object,
					containedJointLabel,
					humanoidRigDescription:GetTposeAdjustment(containedJointLabel),
					rootInstance,
					v4,
					defineFastInts[containedJointLabel] or defineFastInt6
				)
			end
		end

		local digitsRigDescription = v2:FindFirstChildWhichIsA("DigitsRigDescription")

		if digitsRigDescription == nil then
			continue
		end

		for _, v5 in digitsRigDescription:GetJointLabels() do
			if digitsRigDescription:GetJoint(v5) then
				checkJointTposeAdjustment(
					object,
					v5,
					digitsRigDescription:GetTposeAdjustment(v5),
					rootInstance,
					v4,
					defineFastInts[v5] or defineFastInt5
				)
			end
		end
	end
end
return TposeAdjustmentSensible
