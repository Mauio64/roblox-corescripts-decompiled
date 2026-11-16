local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")

local VersionHistoryConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryConstants")

local publishStatus = PlaceVersionHistory.PublishStatus
local saveType = PlaceVersionHistory.SaveType

local function toNumber(value)
	if type(value) == "number" then
		return value
	end

	if type(value) == "string" then
		return (tonumber(value))
	end

	return nil
end

return {
	getBadgeKind = function(data): nil | string
		if data.publishStatus == publishStatus.Live then
			return "published"
		end

		if data.publishStatus == publishStatus.PreviouslyPublished then
			return "previouslyPublished"
		end

		if data.parentAssetVersionId ~= nil then
			return "restored"
		end

		if data.saveType == saveType.AutoSave then
			return "autosaved"
		end

		return nil
	end,
	getCreatedDateParts = function(value)
		local v5 = type(value) == "string" and value ~= ""
		assert(v5, "Place version createdTime must not be empty")

		local v6, v7, v8 = string.match(value, "^(%d%d%d%d)%-(%d%d)%-(%d%d)")
		local v9 = if v7 then tonumber(v7) else nil
		local v10 = if v8 then tonumber(v8) else nil
		local v11 = v6 ~= nil and v9 ~= nil and v10 ~= nil
		assert(v11, `Place version createdTime must be an ISO date: {value}`)

		return v9, v10, v6
	end,
	getVersionNumber = function(p2)
		local version = p2.version

		if type(version) ~= "number" then
			version = if type(version) == "string" then tonumber(version) else nil
		end

		assert(version ~= nil, `Place version must be numeric: {p2.version}`)

		return version
	end,
	shouldShowEntry = function(p2, p3): boolean
		return not p3 or p2 ~= VersionHistoryConstants.AUTOSAVED_BADGE_TEXT
	end
}
