local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local getDiffBetweenOrientations = require(ParentParent.util.getDiffBetweenOrientations)
local valueToString = require(ParentParent.util.valueToString)
local getAllInstancesWithName = require(ParentParent.util.getAllInstancesWithName)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}
local v10 = game:DefineFastInt("UGCValidationJointRotationMaximumHundredthPositionOffset", 1)
local v11 = game:DefineFastInt("UGCValidationJointRotationMaximumDegreeOrientationOffset", 1)
local t2 = {
	[Enum.AssetType.Torso] = {
		RightShoulderRigAttachment = CFrame.fromOrientation(0, 0, 0),
		LeftShoulderRigAttachment = CFrame.fromOrientation(0, 3.141592653589793, 0)
	},
	[Enum.AssetType.RightArm] = {
		RightShoulderRigAttachment = CFrame.fromOrientation(0, 0, -1.5707963267948966)
	},
	[Enum.AssetType.LeftArm] = {
		LeftShoulderRigAttachment = CFrame.fromOrientation(0, 3.141592653589793, -1.5707963267948966)
	}
}

function t1.run(p1, p2) -- line: 38
	-- upvalues: getAllInstancesWithName (copy), R15plusUtils (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), ErrorSourceStrings (copy), t2 (copy), getDiffBetweenOrientations (copy), v11 (copy), valueToString (copy), v10 (copy)
	local rootInstance = p2.rootInstance
	local t3 = {
		LeftShoulderRigAttachment = 0,
		RightShoulderRigAttachment = 0
	}

	for _, v18 in getAllInstancesWithName(rootInstance, R15plusUtils.JointRotationName) do
		local Parent = v18.Parent

		if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
			p1:setReportingInstance(v18)
		end

		if v18.ClassName ~= "Attachment" or not Parent:IsA("Attachment") then
			p1:fail(ErrorSourceStrings.Keys.JointRotAtt_WrongInstanceClass, {
				instPath = v18:GetFullName()
			})
		elseif t3[Parent.Name] == nil then
			p1:fail(ErrorSourceStrings.Keys.JointRotAtt_UnrecognizedParent, {
				parentPath = Parent:GetFullName()
			})
		elseif t3[Parent.Name] == 1 then
			p1:fail(ErrorSourceStrings.Keys.JointRotAtt_MultipleAttachments, {
				parentPath = Parent:GetFullName()
			})
		else
			local ParentName = Parent.Name

			t3[ParentName] = t3[ParentName] + 1

			if t2[p2.uploadEnum.assetType] ~= nil and t2[p2.uploadEnum.assetType][Parent.Name] ~= nil then
				local v21 = t2[p2.uploadEnum.assetType][Parent.Name]
				local CFrame2 = v18.CFrame

				if getDiffBetweenOrientations(v21, CFrame2) > v11 then
					local vector3 = Vector3.new(v21:ToOrientation())
					local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

					p1:fail(ErrorSourceStrings.Keys.JointRotAtt_Rotated, {
						instPath = v18:GetFullName(),
						expectedOrientation = valueToString(vector3_2)
					})
				end

				if (CFrame2.Position - Vector3.new(0, 0, 0)).Magnitude > v10 / 100 then
					p1:fail(ErrorSourceStrings.Keys.JointRotAtt_Moved, {
						instPath = v18:GetFullName(),
						expectedPosition = valueToString((Vector3.new(0, 0, 0)))
					})
				end
			end
		end
	end
end

return t1
