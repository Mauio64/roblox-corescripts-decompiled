local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local ValidationRulesUtil = require(parent.util.ValidationRulesUtil)

local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)
local R15plusUtils = require(parent.util.R15plusUtils)
local Vector3Utils = require(parent.util.Vector3Utils)
local valueToString = require(parent.util.valueToString)
local CFrameUtils = require(parent.util.CFrameUtils)
local HrdPropertiesSensible = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}

local v = game:DefineFastInt("UGCValidationHrdJointSizeHundredthsLimit", 150) / 100
local defineFastInt = game:DefineFastInt("UGCValidationHrdJointRangeMinXHundredths", 0)
local defineFastInt2 = game:DefineFastInt("UGCValidationHrdJointRangeMaxXHundredths", 0)
local defineFastInt3 = game:DefineFastInt("UGCValidationHrdJointRangeMinYHundredths", 0)
local defineFastInt4 = game:DefineFastInt("UGCValidationHrdJointRangeMaxYHundredths", 0)
local defineFastInt5 = game:DefineFastInt("UGCValidationHrdJointRangeMinZHundredths", 0)
local defineFastInt6 = game:DefineFastInt("UGCValidationHrdJointRangeMaxZHundredths", 0)
local defineFastInt7 = game:DefineFastInt("UGCValidationHrdOriginOffsetMinYHundredths", -500)
local defineFastInt8 = game:DefineFastInt("UGCValidationHrdOriginOffsetMaxYHundredths", 500)
local vector3 = Vector3.new(defineFastInt / 100, defineFastInt3 / 100, defineFastInt5 / 100)
local vector3_2 = Vector3.new(defineFastInt2 / 100, defineFastInt4 / 100, defineFastInt6 / 100)
local vector3_3 = Vector3.new(0, defineFastInt7 / 100, 0)
local vector3_4 = Vector3.new(0, defineFastInt8 / 100, 0)

local v2 = game:DefineFastInt("UGCValidationDrdJointSizeHundredthsLimit", 150) / 100
local defineFastInt9 = game:DefineFastInt("UGCValidationDrdJointRangeMinXHundredths", 0)
local defineFastInt10 = game:DefineFastInt("UGCValidationDrdJointRangeMaxXHundredths", 0)
local defineFastInt11 = game:DefineFastInt("UGCValidationDrdJointRangeMinYHundredths", 0)
local defineFastInt12 = game:DefineFastInt("UGCValidationDrdJointRangeMaxYHundredths", 0)
local defineFastInt13 = game:DefineFastInt("UGCValidationDrdJointRangeMinZHundredths", 0)
local defineFastInt14 = game:DefineFastInt("UGCValidationDrdJointRangeMaxZHundredths", 0)
local vector3_5 = Vector3.new(defineFastInt9 / 100, defineFastInt11 / 100, defineFastInt13 / 100)
local vector3_6 = Vector3.new(defineFastInt10 / 100, defineFastInt12 / 100, defineFastInt14 / 100)

local function checkVectorRange(object, jointName: string, propertyName: string, vector3_7: Vector3, vector3_8: Vector3, vector3_9: Vector3)
	if not Vector3Utils.isInRange(vector3_7, vector3_8, vector3_9) then
		object:fail(ErrorSourceStrings.Keys.HrdProperties_PropertyOutOfRange, {
			jointName = jointName,
			propertyName = propertyName,
			currentValue = valueToString(vector3_7),
			valueMin = valueToString(vector3_8),
			valueMax = valueToString(vector3_9)
		})
	end
end

local function checkSize(object, jointName: string, propertyName: string, p: number, p2: number)
	if p < 0 or p2 < p then
		object:fail(ErrorSourceStrings.Keys.HrdProperties_PropertyOutOfRange, {
			jointName = jointName,
			propertyName = propertyName,
			currentValue = valueToString(p),
			valueMin = "0",
			valueMax = valueToString(p2)
		})
	end
end

