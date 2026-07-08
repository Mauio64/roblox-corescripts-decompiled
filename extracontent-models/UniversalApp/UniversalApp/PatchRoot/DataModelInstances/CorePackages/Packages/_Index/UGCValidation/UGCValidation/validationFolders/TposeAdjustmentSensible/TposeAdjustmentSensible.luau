local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
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
local v12 = game:DefineFastInt("UGCValidationTposeShoulderDegreeOffsetThreshold", 30)
local v13 = game:DefineFastInt("UGCValidationTposeElbowDegreeOffsetThreshold", 30)
local v14 = game:DefineFastInt("UGCValidationTposeWristDegreeOffsetThreshold", 30)
local v15 = game:DefineFastInt("UGCValidationTposeClavicleDegreeOffsetThreshold", 30)
local v16 = game:DefineFastInt("UGCValidationTposeFingerDegreeOffsetThreshold", 30)
local v17 = game:DefineFastInt("UGCValidationTposeGeneralDegreeOffsetThreshold", 30)
local v18 = game:DefineFastInt("UGCValidationTposePositionOffsetPercentThreshold", 40) / 100
local t2 = {
	[Enum.RigLabel.LeftShoulder] = v12,
	[Enum.RigLabel.RightShoulder] = v12,
	[Enum.RigLabel.LeftElbow] = v13,
	[Enum.RigLabel.RightElbow] = v13,
	[Enum.RigLabel.LeftWrist] = v14,
	[Enum.RigLabel.RightWrist] = v14,
	[Enum.RigLabel.LeftClavicle] = v15,
	[Enum.RigLabel.RightClavicle] = v15
}

local function checkJointTposeAdjustment(p1, p2, cFrame: CFrame, p3, vector3: Vector3, n1: number) -- line: 44
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

function t1.run(p4, p5) -- line: 71
	-- upvalues: getAllInstancesIsA (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), v18 (copy), checkJointTposeAdjustment (copy), t2 (copy), v17 (copy), v16 (copy)
	local rootInstance = p5.rootInstance

	for _, v32 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local HumanoidRigDescription = v32:FindFirstChildWhichIsA("HumanoidRigDescription")

		if HumanoidRigDescription ~= nil then
			if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
				p4:setReportingInstance(v32)
			end

			local v34 = p5.renderMeshesData[v32.Name]
			local v35 = v34.originalSize * v34.scale * v18

			for _, v37 in (HumanoidRigDescription:GetContainedJointLabels(v32.Name)) do
				if HumanoidRigDescription:GetJoint(v37) then
					checkJointTposeAdjustment(p4, v37, HumanoidRigDescription:GetTposeAdjustment(v37), rootInstance, v35, t2[v37] or v17)
				end
			end

			local DigitsRigDescription = v32:FindFirstChildWhichIsA("DigitsRigDescription")

			if DigitsRigDescription ~= nil then
				for _, v40 in DigitsRigDescription:GetJointLabels() do
					if DigitsRigDescription:GetJoint(v40) then
						checkJointTposeAdjustment(p4, v40, DigitsRigDescription:GetTposeAdjustment(v40), rootInstance, v35, t2[v40] or v16)
					end
				end
			end
		end
	end
end

return t1
