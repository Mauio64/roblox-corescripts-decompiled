local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local BoundsDataUtils = require(parent.util.BoundsDataUtils)
local BoundsCalculator = require(parent.util.BoundsCalculator)

local getFFlagUGCValidateHeadAboveTorso = require(parent.flags.getFFlagUGCValidateHeadAboveTorso)
local GetFStringUGCValidateLegHipAttachmentRange = require(parent.flags.GetFStringUGCValidateLegHipAttachmentRange)

local GetFStringUGCValidateAllowedLegOverlapMultiplier = require(parent.flags.GetFStringUGCValidateAllowedLegOverlapMultiplier)

local LegsSeparated = {}

LegsSeparated.categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.FULL_BODY }

LegsSeparated.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.renderMeshesData
}

if getFFlagUGCValidateHeadAboveTorso() then
	LegsSeparated.conditionalData = { ValidationEnums.SharedDataMember.fullBodyPartsMetrics }
end

LegsSeparated.expectedFailures = {}

local function validateAttachmentPosition(object, rootInstance, assetTypeFromUploadEnum)
	if assetTypeFromUploadEnum == Enum.AssetType.RightLeg then
		local v = rootInstance.RightUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if v < rootInstance.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X then
			object:fail(ErrorSourceStrings.Keys.LegsSeparated_HipAttachmentOutOfRange, {
				attachmentPath = "RightUpperLeg.RightHipRigAttachment.CFrame.Position.X",
				currentValue = string.format("%.2f", rootInstance.RightUpperLeg.RightHipRigAttachment.CFrame.Position.X),
				comparison = "greater than",
				cutoff = string.format("%.2f", v)
			})
		end
	elseif assetTypeFromUploadEnum == Enum.AssetType.LeftLeg then
		local v = -rootInstance.LeftUpperLeg.Size.X * GetFStringUGCValidateLegHipAttachmentRange.asNumber()

		if rootInstance.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X < v then
			object:fail(ErrorSourceStrings.Keys.LegsSeparated_HipAttachmentOutOfRange, {
				attachmentPath = "LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X",
				currentValue = string.format("%.2f", rootInstance.LeftUpperLeg.LeftHipRigAttachment.CFrame.Position.X),
				comparison = "less than",
				cutoff = string.format("%.2f", v)
			})
		end
	end
end

local function calculateBounds(p, items)
	local bounds = {}

	for _, item in items do
		bounds = BoundsDataUtils.combineBounds(bounds, p[item].boundsData)
	end

	return bounds
end

local function buildEditableMeshesFromSharedData(data)
	local editableMeshesFromSharedData = {}

	for childName, v in data.renderMeshesData do
		local child = data.rootInstance:FindFirstChild(childName, true)

		if child and v.editable then
			editableMeshesFromSharedData[child] = {
				MeshId = { instance = v.editable, created = false }
			}
		end
	end

	return editableMeshesFromSharedData
end

local function createAllBodyPartsFromRootInstance(rootInstance)
	local partsByName = {}

	for _, part in rootInstance:GetChildren() do
		if part:IsA("MeshPart") then
			partsByName[part.Name] = part
		end
	end

	return partsByName
end

local function checkLegOverlap(object, p)
	local v = calculateBounds(p, {
		Constants.NAMED_R15_BODY_PARTS.LeftUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.LeftFoot
	})

	local boundsCenters = BoundsDataUtils.calculateBoundsCenters(v)
	local boundsDimensions = BoundsDataUtils.calculateBoundsDimensions(v)

	local v2 = calculateBounds(p, {
		Constants.NAMED_R15_BODY_PARTS.RightUpperLeg,
		Constants.NAMED_R15_BODY_PARTS.RightLowerLeg,
		Constants.NAMED_R15_BODY_PARTS.RightFoot
	})

	local boundsCenters2 = BoundsDataUtils.calculateBoundsCenters(v2)
	local boundsDimensions2 = BoundsDataUtils.calculateBoundsDimensions(v2)

	if not (boundsCenters and boundsDimensions and boundsCenters2 and boundsDimensions2) then
		return
	end

	local v3 = boundsCenters2.X - boundsCenters.X
	local v4 = (boundsDimensions.X + boundsDimensions2.X) * 0.5 - v3

	if v4 <= 0 then
		return
	end

	local v5 = boundsDimensions.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()
	local v6 = boundsDimensions2.X * GetFStringUGCValidateAllowedLegOverlapMultiplier.asNumber()

	if v5 < v4 or v6 < v4 then
		object:fail(ErrorSourceStrings.Keys.LegsSeparated_LegsOverlap, {
			overlap = string.format("%.2f", v4),
			leftMax = string.format("%.2f", v5),
			rightMax = string.format("%.2f", v6)
		})
	end
end

local function validateFullBodySeparation(object, data)
	if getFFlagUGCValidateHeadAboveTorso() then
		local fullBodyPartsMetrics = data.fullBodyPartsMetrics

		if fullBodyPartsMetrics and next(fullBodyPartsMetrics) then
			checkLegOverlap(object, fullBodyPartsMetrics)
		end
	else
		local allBodyPartsFromRootInstance = createAllBodyPartsFromRootInstance(data.rootInstance)
		local editableMeshesFromSharedData = buildEditableMeshesFromSharedData(data)
		local v = {
			isServer = data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend,
			editableMeshes = editableMeshesFromSharedData
		}

		local individualFullBodyPartsData, v2, v3 = BoundsCalculator.calculateIndividualFullBodyPartsData(
			allBodyPartsFromRootInstance,
			v,
			nil,
			false
		)

		if individualFullBodyPartsData then
			checkLegOverlap(object, v3)
		else
			object:fail(ErrorSourceStrings.Keys.LegsSeparated_BoundsCalculationFailed, {
				details = not v2 and "Unknown error" or table.concat(v2, "; ")
			})
		end
	end
end

local function getAssetTypeFromUploadEnum(p) -- 1 equivalent call inferred from this helper
	if p.uploadEnum and p.uploadEnum.assetType then
		return p.uploadEnum.assetType
	end

	return nil
end

function LegsSeparated.run(p, p2)
	if p2.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
		validateFullBodySeparation(p, p2)
		return
	end

	local assetTypeFromUploadEnum = getAssetTypeFromUploadEnum(p2) -- inferred equivalent call

	if
		not assetTypeFromUploadEnum
		or assetTypeFromUploadEnum ~= Enum.AssetType.RightLeg and assetTypeFromUploadEnum ~= Enum.AssetType.LeftLeg
	then
		return
	end

	validateAttachmentPosition(p, p2.rootInstance, assetTypeFromUploadEnum)
end

return LegsSeparated
