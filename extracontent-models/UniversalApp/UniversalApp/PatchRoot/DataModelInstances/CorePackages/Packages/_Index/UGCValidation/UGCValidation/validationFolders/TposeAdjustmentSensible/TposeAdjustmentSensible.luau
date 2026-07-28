local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local valueToString = require(ParentParent.util.valueToString)
local CFrameUtils = require(ParentParent.util.CFrameUtils)
local getDiffBetweenOrientations = require(ParentParent.util.getDiffBetweenOrientations)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidateTPoseAdjustment)
}
local UGCValidationService = game:GetService("UGCValidationService")
local v11 = game:DefineFastInt("UGCValidationTposeShoulderDegreeOffsetThreshold", 30)
local v12 = game:DefineFastInt("UGCValidationTposeElbowDegreeOffsetThreshold", 30)
local v13 = game:DefineFastInt("UGCValidationTposeWristDegreeOffsetThreshold", 30)
local v14 = game:DefineFastInt("UGCValidationTposeClavicleDegreeOffsetThreshold", 30)
local v15 = game:DefineFastInt("UGCValidationTposeFingerDegreeOffsetThreshold", 30)
local v16 = game:DefineFastInt("UGCValidationTposeGeneralDegreeOffsetThreshold", 30)
local v17 = game:DefineFastInt("UGCValidationTposePositionOffsetPercentThreshold", 40) / 100
local t2 = {
	[Enum.RigLabel.LeftShoulder] = v11,
	[Enum.RigLabel.RightShoulder] = v11,
	[Enum.RigLabel.LeftElbow] = v12,
	[Enum.RigLabel.RightElbow] = v12,
	[Enum.RigLabel.LeftWrist] = v13,
	[Enum.RigLabel.RightWrist] = v13,
	[Enum.RigLabel.LeftClavicle] = v14,
	[Enum.RigLabel.RightClavicle] = v14
}

local function checkJointTposeAdjustment(p1, p2, cFrame: CFrame, p3, vector3: Vector3, n1: number) -- line: 42
	-- upvalues: UGCValidationService (copy), getDiffBetweenOrientations (copy), ErrorSourceStrings (copy), CFrameUtils (copy), Vector3Utils (copy), valueToString (copy)
	local ExpectedTposeRotation = UGCValidationService:GetExpectedTposeRotation(p2, p3)

	if n1 < getDiffBetweenOrientations(cFrame.Rotation, ExpectedTposeRotation) then
		p1:fail(ErrorSourceStrings.Keys.HrdTposeRotation, {
			jointName = p2.Name,
			degLimit = n1,
			expectedOrientation = CFrameUtils.getRotationString(ExpectedTposeRotation)
		})
	end

	if not Vector3Utils.isInRange(cFrame.Position, vector3 * -1, vector3) then
		p1:fail(ErrorSourceStrings.Keys.HrdTposePosition, {
			jointName = p2.Name,
			offsetLimit = valueToString(vector3)
		})
	end
end

function t1.run(p4, p5) -- line: 69
	-- upvalues: getAllInstancesIsA (copy), v17 (copy), checkJointTposeAdjustment (copy), t2 (copy), v16 (copy), v15 (copy)
	local rootInstance = p5.rootInstance

	for _, v31 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local HumanoidRigDescription = v31:FindFirstChildWhichIsA("HumanoidRigDescription")

		if HumanoidRigDescription ~= nil then
			p4:setReportingInstance(v31)

			local v33 = p5.renderMeshesData[v31.Name]
			local v34 = v33.originalSize * v33.scale * v17

			for _, v36 in (HumanoidRigDescription:GetContainedJointLabels(v31.Name)) do
				if HumanoidRigDescription:GetJoint(v36) then
					checkJointTposeAdjustment(p4, v36, HumanoidRigDescription:GetTposeAdjustment(v36), rootInstance, v34, t2[v36] or v16)
				end
			end

			local DigitsRigDescription = v31:FindFirstChildWhichIsA("DigitsRigDescription")

			if DigitsRigDescription ~= nil then
				for _, v39 in DigitsRigDescription:GetJointLabels() do
					if DigitsRigDescription:GetJoint(v39) then
						checkJointTposeAdjustment(p4, v39, DigitsRigDescription:GetTposeAdjustment(v39), rootInstance, v34, t2[v39] or v15)
					end
				end
			end
		end
	end
end

return t1
