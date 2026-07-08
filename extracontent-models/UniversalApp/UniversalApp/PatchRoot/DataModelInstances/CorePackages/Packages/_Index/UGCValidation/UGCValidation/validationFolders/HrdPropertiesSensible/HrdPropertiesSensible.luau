local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local ValidationRulesUtil = require(ParentParent.util.ValidationRulesUtil)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local Vector3Utils = require(ParentParent.util.Vector3Utils)
local valueToString = require(ParentParent.util.valueToString)
local CFrameUtils = require(ParentParent.util.CFrameUtils)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}
local v12 = game:DefineFastInt("UGCValidationHrdJointSizeHundredthsLimit", 150) / 100
local v13 = game:DefineFastInt("UGCValidationHrdJointRangeMinXHundredths", 0)
local v14 = game:DefineFastInt("UGCValidationHrdJointRangeMaxXHundredths", 0)
local v15 = game:DefineFastInt("UGCValidationHrdJointRangeMinYHundredths", 0)
local v16 = game:DefineFastInt("UGCValidationHrdJointRangeMaxYHundredths", 0)
local v17 = game:DefineFastInt("UGCValidationHrdJointRangeMinZHundredths", 0)
local v18 = game:DefineFastInt("UGCValidationHrdJointRangeMaxZHundredths", 0)
local v19 = game:DefineFastInt("UGCValidationHrdOriginOffsetMinYHundredths", -500)
local v20 = game:DefineFastInt("UGCValidationHrdOriginOffsetMaxYHundredths", 500)
local vector3 = Vector3.new(v13 / 100, v15 / 100, v17 / 100)
local vector3_2 = Vector3.new(v14 / 100, v16 / 100, v18 / 100)
local vector3_3 = Vector3.new(0, v19 / 100, 0)
local vector3_4 = Vector3.new(0, v20 / 100, 0)
local v25 = game:DefineFastInt("UGCValidationDrdJointSizeHundredthsLimit", 150) / 100
local v26 = game:DefineFastInt("UGCValidationDrdJointRangeMinXHundredths", 0)
local v27 = game:DefineFastInt("UGCValidationDrdJointRangeMaxXHundredths", 0)
local v28 = game:DefineFastInt("UGCValidationDrdJointRangeMinYHundredths", 0)
local v29 = game:DefineFastInt("UGCValidationDrdJointRangeMaxYHundredths", 0)
local v30 = game:DefineFastInt("UGCValidationDrdJointRangeMinZHundredths", 0)
local v31 = game:DefineFastInt("UGCValidationDrdJointRangeMaxZHundredths", 0)
local vector3_5 = Vector3.new(v26 / 100, v28 / 100, v30 / 100)
local vector3_6 = Vector3.new(v27 / 100, v29 / 100, v31 / 100)

local function checkVectorRange(p1, s1: string, s2: string, vector3_7: Vector3, vector3_8: Vector3, vector3_9: Vector3) -- line: 47
	-- upvalues: Vector3Utils (copy), ErrorSourceStrings (copy), valueToString (copy)
	if not Vector3Utils.isInRange(vector3_7, vector3_8, vector3_9) then
		p1:fail(ErrorSourceStrings.Keys.HrdProperties_PropertyOutOfRange, {
			jointName = s1,
			propertyName = s2,
			currentValue = valueToString(vector3_7),
			valueMin = valueToString(vector3_8),
			valueMax = valueToString(vector3_9)
		})
	end
end
local function checkSize(p2, s3: string, s4: string, n1: number, n2: number) -- line: 66
	-- upvalues: ErrorSourceStrings (copy), valueToString (copy)
	if n1 < 0 or n2 < n1 then
		p2:fail(ErrorSourceStrings.Keys.HrdProperties_PropertyOutOfRange, {
			valueMin = "0",
			jointName = s3,
			propertyName = s4,
			currentValue = valueToString(n1),
			valueMax = valueToString(n2)
		})
	end
end

