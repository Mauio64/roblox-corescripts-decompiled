local parent = script:FindFirstAncestor("BuildExperience").Parent

local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)

local VersionHistoryConstants = require(script.Parent.VersionHistoryConstants)

local PublishStatus = PlaceVersionHistory.PublishStatus
local SaveType = PlaceVersionHistory.SaveType

local function toNumber(version) -- 1 equivalent call inferred from this helper
	if type(version) == "number" then
		return version
	end

	if type(version) == "string" then
		return (tonumber(version))
	end

	return nil
end

local VersionHistoryUtils = {}

function VersionHistoryUtils.getBadgeKind(data): nil | string
	if data.publishStatus == PublishStatus.Live then
		return "published"
	end

	if data.publishStatus == PublishStatus.PreviouslyPublished then
		return "previouslyPublished"
	end

	if data.parentAssetVersionId ~= nil then
		return "restored"
	end

	if data.saveType == SaveType.AutoSave then
		return "autosaved"
	end

	return nil
end

function VersionHistoryUtils.getCreatedDateParts(value: string?)
	local v = type(value) == "string" and value ~= ""
	assert(v, "Place version createdTime must not be empty")

	local v2, v3, v4 = string.match(value, "^(%d%d%d%d)%-(%d%d)%-(%d%d)")
	local v5

	if v3 then
		v5 = tonumber(v3)
	end

	local v6

	if v4 then
		v6 = tonumber(v4)
	end

	local v7 = v2 ~= nil and v5 ~= nil and v6 ~= nil
	assert(v7, `Place version createdTime must be an ISO date: {value}`)

	return v5, v6, v2
end

function VersionHistoryUtils.getVersionNumber(p)
	local versionNumber = toNumber(p.version) -- inferred equivalent call
	assert(versionNumber ~= nil, `Place version must be numeric: {p.version}`)

	return versionNumber
end

function VersionHistoryUtils.shouldShowEntry(p: string?, flag: boolean): boolean
	return not flag or p ~= VersionHistoryConstants.AUTOSAVED_BADGE_TEXT
end

return VersionHistoryUtils
