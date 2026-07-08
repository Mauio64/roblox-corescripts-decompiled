local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getDiffBetweenOrientations = require(ParentParent.util.getDiffBetweenOrientations)
local floatEquals = require(ParentParent.util.floatEquals)
local valueToString = require(ParentParent.util.valueToString)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local AttachmentRotationFInts = require(ParentParent.util.AttachmentRotationFInts)
local t1 = {}
local v11 = game:DefineFastFlag("UGCValidateRigAttachmentRotationUsesDiff", false)
local thresholdGetters = AttachmentRotationFInts.thresholdGetters
local v13 = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(0, 0, -1))) * CFrame.fromEulerAnglesXYZ(-1.5707963267948966, 0, 0)

function t1.expectedGripAttCFrameRotation(p1, p2) -- line: 34
	-- upvalues: R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), v13 (copy)
	assert(p2 == Enum.AssetType.RightArm or p2 == Enum.AssetType.LeftArm)

	local v16 = p2 ~= Enum.AssetType.RightArm and "Left" or "Right"
	local v17 = p1:FindFirstChild(v16 .. "LowerArm")
	local v18 = p1:FindFirstChild(v16 .. "Hand")

	assert(v17)
	assert(v18)

	local v19 = v17:FindFirstChild(v16 .. "ElbowRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v20 = v17:FindFirstChild(v16 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v21 = v18:FindFirstChild(v16 .. "WristRigAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())
	local v22 = v18:FindFirstChild(v16 .. "GripAttachment", R15plusUtils.checkFlagEnabledForAllowHrd())

	assert(v19)
	assert(v20)
	assert(v21)
	assert(v22)

	local v23 = getAttachmentCFrameInPartSpace(v21)
	local v24 = v23 * getAttachmentCFrameInPartSpace(v20):Inverse() * getAttachmentCFrameInPartSpace(v19)
	local v25 = v23.Position - v24.Position
	local v26 = 1.5707963267948966 - math.acos(Vector3.new(v25.X, math.max(0, -v25.Y), 0).Unit.X)

	return CFrame.fromEulerAnglesXYZ(0, 0, v26) * v13.Rotation
end
function t1.runValidation(p3, p4) -- line: 87
	-- upvalues: FailureReasonsAccumulator (copy), v11 (copy), getDiffBetweenOrientations (copy), getAttachmentCFrameInPartSpace (copy), thresholdGetters (copy), floatEquals (copy), Analytics (copy), t1 (copy), valueToString (copy)
	local v29 = FailureReasonsAccumulator.new()

	for _, descendant in (p3:GetDescendants()) do
		if descendant.ClassName == "Attachment" then
			local v32 = string.sub(descendant.Name, -13) == "RigAttachment"
			local v33 = string.sub(descendant.Name, -14) == "GripAttachment"

			if v32 then
				local v34

				if v11 then
					v34 = getDiffBetweenOrientations(CFrame.identity, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters.RigAttachment()
				else
					local v35, v36, v37 = getAttachmentCFrameInPartSpace(descendant):ToOrientation()

					v34 = not floatEquals(v35, 0) or (not floatEquals(v36, 0) or not floatEquals(v37, 0))
				end

				if v34 then
					Analytics.reportFailure(Analytics.ErrorType.validateBodyPartChildAttachmentOrientations_RotatedRig, nil, p4)
					v29:updateReasons(false, { string.format("Rig attachments cannot be rotated, please set %s's orientation to (0,0,0)", descendant:GetFullName()) })
				end
			elseif thresholdGetters[descendant.Name] ~= nil then
				local cFrame = CFrame.new()

				if v33 then
					assert(p4.assetTypeEnum)
					cFrame = t1.expectedGripAttCFrameRotation(p3, p4.assetTypeEnum)
				end

				if getDiffBetweenOrientations(cFrame, getAttachmentCFrameInPartSpace(descendant)) > thresholdGetters[descendant.Name]() then
					Analytics.reportFailure(v33 and Analytics.ErrorType.validateBodyPartChildAttachmentOrientations_RotatedGrip or Analytics.ErrorType.validateBodyPartChildAttachmentOrientations_RotatedBasic, nil, p4)

					local vector3 = Vector3.new(cFrame:ToOrientation())
					local vector3_2 = Vector3.new(math.deg(vector3.X), math.deg(vector3.Y), (math.deg(vector3.Z)))

					v29:updateReasons(false, { string.format("Attachment %s's orientation deviates too far from expectation, which will make attached accessories look unaligned. Recommended orientation is %s, and you can deviate up to %d degrees", descendant:GetFullName(), valueToString(vector3_2), thresholdGetters[descendant.Name]()) })
				end
			end
		end
	end

	return v29:getFinalResults()
end

return t1
