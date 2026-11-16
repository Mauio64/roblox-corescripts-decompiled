local UniversalFeatureRestrictions = script:FindFirstAncestor("UniversalFeatureRestrictions")
local parent = UniversalFeatureRestrictions.Parent

require(UniversalFeatureRestrictions.Common.AbuseVector)
require(parent.ModerationCommon.Types)
local showFeatureRestriction = require(UniversalFeatureRestrictions.Utils.showFeatureRestriction)
local showFeatureRestrictionDirect = require(UniversalFeatureRestrictions.Utils.showFeatureRestrictionDirect)

local function hasContent(value): boolean -- 3 equivalent calls inferred from this helper
	return type(value) == "string" and value ~= ""
end

local function buildEndDate(data)
	if data.type == "nudge" then
		return "", 0
	end

	local timeoutStartTime = data.timeoutStartTime
	local timeoutDurationSeconds = data.timeoutDurationSeconds

	if not timeoutStartTime or timeoutStartTime == "" or not timeoutDurationSeconds or timeoutDurationSeconds < 0 then
		return nil, nil
	end

	if timeoutDurationSeconds == 0 then
		return "", timeoutDurationSeconds
	end

	local dateTime = DateTime.fromIsoDate(timeoutStartTime)

	if dateTime then
		return
			DateTime.fromUnixTimestamp(dateTime.UnixTimestamp + timeoutDurationSeconds):ToIsoDate(),
			timeoutDurationSeconds
	end

	return nil, nil
end

local function buildModerationDetail(data, endDate: string, duration: number)
	return {
		punishedUserId = 0,
		interventionId = "",
		punishmentId = 0,
		messageToUser = "",
		title = data.title,
		body = data.body,
		punishmentTypeDescription = data.type,
		beginDate = data.timeoutStartTime or "",
		endDate = endDate,
		badUtterances = {},
		context = {},
		verificationCategory = "",
		consequenceTransparencyMessage = "",
		showAppealsProcessLink = false,
		isForeshadowingConsequenceEnabled = false,
		violation = nil,
		duration = duration,
		acknowledgeable = false,
		showUGCAvatarGuidelinesLink = false,
		labelTranslationKey = ""
	}
end

local function showFeatureRestrictionFromRealtime(p, data, options)
	if
		not data.acknowledgeable
		and (data.type == "nudge" or data.type == "timeout")
		and hasContent(data.decisionEventId) -- inferred equivalent call
		and hasContent(data.title) -- inferred equivalent call
		and hasContent(data.body) -- inferred equivalent call
	then
		local endDate, duration = buildEndDate(data)

		if endDate == nil or duration == nil then
			showFeatureRestriction(p, options)
			return
		end

		local clone = table.clone(options or {})
		clone.analyticsEventId = data.decisionEventId

		showFeatureRestrictionDirect(p, buildModerationDetail(data, endDate, duration), clone)

		return
	end

	showFeatureRestriction(p, options)
end

return showFeatureRestrictionFromRealtime
