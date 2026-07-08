local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local AvatarExperienceCommon = require(AvatarExperienceSaveParent.AvatarExperienceCommon)
local getSubstateToTrackForChanges = require(script.Parent.getSubstateToTrackForChanges)
local assetOrderRelativelyEqual = require(script.Parent.assetOrderRelativelyEqual)
local tutils = require(AvatarExperienceSaveParent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local Constants = AvatarExperienceCommon.Constants

local function shouldReplaceLastHistoryEntry(p1, p2) -- line: 15
	-- upvalues: tutils (copy), getSubstateToTrackForChanges (copy), assetOrderRelativelyEqual (copy), Constants (copy)
	return not tutils.deepEqual(getSubstateToTrackForChanges(p1, false), getSubstateToTrackForChanges(p2, false)) and (tutils.deepEqual(getSubstateToTrackForChanges(p1, true), getSubstateToTrackForChanges(p2, true)) and (assetOrderRelativelyEqual(p1, p2, Constants.LAYERED_ASSET_TYPES) and assetOrderRelativelyEqual(p1, p2, Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE)))
end

return shouldReplaceLastHistoryEntry
