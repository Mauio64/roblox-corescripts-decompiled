local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

local tutils = require(parent.tutils)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)

require(AvatarExperienceSave.Context.AvatarSaveContext)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local getSubstateToTrackForChanges = require(AvatarExperienceSave.Utils.getSubstateToTrackForChanges)
local assetOrderRelativelyEqual = require(AvatarExperienceSave.Utils.assetOrderRelativelyEqual)

local Constants = AvatarExperienceCommon.Constants

require(parent.AvatarExperienceRodux)

local function shouldInsertNewHistoryEntry(p, p2): boolean
	local substateToTrackForChanges = getSubstateToTrackForChanges(p, true)
	local substateToTrackForChanges2 = getSubstateToTrackForChanges(p2, true)

	if
		tutils.deepEqual(substateToTrackForChanges, substateToTrackForChanges2)
		and assetOrderRelativelyEqual(p, p2, Constants.LAYERED_ASSET_TYPES)
		and assetOrderRelativelyEqual(p, p2, Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)
	then
		return false
	end

	for _, v in substateToTrackForChanges2.OutfitTryOn.TryOnItems or {} do
		if v.itemType == ItemTypeEnum.Bundle and tutils.fieldCount(v.bundleInfo or {}) == 0 then
			return false
		end
	end

	return true
end

return shouldInsertNewHistoryEntry
