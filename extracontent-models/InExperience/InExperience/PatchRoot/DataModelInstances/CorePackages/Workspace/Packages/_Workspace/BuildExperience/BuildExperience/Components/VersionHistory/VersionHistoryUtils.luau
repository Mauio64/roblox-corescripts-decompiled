local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local VersionHistoryConstants = require(script.Parent.VersionHistoryConstants)
local PublishStatus = PlaceVersionHistory.PublishStatus
local SaveType = PlaceVersionHistory.SaveType

return {
	formatVersionNumber = function(n1: number) -- line: 14
		-- upvalues: LocalizationStrings (copy)
		return LocalizationStrings.formatVersionHistoryVersionNumber(n1)
	end,
	getBadgeText = function(p1) -- line: 18
		-- upvalues: PublishStatus (copy), LocalizationStrings (copy), SaveType (copy), VersionHistoryConstants (copy)
		if p1.publishStatus == PublishStatus.Live then
			return LocalizationStrings.VERSION_HISTORY_PUBLISHED
		end

		if p1.publishStatus == PublishStatus.PreviouslyPublished then
			return LocalizationStrings.VERSION_HISTORY_PREVIOUSLY_PUBLISHED
		end

		if p1.parentAssetVersionId ~= nil then
			return LocalizationStrings.formatVersionHistoryRestoredBadge(p1.parentAssetVersionId)
		end

		if p1.saveType == SaveType.AutoSave then
			return VersionHistoryConstants.AUTOSAVED_BADGE_TEXT
		end

		return nil
	end,
	shouldShowEntry = function(s1: string?, b1: boolean) -- line: 32
		-- upvalues: VersionHistoryConstants (copy)
		return not b1 or s1 ~= VersionHistoryConstants.AUTOSAVED_BADGE_TEXT
	end
}
