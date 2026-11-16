local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceCommon")

local getSubstateToTrackForChanges = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/getSubstateToTrackForChanges")
local assetOrderRelativelyEqual = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Utils/assetOrderRelativelyEqual")

local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local constants = AvatarExperienceCommon.Constants

local function shouldReplaceLastHistoryEntry(p2, p3)
	return not tutils.deepEqual(getSubstateToTrackForChanges(p2, false), getSubstateToTrackForChanges(p3, false))
		and tutils.deepEqual(getSubstateToTrackForChanges(p2, true), getSubstateToTrackForChanges(p3, true))
		and assetOrderRelativelyEqual(p2, p3, constants.LAYERED_ASSET_TYPES)
		and assetOrderRelativelyEqual(p2, p3, constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)
end

return shouldReplaceLastHistoryEntry
