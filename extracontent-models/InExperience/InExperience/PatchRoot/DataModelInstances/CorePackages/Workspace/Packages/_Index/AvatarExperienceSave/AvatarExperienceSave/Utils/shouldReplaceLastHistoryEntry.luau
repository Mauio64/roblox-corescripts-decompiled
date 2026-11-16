local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local getSubstateToTrackForChanges = require(script.Parent.getSubstateToTrackForChanges)
local assetOrderRelativelyEqual = require(script.Parent.assetOrderRelativelyEqual)

local tutils = require(parent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local Constants = AvatarExperienceCommon.Constants

local function shouldReplaceLastHistoryEntry(p, p2)
	return not tutils.deepEqual(getSubstateToTrackForChanges(p, false), getSubstateToTrackForChanges(p2, false))
		and tutils.deepEqual(getSubstateToTrackForChanges(p, true), getSubstateToTrackForChanges(p2, true))
		and assetOrderRelativelyEqual(p, p2, Constants.LAYERED_ASSET_TYPES)
		and assetOrderRelativelyEqual(p, p2, Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)
end

return shouldReplaceLastHistoryEntry
