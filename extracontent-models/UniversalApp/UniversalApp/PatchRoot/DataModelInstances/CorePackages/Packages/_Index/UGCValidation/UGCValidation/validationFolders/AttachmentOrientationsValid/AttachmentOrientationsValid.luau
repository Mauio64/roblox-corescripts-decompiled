local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getDiffBetweenOrientations = require(ParentParent.util.getDiffBetweenOrientations)
local floatEquals = require(ParentParent.util.floatEquals)
local valueToString = require(ParentParent.util.valueToString)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local AttachmentRotationFInts = require(ParentParent.util.AttachmentRotationFInts)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local v11 = game:DefineFastFlag("UGCValidateRigAttachmentRotationUsesDiff", false)
local thresholdGetters = AttachmentRotationFInts.thresholdGetters
local v13 = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(0, 0, -1))) * CFrame.fromEulerAnglesXYZ(-1.5707963267948966, 0, 0)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {}
}

local function expectedGripAttCFrameRotation(p1, p2) -- line: 39
	-- upvalues: R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), v13 (copy)
	local v18 = p2 ~= Enum.AssetType.RightArm and "Left" or "Right"
	local v19 = p1:FindFirstChild(v18 .. "LowerArm")
	local v20 = p1:FindFirstChild(v18 .. "Hand")

	if not v19 or not v20 then
		return CFrame.identity
	end

	local v21 = v19:FindFirstChild(v18 .. "ElbowRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v22 = v19:FindFirstChild(v18 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v23 = v20:FindFirstChild(v18 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v24 = v20:FindFirstChild(v18 .. "GripAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	if not v21 or not v22 or not v23 or not v24 then
		return CFrame.identity
	end

	local v25 = getAttachmentCFrameInPartSpace(v23)
	local v26 = v25 * getAttachmentCFrameInPartSpace(v22):Inverse() * getAttachmentCFrameInPartSpace(v21)
	local v27 = v25.Position - v26.Position
	local v28 = 1.5707963267948966 - math.acos(Vector3.new(v27.X, math.max(0, -v27.Y), 0).Unit.X)

	return CFrame.fromEulerAnglesXYZ(0, 0, v28) * v13.Rotation
end

function t1.run(p3, p4) -- line: 79
	-- upvalues: v11 (copy), getDiffBetweenOrientations (copy), getAttachmentCFrameInPartSpace (copy), thresholdGetters (copy), floatEquals (copy), ErrorSourceStrings (copy), expectedGripAttCFrameRotation (copy), valueToString (copy)
	local rootInstance = p4.rootInstance
	local assetType = p4.uploadEnum.assetType

	for _, descendant in (rootInstance:GetDescendants()) do
		if descendant.ClassName == "Attachment" then
			local v35 = string.sub(descendant.Name, -13) == "RigAttachment"
			local v36 = string.sub(descendant.Name, -14) == "GripAttachment"

			if v35 then
				local v37

				if v11 then
					v37 = getDiffBetweenOrientations(CFrame.identity, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters.RigAttachment()
				else
					local v38, v39, v40 = getAttachmentCFrameInPartSpace(descendant):ToOrientation()

					v37 = not floatEquals(v38, 0) or (not floatEquals(v39, 0) or not floatEquals(v40, 0))
				end

				if v37 then
					p3:fail(ErrorSourceStrings.Keys.AttachmentOrientationRigRotated, {
						InstancePath = descendant:GetFullName()
					})
				end
			elseif thresholdGetters[descendant.Name] ~= nil then
				local cFrame = CFrame.new()

				if v36 and assetType and (assetType == Enum.AssetType.RightArm or assetType == Enum.AssetType.LeftArm) then
					cFrame = expectedGripAttCFrameRotation(rootInstance, assetType)
				end

				if getDiffBetweenOrientations(cFrame, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters[descendant.Name]() then
					local vector3 = Vector3.new(cFrame:ToOrientation())
					local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

					p3:fail(ErrorSourceStrings.Keys.AttachmentOrientationDeviation, {
						InstancePath = descendant:GetFullName(),
						ExpectedOrientation = valueToString(vector3_2),
						MaxDeviation = tostring(thresholdGetters[descendant.Name]())
					})
				end
			end
		end
	end
end

return t1
