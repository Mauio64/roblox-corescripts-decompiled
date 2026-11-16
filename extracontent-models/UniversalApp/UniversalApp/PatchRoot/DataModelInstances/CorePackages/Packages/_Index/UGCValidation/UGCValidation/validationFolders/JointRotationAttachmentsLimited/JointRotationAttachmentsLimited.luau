local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getDiffBetweenOrientations = require(parent.util.getDiffBetweenOrientations)
local valueToString = require(parent.util.valueToString)

local getAllInstancesWithName = require(parent.util.getAllInstancesWithName)
local R15plusUtils = require(parent.util.R15plusUtils)
local JointRotationAttachmentsLimited = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}

local defineFastInt = game:DefineFastInt("UGCValidationJointRotationMaximumHundredthPositionOffset", 1)

local defineFastInt2 = game:DefineFastInt("UGCValidationJointRotationMaximumDegreeOrientationOffset", 1)

local v = {
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

function JointRotationAttachmentsLimited.run(object, p)
	local v2 = { LeftShoulderRigAttachment = 0, RightShoulderRigAttachment = 0 }

	for _, v3 in getAllInstancesWithName(p.rootInstance, R15plusUtils.JointRotationName) do
		local parent2 = v3.Parent
		object:setReportingInstance(v3)

		if v3.ClassName == "Attachment" and parent2:IsA("Attachment") then
			if v2[parent2.Name] == nil then
				object:fail(ErrorSourceStrings.Keys.JointRotAtt_UnrecognizedParent, {
					parentPath = parent2:GetFullName()
				})
			elseif v2[parent2.Name] == 1 then
				object:fail(ErrorSourceStrings.Keys.JointRotAtt_MultipleAttachments, {
					parentPath = parent2:GetFullName()
				})
			else
				local name = parent2.Name
				v2[name] += 1

				if v[p.uploadEnum.assetType] ~= nil and v[p.uploadEnum.assetType][parent2.Name] ~= nil then
					local cframe = v[p.uploadEnum.assetType][parent2.Name]
					local cframe2 = v3.CFrame

					if defineFastInt2 < getDiffBetweenOrientations(cframe, cframe2) then
						local vector3 = Vector3.new(cframe:ToOrientation())
						local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

						object:fail(ErrorSourceStrings.Keys.JointRotAtt_Rotated, {
							instPath = v3:GetFullName(),
							expectedOrientation = valueToString(vector3_2)
						})
					end

					local magnitude = (cframe2.Position - Vector3.new(0, 0, 0)).Magnitude

					if defineFastInt / 100 < magnitude then
						object:fail(ErrorSourceStrings.Keys.JointRotAtt_Moved, {
							instPath = v3:GetFullName(),
							expectedPosition = valueToString(Vector3.new(0, 0, 0))
						})
					end
				end
			end
		else
			object:fail(ErrorSourceStrings.Keys.JointRotAtt_WrongInstanceClass, {
				instPath = v3:GetFullName()
			})
		end
	end
end

return JointRotationAttachmentsLimited