function t1.run(p3, p4) -- line: 84
	-- upvalues: getAllInstancesIsA (copy), ValidationRulesUtil (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), CFrameUtils (copy), Vector3Utils (copy), vector3_3 (copy), vector3_4 (copy), ErrorSourceStrings (copy), valueToString (copy), R15plusUtils (copy), checkSize (copy), v12 (copy), checkVectorRange (copy), vector3 (copy), vector3_2 (copy), v25 (copy), vector3_5 (copy), vector3_6 (copy)
	local rootInstance = p4.rootInstance

	for _, v51 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local HumanoidRigDescription = v51:FindFirstChildWhichIsA("HumanoidRigDescription")
		local v53 = ValidationRulesUtil.rigAttachmentToParentMap[v51.Name]

		if HumanoidRigDescription ~= nil then
			if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
				p3:setReportingInstance(HumanoidRigDescription)
			end

			local OriginOffset = HumanoidRigDescription.OriginOffset

			if v51.Name == "LowerTorso" then
				if not CFrameUtils.fuzzyEq(OriginOffset.Rotation, CFrame.identity) or not Vector3Utils.isInRange(OriginOffset.Position, vector3_3, vector3_4) then
					p3:fail(ErrorSourceStrings.Keys.HrdProperties_OriginOutsideBounds, {
						valueMin = valueToString(vector3_3),
						valueMax = valueToString(vector3_4)
					})
				end
			elseif not CFrameUtils.fuzzyEq(OriginOffset, CFrame.identity) then
				p3:fail(ErrorSourceStrings.Keys.HrdProperties_UncontainedJoint, {
					jointName = "originOffset",
					foundMeshName = v51.Name
				})
			end

			local ContainedJointLabels = HumanoidRigDescription:GetContainedJointLabels(v51.Name)

			for _, v57 in R15plusUtils.getHrdJointLabels() do
				local v58 = v53 == `{ v57.Name }RigAttachment`
				local Joint = HumanoidRigDescription:GetJoint(v57)

				if v58 and (not Joint or v53 ~= Joint.Name or Joint.ClassName ~= "Attachment") then
					p3:fail(ErrorSourceStrings.Keys.HrdMissingStandardJoint, {
						jointName = v57.Name
					})
				end

				if Joint then
					if not table.find(ContainedJointLabels, v57) then
						p3:fail(ErrorSourceStrings.Keys.HrdProperties_UncontainedJoint, {
							jointName = v57.Name,
							foundMeshName = v51.Name
						})
					else
						if not v58 and (Joint.Name ~= v57.Name or Joint.ClassName ~= "Bone") then
							p3:fail(ErrorSourceStrings.Keys.HrdImproperJointMapping, {
								jointName = v57.Name,
								boneName = v57.Name
							})
						end

						local JointSize = HumanoidRigDescription:GetJointSize(v57)
						local JointRangeMin = HumanoidRigDescription:GetJointRangeMin(v57)
						local JointRangeMax = HumanoidRigDescription:GetJointRangeMax(v57)

						checkSize(p3, v57.Name, "size", JointSize, v12)
						checkVectorRange(p3, v57.Name, "rangeMin", JointRangeMin, vector3, vector3_2)
						checkVectorRange(p3, v57.Name, "rangeMax", JointRangeMax, vector3, vector3_2)

						if not Vector3Utils.isFirstLessOrEqual(JointRangeMin, JointRangeMax) then
							p3:fail(ErrorSourceStrings.Keys.HrdProperties_MinAboveMax, {
								jointName = v57.Name
							})
						end
					end
				end
			end

			local DigitsRigDescription = v51:FindFirstChildWhichIsA("DigitsRigDescription")

			if DigitsRigDescription ~= nil then
				if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
					p3:setReportingInstance(DigitsRigDescription)
				end

				if (v51.Name ~= "LeftHand" or DigitsRigDescription.Side ~= Enum.DigitsRigDescriptionSide.Left) and (v51.Name ~= "RightHand" or DigitsRigDescription.Side ~= Enum.DigitsRigDescriptionSide.Right) then
					local s5 = "None"

					if v51.Name == "LeftHand" then
						s5 = "Left"
					elseif v51.Name == "RightHand" then
						s5 = "Right"
					end

					p3:fail(ErrorSourceStrings.Keys.HrdCheck_DrdInvalidSide, {
						partName = v51.Name,
						expectedSide = s5,
						foundSide = DigitsRigDescription.Side.Name
					})
				end

				checkSize(p3, "Index", "size", DigitsRigDescription.IndexSize, v25)
				checkSize(p3, "Thumb", "size", DigitsRigDescription.ThumbSize, v25)
				checkSize(p3, "Middle", "size", DigitsRigDescription.MiddleSize, v25)
				checkSize(p3, "Pinky", "size", DigitsRigDescription.PinkySize, v25)
				checkSize(p3, "Ring", "size", DigitsRigDescription.RingSize, v25)
				checkVectorRange(p3, "Index", "range", DigitsRigDescription.IndexRange, vector3_5, vector3_6)
				checkVectorRange(p3, "Thumb", "range", DigitsRigDescription.ThumbRange, vector3_5, vector3_6)
				checkVectorRange(p3, "Pinky", "range", DigitsRigDescription.PinkyRange, vector3_5, vector3_6)
				checkVectorRange(p3, "Ring", "range", DigitsRigDescription.RingRange, vector3_5, vector3_6)
				checkVectorRange(p3, "Middle", "range", DigitsRigDescription.MiddleRange, vector3_5, vector3_6)
			end
		end
	end
end

return t1
