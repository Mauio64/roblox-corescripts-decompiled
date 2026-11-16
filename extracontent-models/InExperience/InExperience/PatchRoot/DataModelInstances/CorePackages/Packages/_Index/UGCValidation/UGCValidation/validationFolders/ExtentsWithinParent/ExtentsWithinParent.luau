local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(parent.util.BoundsCalculator)
local R15plusUtils = require(parent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

local getFFlagUGCValidateHeadAboveTorso = require(parent.flags.getFFlagUGCValidateHeadAboveTorso)

local SharedDataMember = ValidationEnums.SharedDataMember

local ExtentsWithinParent = {}

ExtentsWithinParent.categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS }

if getFFlagUGCValidateHeadAboveTorso() then
	table.insert(ExtentsWithinParent.categories, ValidationEnums.UploadCategory.FULL_BODY)
end

ExtentsWithinParent.requiredData = {
	ValidationEnums.SharedDataMember.rootInstance,
	ValidationEnums.SharedDataMember.uploadEnum
}

ExtentsWithinParent.conditionalData = { SharedDataMember.renderMeshesData }

if getFFlagUGCValidateHeadAboveTorso() then
	table.insert(ExtentsWithinParent.conditionalData, SharedDataMember.fullBodyPartsMetrics)
end

ExtentsWithinParent.expectedFailures = {}

local set = {
	[Enum.AssetType.Torso] = true,
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.RightLeg] = true,
	[Enum.AssetType.LeftLeg] = true
}

local v = { UpperTorso = true }

local set2 = { [Enum.AssetType.LeftLeg] = true, [Enum.AssetType.RightLeg] = true }

local function validateBasedOnBBoxes(p, p2, p3, name: string, object)
	local boundsData = p3[p.Name].boundsData
	local boundsData2 = p3[p2.Name].boundsData
	local v2

	if boundsData2.maxOverall and boundsData.maxOverall and boundsData2.maxOverall.Y > boundsData.maxOverall.Y then
		object:fail(
			ErrorSourceStrings.Keys.Extents_PartAboveParent,
			{ lowerPart = p2.Name, upperPart = p.Name, attachmentName = name },
			p2
		)
		v2 = false
	else
		v2 = true
	end

	if boundsData.minOverall and boundsData2.minOverall and boundsData.minOverall.Y < boundsData2.minOverall.Y then
		object:fail(
			ErrorSourceStrings.Keys.Extents_ParentBelowPart,
			{ upperPart = p.Name, lowerPart = p2.Name, attachmentName = name },
			p
		)
		return false
	end

	return v2
end

local function validateBasedOnAttachmentYPos(instance, instance2, name: string, object)
	local child = instance2:FindFirstChild(name, R15plusUtils.checkFlagEnabledForAllowHrd())
	local child2 = instance:FindFirstChild(name, R15plusUtils.checkFlagEnabledForAllowHrd())

	if not (child and child2) then
		return
	end

	local size = instance2.Size
	local size2 = instance.Size

	local position = getAttachmentCFrameInPartSpace(child).Position
	local position2 = getAttachmentCFrameInPartSpace(child2).Position

	local y = (size / 2 - position).Y
	local y2 = (size / 2 + position).Y
	local y3 = (size2 / 2 - position2).Y
	local y4 = (size2 / 2 + position2).Y

	if y3 < y then
		object:fail(
			ErrorSourceStrings.Keys.Extents_PartAboveParent,
			{ lowerPart = instance2.Name, upperPart = instance.Name, attachmentName = name },
			instance2
		)
	end

	if y2 < y4 then
		object:fail(
			ErrorSourceStrings.Keys.Extents_ParentBelowPart,
			{ upperPart = instance.Name, lowerPart = instance2.Name, attachmentName = name },
			instance
		)
	end
end

local function validateHeadAboveTorso(object, data)
	local fullBodyPartsMetrics = data.fullBodyPartsMetrics

	if not (fullBodyPartsMetrics and next(fullBodyPartsMetrics)) then
		return
	end

	local fullBodyPartsMetric = fullBodyPartsMetrics[Constants.NAMED_R15_BODY_PARTS.Head]
	local fullBodyPartsMetric2 = fullBodyPartsMetrics[Constants.NAMED_R15_BODY_PARTS.UpperTorso]

	if not (fullBodyPartsMetric and fullBodyPartsMetric2) then
		return
	end

	local boundsData = fullBodyPartsMetric.boundsData
	local boundsData2 = fullBodyPartsMetric2.boundsData

	if not (boundsData.maxOverall and boundsData.minOverall and boundsData2.maxOverall and boundsData2.minOverall) then
		return
	end

	local child = data.rootInstance:FindFirstChild(Constants.NAMED_R15_BODY_PARTS.Head)

	if boundsData.minOverall.Y < boundsData2.minOverall.Y then
		object:fail(
			ErrorSourceStrings.Keys.Extents_ParentBelowPart,
			{ upperPart = "Head", lowerPart = "UpperTorso", attachmentName = "NeckRigAttachment" },
			child
		)
	end

	local midpointY = (boundsData.maxOverall.Y + boundsData.minOverall.Y) / 2
	local midpointZ = (boundsData.maxOverall.Z + boundsData.minOverall.Z) / 2
	local v2 = boundsData2.maxOverall.Y < midpointY
	local v3 = midpointZ < boundsData2.minOverall.Z

	if not (v2 or v3) then
		object:fail(ErrorSourceStrings.Keys.Extents_HeadBelowTorso, {}, child)
	end
end

function ExtentsWithinParent.run(object, data)
	if data.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY then
		if getFFlagUGCValidateHeadAboveTorso() then
			validateHeadAboveTorso(object, data)
		end
	else
		local rootInstance = data.rootInstance
		local assetType = data.uploadEnum.assetType

		if not set[assetType] then
			return
		end

		local v2 = Constants.ASSET_TYPE_INFO[assetType]

		if not v2 then
			return
		end

		local renderMeshesData = data.renderMeshesData

		if not renderMeshesData then
			return
		end

		local individualAssetPartsDataFromData, _, v3 = BoundsCalculator.calculateIndividualAssetPartsDataFromData(
			rootInstance,
			assetType,
			renderMeshesData
		)

		if not individualAssetPartsDataFromData then
			object:fetchError("Failed to calculate asset bounds data for extents check on " .. assetType.Name)
			return
		end

		for childName, subPart in pairs(v2.subParts) do
			local v4 = Constants.BODYPART_TO_PARENT[childName]

			if v4 == nil then
				continue
			end

			local v5 = rootInstance:FindFirstChild(childName)
			local v6 = rootInstance:FindFirstChild(v4)

			if not (v5 and v6) then
				continue
			end

			if not v[childName] then
				v6, v5 = v5, v6
			end

			local name = subPart.rigAttachmentToParent.name

			if not ((not (v3[v5.Name] and v3[v6.Name]) or validateBasedOnBBoxes(v5, v6, v3, name, object)) and set2[assetType]) then
				continue
			end

			validateBasedOnAttachmentYPos(v5, v6, name, object)
		end
	end
end

return ExtentsWithinParent
