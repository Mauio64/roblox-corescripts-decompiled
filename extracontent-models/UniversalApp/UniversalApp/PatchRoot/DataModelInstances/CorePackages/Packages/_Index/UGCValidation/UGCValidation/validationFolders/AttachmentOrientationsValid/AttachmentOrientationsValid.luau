local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getDiffBetweenOrientations = require(parent.util.getDiffBetweenOrientations)
local floatEquals = require(parent.util.floatEquals)
local valueToString = require(parent.util.valueToString)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)
local AttachmentRotationFInts = require(parent.util.AttachmentRotationFInts)

local defineFastFlag = game:DefineFastFlag("UGCValidateRigAttachmentRotationUsesDiff", false)

local thresholdGetters = AttachmentRotationFInts.thresholdGetters

local v = CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, -1)) * CFrame.fromEulerAnglesXYZ(-1.5707963267948966, 0, 0)

local AttachmentOrientationsValid = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.uploadEnum },
	expectedFailures = {}
}

local function expectedGripAttCFrameRotation(rootInstance, assetType)
	local v2 = assetType == Enum.AssetType.RightArm and "Right" or "Left"

	local child = rootInstance:FindFirstChild(v2 .. "LowerArm")
	local child2 = rootInstance:FindFirstChild(v2 .. "Hand")

	if not (child and child2) then
		return CFrame.identity
	end

	local child3 = child:FindFirstChild(v2 .. "ElbowRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	local child4 = child:FindFirstChild(v2 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	local child5 = child2:FindFirstChild(v2 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	local child6 = child2:FindFirstChild(v2 .. "GripAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	if not (child3 and child4 and child5 and child6) then
		return CFrame.identity
	end

	local attachmentCFrameInPartSpace = getAttachmentCFrameInPartSpace(child5)

	local v3 = attachmentCFrameInPartSpace * getAttachmentCFrameInPartSpace(child4):Inverse() * getAttachmentCFrameInPartSpace(child3)
	local v4 = attachmentCFrameInPartSpace.Position - v3.Position

	local v5 = 1.5707963267948966 - math.acos(Vector3.new(v4.X, math.max(0, -v4.Y), 0).Unit.X)

	return CFrame.fromEulerAnglesXYZ(0, 0, v5) * v.Rotation
end

function AttachmentOrientationsValid.run(object, p)
	local rootInstance = p.rootInstance
	local assetType = p.uploadEnum.assetType

	for _, descendant in rootInstance:GetDescendants(), nil, nil do
		if descendant.ClassName ~= "Attachment" then
			continue
		end

		local v2 = string.sub(descendant.Name, -13) == "RigAttachment"
		local v3 = string.sub(descendant.Name, -14) == "GripAttachment"

		if v2 then
			local v4

			if defineFastFlag then
				v4 = getDiffBetweenOrientations(CFrame.identity, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters.RigAttachment()
			else
				local orientation, v5, v6 = getAttachmentCFrameInPartSpace(descendant):ToOrientation()
				v4 = not (floatEquals(orientation, 0) and floatEquals(v5, 0) and floatEquals(v6, 0))
			end

			if v4 then
				object:fail(ErrorSourceStrings.Keys.AttachmentOrientationRigRotated, {
					InstancePath = descendant:GetFullName()
				})
			end
		elseif thresholdGetters[descendant.Name] ~= nil then
			local cframe = CFrame.new()

			if v3 and assetType and (assetType == Enum.AssetType.RightArm or assetType == Enum.AssetType.LeftArm) then
				cframe = expectedGripAttCFrameRotation(rootInstance, assetType)
			end

			if getDiffBetweenOrientations(cframe, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters[descendant.Name]() then
				local vector3 = Vector3.new(cframe:ToOrientation())
				local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

				object:fail(ErrorSourceStrings.Keys.AttachmentOrientationDeviation, {
					InstancePath = descendant:GetFullName(),
					ExpectedOrientation = valueToString(vector3_2),
					MaxDeviation = tostring(thresholdGetters[descendant.Name]())
				})
			end
		end
	end
end

return AttachmentOrientationsValid