function HrdPropertiesSensible.run(object, p)
	for _, v3 in getAllInstancesIsA(p.rootInstance, "MeshPart") do
		local humanoidRigDescription = v3:FindFirstChildWhichIsA("HumanoidRigDescription")
		local rigAttachmentToParent = ValidationRulesUtil.rigAttachmentToParentMap[v3.Name]

		if humanoidRigDescription == nil then
			continue
		end

		object:setReportingInstance(humanoidRigDescription)

		local originOffset = humanoidRigDescription.OriginOffset

		if v3.Name == "LowerTorso" then
			if not (CFrameUtils.fuzzyEq(originOffset.Rotation, CFrame.identity) and Vector3Utils.isInRange(
				originOffset.Position,
				vector3_3,
				vector3_4
			)) then
				object:fail(ErrorSourceStrings.Keys.HrdProperties_OriginOutsideBounds, {
					valueMin = valueToString(vector3_3),
					valueMax = valueToString(vector3_4)
				})
			end
		elseif not CFrameUtils.fuzzyEq(originOffset, CFrame.identity) then
			object:fail(ErrorSourceStrings.Keys.HrdProperties_UncontainedJoint, {
				jointName = "originOffset",
				foundMeshName = v3.Name
			})
		end

		local containedJointLabels = humanoidRigDescription:GetContainedJointLabels(v3.Name)

		for _, v4 in R15plusUtils.getHrdJointLabels() do
			local v5 = `{v4.Name}RigAttachment` == rigAttachmentToParent
			local joint = humanoidRigDescription:GetJoint(v4)

			if v5 and (not joint or joint.Name ~= rigAttachmentToParent or joint.ClassName ~= "Attachment") then
				object:fail(ErrorSourceStrings.Keys.HrdMissingStandardJoint, { jointName = v4.Name })
			end

			if not joint then
				continue
			end

			if table.find(containedJointLabels, v4) then
				if not v5 and (joint.Name ~= v4.Name or joint.ClassName ~= "Bone") then
					object:fail(ErrorSourceStrings.Keys.HrdImproperJointMapping, {
						jointName = v4.Name,
						boneName = v4.Name
					})
				end

				local jointSize = humanoidRigDescription:GetJointSize(v4)
				local jointRangeMin = humanoidRigDescription:GetJointRangeMin(v4)
				local jointRangeMax = humanoidRigDescription:GetJointRangeMax(v4)

				checkSize(object, v4.Name, "size", jointSize, v)
				checkVectorRange(object, v4.Name, "rangeMin", jointRangeMin, vector3, vector3_2)

				checkVectorRange(object, v4.Name, "rangeMax", jointRangeMax, vector3, vector3_2)

				if not Vector3Utils.isFirstLessOrEqual(jointRangeMin, jointRangeMax) then
					object:fail(ErrorSourceStrings.Keys.HrdProperties_MinAboveMax, {
						jointName = v4.Name
					})
				end
			else
				object:fail(ErrorSourceStrings.Keys.HrdProperties_UncontainedJoint, {
					jointName = v4.Name,
					foundMeshName = v3.Name
				})
			end
		end

		local digitsRigDescription = v3:FindFirstChildWhichIsA("DigitsRigDescription")

		if digitsRigDescription == nil then
			continue
		end

		object:setReportingInstance(digitsRigDescription)

		if
			(v3.Name ~= "LeftHand" or digitsRigDescription.Side ~= Enum.DigitsRigDescriptionSide.Left)
			and (v3.Name ~= "RightHand" or digitsRigDescription.Side ~= Enum.DigitsRigDescriptionSide.Right)
		then
			local expectedSide = v3.Name == "LeftHand" and "Left" or v3.Name == "RightHand" and "Right" or "None"

			object:fail(ErrorSourceStrings.Keys.HrdCheck_DrdInvalidSide, {
				partName = v3.Name,
				expectedSide = expectedSide,
				foundSide = digitsRigDescription.Side.Name
			})
		end

		checkSize(object, "Index", "size", digitsRigDescription.IndexSize, v2)
		checkSize(object, "Thumb", "size", digitsRigDescription.ThumbSize, v2)
		checkSize(object, "Middle", "size", digitsRigDescription.MiddleSize, v2)
		checkSize(object, "Pinky", "size", digitsRigDescription.PinkySize, v2)
		checkSize(object, "Ring", "size", digitsRigDescription.RingSize, v2)
		checkVectorRange(object, "Index", "range", digitsRigDescription.IndexRange, vector3_5, vector3_6)
		checkVectorRange(object, "Thumb", "range", digitsRigDescription.ThumbRange, vector3_5, vector3_6)
		checkVectorRange(object, "Pinky", "range", digitsRigDescription.PinkyRange, vector3_5, vector3_6)
		checkVectorRange(object, "Ring", "range", digitsRigDescription.RingRange, vector3_5, vector3_6)
		checkVectorRange(object, "Middle", "range", digitsRigDescription.MiddleRange, vector3_5, vector3_6)
	end
end

return HrdPropertiesSensible
