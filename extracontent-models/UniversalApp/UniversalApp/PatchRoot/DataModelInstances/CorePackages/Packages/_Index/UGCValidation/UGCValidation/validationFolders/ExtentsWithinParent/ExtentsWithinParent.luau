local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local t1 = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	conditionalData = { ValidationEnums.SharedDataMember.renderMeshesData },
	fflag = getFFlagUGCValidateMigrateBodyPartBounds,
	expectedFailures = {}
}
local t2 = {
	[Enum.AssetType.Torso] = true,
	[Enum.AssetType.LeftArm] = true,
	[Enum.AssetType.RightArm] = true,
	[Enum.AssetType.RightLeg] = true,
	[Enum.AssetType.LeftLeg] = true
}
local t3 = {
	UpperTorso = true
}
local t4 = {
	[Enum.AssetType.LeftLeg] = true,
	[Enum.AssetType.RightLeg] = true
}

local function validateBasedOnBBoxes(p1, p2, t5: {[any]: any}, s1: string, p3) -- line: 45
	-- upvalues: ErrorSourceStrings (copy)
	local boundsData = t5[p1.Name].boundsData
	local boundsData2 = t5[p2.Name].boundsData
	local v22 = true

	if boundsData2.maxOverall and (boundsData.maxOverall and boundsData2.maxOverall.Y > boundsData.maxOverall.Y) then
		p3:fail(ErrorSourceStrings.Keys.Extents_PartAboveParent, {
			lowerPart = p2.Name,
			upperPart = p1.Name,
			attachmentName = s1
		}, p2)
		v22 = false
	end

	if boundsData.minOverall and boundsData2.minOverall and boundsData.minOverall.Y < boundsData2.minOverall.Y then
		p3:fail(ErrorSourceStrings.Keys.Extents_ParentBelowPart, {
			upperPart = p1.Name,
			lowerPart = p2.Name,
			attachmentName = s1
		}, p1)
		v22 = false
	end

	return v22
end
local function validateBasedOnAttachmentYPos(p4, p5, s2: string, p6) -- line: 77
	-- upvalues: R15plusUtils (copy), getAttachmentCFrameInPartSpace (copy), ErrorSourceStrings (copy)
	local s2_2 = p5:FindFirstChild(s2, R15plusUtils.checkFlagEnabledForAllowHrd())
	local s2_3 = p4:FindFirstChild(s2, R15plusUtils.checkFlagEnabledForAllowHrd())

	if not s2_2 or not s2_3 then
		return
	end

	local p5Size = p5.Size
	local p4Size = p4.Size
	local Position = getAttachmentCFrameInPartSpace(s2_2).Position
	local Position2 = getAttachmentCFrameInPartSpace(s2_3).Position
	local Y = (p5Size / 2 - Position).Y
	local Y2 = (p5Size / 2 + Position).Y
	local Y3 = (p4Size / 2 - Position2).Y
	local Y4 = (p4Size / 2 + Position2).Y

	if Y3 < Y then
		p6:fail(ErrorSourceStrings.Keys.Extents_PartAboveParent, {
			lowerPart = p5.Name,
			upperPart = p4.Name,
			attachmentName = s2
		}, p5)
	end

	if Y2 < Y4 then
		p6:fail(ErrorSourceStrings.Keys.Extents_ParentBelowPart, {
			upperPart = p4.Name,
			lowerPart = p5.Name,
			attachmentName = s2
		}, p4)
	end
end

function t1.run(p7, p8) -- line: 117
	-- upvalues: t2 (copy), Constants (copy), BoundsCalculator (copy), t3 (copy), validateBasedOnBBoxes (copy), t4 (copy), validateBasedOnAttachmentYPos (copy)
	local rootInstance = p8.rootInstance
	local assetType = p8.uploadEnum.assetType

	if not t2[assetType] then
		return
	end

	local v41 = Constants.ASSET_TYPE_INFO[assetType]

	if not v41 then
		return
	end

	local renderMeshesData = p8.renderMeshesData

	if not renderMeshesData then
		return
	end

	local v43, _, v45 = BoundsCalculator.calculateIndividualAssetPartsDataFromData(rootInstance, assetType, renderMeshesData)

	if not v43 then
		p7:fetchError("Failed to calculate asset bounds data for extents check on " .. assetType.Name)

		return
	end

	for k, v in pairs(v41.subParts) do
		local v48 = Constants.BODYPART_TO_PARENT[k]

		if v48 ~= nil then
			local k2 = rootInstance:FindFirstChild(k)
			local v50 = rootInstance:FindFirstChild(v48)

			if k2 and v50 then
				local v51 = v50

				if t3[k] then
					v51 = k2
					k2 = v50
				end

				local name = v.rigAttachmentToParent.name
				local v53 = true

				if v45[v51.Name] and v45[k2.Name] then
					v53 = validateBasedOnBBoxes(v51, k2, v45, name, p7)
				end

				if v53 and t4[assetType] then
					validateBasedOnAttachmentYPos(v51, k2, name, p7)
				end
			end
		end
	end
end

return t1
