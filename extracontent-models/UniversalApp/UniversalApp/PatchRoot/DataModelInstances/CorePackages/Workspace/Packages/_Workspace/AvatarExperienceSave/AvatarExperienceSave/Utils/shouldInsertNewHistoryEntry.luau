local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local tutils = require(AvatarExperienceSaveParent.tutils)
local AvatarExperienceCommon = require(AvatarExperienceSaveParent.AvatarExperienceCommon)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local getSubstateToTrackForChanges = require(AvatarExperienceSave.Utils.getSubstateToTrackForChanges)
local assetOrderRelativelyEqual = require(AvatarExperienceSave.Utils.assetOrderRelativelyEqual)
local FFlagAXCustomizeMakeupSupport = require(AvatarExperienceSaveParent.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local Constants = AvatarExperienceCommon.Constants

local function shouldInsertNewHistoryEntry(p1, p2) -- line: 16
	-- upvalues: getSubstateToTrackForChanges (copy), FFlagAXCustomizeMakeupSupport (copy), tutils (copy), assetOrderRelativelyEqual (copy), Constants (copy), ItemTypeEnum (copy)
	local v13 = getSubstateToTrackForChanges(p1, not not FFlagAXCustomizeMakeupSupport or nil)
	local v14 = getSubstateToTrackForChanges(p2, not not FFlagAXCustomizeMakeupSupport or nil)

	if tutils.deepEqual(v13, v14) and (not FFlagAXCustomizeMakeupSupport or assetOrderRelativelyEqual(p1, p2, Constants.LAYERED_ASSET_TYPES) and assetOrderRelativelyEqual(p1, p2, Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)) then
		return false
	end

	for _, v16 in v14.OutfitTryOn.TryOnItems or {} do
		if v16.itemType == ItemTypeEnum.Bundle and tutils.fieldCount(v16.bundleInfo or {}) == 0 then
			return false
		end
	end

	return true
end

return shouldInsertNewHistoryEntry
