local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)
local getFFlagUGCValidateLegFullBodySeparation = require(ParentParent.flags.getFFlagUGCValidateLegFullBodySeparation)
local GetFStringUGCValidateLegHipAttachmentRange = require(ParentParent.flags.GetFStringUGCValidateLegHipAttachmentRange)
local GetFStringUGCValidateAllowedLegOverlapMultiplier = require(ParentParent.flags.GetFStringUGCValidateAllowedLegOverlapMultiplier)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.FULL_BODY
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	fflag = getFFlagUGCValidateMigratePoseBlocking,
	expectedFailures = {}
}

local function validateAttachmentPosition(p1, p2, p3) -- line: 39
	-- upvalues: GetFStringUGCValidateLegHipAttachmentRange (copy), ErrorSourceStrings (copy)
	if p3 == Enum.AssetType.RightLeg then
		local v21 = p2.RightUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if v21 < p2.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X then
			p1:fail(ErrorSourceStrings.Keys.LegsSeparated_HipAttachmentOutOfRange, {
				attachmentPath = "RightUpperLeg.RightHipRigAttachment.CFrame.Position.X",
				comparison = "greater than",
				currentValue = string.format("%.2f", p2.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X),
				cutoff = string.format("%.2f", v21)
			})

			return
		end
	elseif p3 == Enum.AssetType.LeftLeg then
		local v22 = -p2.LeftUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if v22 > p2.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X then
			p1:fail(ErrorSourceStrings.Keys.LegsSeparated_HipAttachmentOutOfRange, {
				attachmentPath = "LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X",
				comparison = "less than",
				currentValue = string.format("%.2f", p2.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X),
				cutoff = string.format("%.2f", v22)
			})
		end
	end
end
local function calculateBounds(t2: {[any]: any}, t3: {[any]: any}) -- line: 70
	-- upvalues: BoundsDataUtils (copy)
	local t4 = {}

	for _, v27 in t3 do
		t4 = BoundsDataUtils.combineBounds(t4, t2[v27].boundsData)
	end

	return t4
end
local function buildEditableMeshesFromSharedData(p4) -- line: 78
	local t5 = {}

	for v30, v31 in p4.renderMeshesData do
		local v32 = p4.rootInstance:FindFirstChild(v30, true)

		if v32 and v31.editable then
			t5[v32] = {
				MeshId = {
					created = false,
					instance = v31.editable
				}
			}
		end
	end

	return t5
end
local function createAllBodyPartsFromRootInstance(p5) -- line: 90
	local t6 = {}

	for _, child in p5:GetChildren() do
		if child:IsA("MeshPart") then
			t6[child.Name] = child
		end
	end

	return t6
end
local function validateFullBodySeparation(p6, p7) -- line: 100
	-- upvalues: getFFlagUGCValidateLegFullBodySeparation (copy), createAllBodyPartsFromRootInstance (copy), buildEditableMeshesFromSharedData (copy), ValidationEnums (copy), BoundsCalculator (copy), ErrorSourceStrings (copy), calculateBounds (copy), Constants (copy), BoundsDataUtils (copy), GetFStringUGCValidateAllowedLegOverlapMultiplier (copy)
	if not getFFlagUGCValidateLegFullBodySeparation() then
		return
	end

	local v39 = createAllBodyPartsFromRootInstance(p7.rootInstance)
	local v40 = buildEditableMeshesFromSharedData(p7)
	local t7 = {
		isServer = p7.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend,
		editableMeshes = v40
	}
	local v42, v43, v44 = BoundsCalculator.calculateIndividualFullBodyPartsData(v39, t7, nil, false)

	if not v42 then
		p6:fail(ErrorSourceStrings.Keys.LegsSeparated_BoundsCalculationFailed, {
			details = not v43 and "Unknown error" or table.concat(v43, "; ")
		})

		return
	end

	local v45 = calculateBounds(v44, {
		Constants.NAMED_R15_BODY_PARTS.LeftUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftFoot
	})
	local v46 = BoundsDataUtils.calculateBoundsCenters(v45)
	local v47 = BoundsDataUtils.calculateBoundsDimensions(v45)
	local v48 = calculateBounds(v44, {
		Constants.NAMED_R15_BODY_PARTS.RightUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.RightLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.RightFoot
	})
	local v49 = BoundsDataUtils.calculateBoundsCenters(v48)
	local v50 = BoundsDataUtils.calculateBoundsDimensions(v48)

	if not v46 or not v47 or not v49 or not v50 then
		return
	end

	local v51 = v49.X - v46.X
	local v52 = (v47.X + v50.X) * 0.5 - v51

	if v52 <= 0 then
		return
	end

	local v53 = v47.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()
	local v54 = v50.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()

	if v53 < v52 or v54 < v52 then
		p6:fail(ErrorSourceStrings.Keys.LegsSeparated_LegsOverlap, {
			overlap = string.format("%.2f", v52),
			leftMax = string.format("%.2f", v53),
			rightMax = string.format("%.2f", v54)
		})
	end
end
local function getAssetTypeFromUploadEnum(p8) -- line: 161
	if p8.uploadEnum and p8.uploadEnum.assetType then
		return p8.uploadEnum.assetType
	end

	return nil
end

function t1.run(p9, p10) -- line: 168
	-- upvalues: ValidationEnums (copy), validateFullBodySeparation (copy), validateAttachmentPosition (copy)
	if p10.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
		validateFullBodySeparation(p9, p10)

		return
	end

	local v58 = if not p10.uploadEnum or not p10.uploadEnum.assetType then nil else p10.uploadEnum.assetType

	if not v58 then
		return
	end

	if v58 ~= Enum.AssetType.RightLeg and v58 ~= Enum.AssetType.LeftLeg then
		return
	end

	validateAttachmentPosition(p9, p10.rootInstance, v58)
end

return t1
