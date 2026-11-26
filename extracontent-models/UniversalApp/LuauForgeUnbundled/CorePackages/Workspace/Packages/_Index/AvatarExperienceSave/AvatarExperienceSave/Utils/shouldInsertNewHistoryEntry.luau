local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceCommon")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceModel")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local getSubstateToTrackForChanges = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/getSubstateToTrackForChanges")
local assetOrderRelativelyEqual = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/assetOrderRelativelyEqual")

local constants = AvatarExperienceCommon.Constants

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceRodux")

local function shouldInsertNewHistoryEntry(p2, p3): boolean
	local v5 = getSubstateToTrackForChanges(p2, true)
	local v6 = getSubstateToTrackForChanges(p3, true)

	if
		tutils.deepEqual(v5, v6)
		and assetOrderRelativelyEqual(p2, p3, constants.LAYERED_ASSET_TYPES)
		and assetOrderRelativelyEqual(p2, p3, constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)
	then
		return false
	end

	for k, v8 in v6.OutfitTryOn.TryOnItems or {} do
		if v8.itemType == itemTypeEnum.Bundle and tutils.fieldCount(v8.bundleInfo or {}) == 0 then
			return false
		end
	end

	return true
end

return shouldInsertNewHistoryEntry
