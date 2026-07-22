local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local tutils = require(AvatarExperienceSaveParent.tutils)
local AvatarExperienceCommon = require(AvatarExperienceSaveParent.AvatarExperienceCommon)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local getSubstateToTrackForChanges = require(AvatarExperienceSave.Utils.getSubstateToTrackForChanges)
local assetOrderRelativelyEqual = require(AvatarExperienceSave.Utils.assetOrderRelativelyEqual)
local Constants = AvatarExperienceCommon.Constants

require(AvatarExperienceSaveParent.AvatarExperienceRodux)

local function shouldInsertNewHistoryEntry(p1, p2) -- line: 18
	-- upvalues: getSubstateToTrackForChanges (copy), tutils (copy), assetOrderRelativelyEqual (copy), Constants (copy), ItemTypeEnum (copy)
	local v12 = getSubstateToTrackForChanges(p1, true)
	local v13 = getSubstateToTrackForChanges(p2, true)

	if tutils.deepEqual(v12, v13) and (assetOrderRelativelyEqual(p1, p2, Constants.LAYERED_ASSET_TYPES) and assetOrderRelativelyEqual(p1, p2, Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)) then
		return false
	end

	for _, v15 in v13.OutfitTryOn.TryOnItems or {} do
		if v15.itemType == ItemTypeEnum.Bundle and tutils.fieldCount(v15.bundleInfo or {}) == 0 then
			return false
		end
	end

	return true
end

return shouldInsertNewHistoryEntry
