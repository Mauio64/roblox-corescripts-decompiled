require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Common/AbuseVector")
require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/ModerationCommon/Types")
local showFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Utils/showFeatureRestriction")
local showFeatureRestrictionDirect = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalFeatureRestrictions/UniversalFeatureRestrictions/Utils/showFeatureRestrictionDirect")

local function hasContent(value): boolean
	return type(value) == "string" and value ~= ""
end

local function buildEndDate(data)
	if data.type == "nudge" then
		return "", 0
	end

	local timeoutStartTime = data.timeoutStartTime
	local timeoutDurationSeconds = data.timeoutDurationSeconds

	if
		not timeoutStartTime
		or timeoutStartTime == ""
		or not timeoutDurationSeconds
		or timeoutDurationSeconds < 0
	then
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

local function buildModerationDetail(data, endDate, p2)
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
		duration = p2,
		acknowledgeable = false,
		showUGCAvatarGuidelinesLink = false,
		labelTranslationKey = ""
	}
end

local function showFeatureRestrictionFromRealtime(p2, data, options)
	if not data.acknowledgeable and (data.type == "nudge" or data.type == "timeout") then
		local decisionEventId = data.decisionEventId
		local v5 = type(decisionEventId) == "string" and decisionEventId ~= ""

		if v5 then
			local title = data.title
			local v6 = type(title) == "string" and title ~= ""

			if v6 then
				local body = data.body
				local v7 = type(body) == "string" and body ~= ""

				if v7 then
					local endDate, v8 = buildEndDate(data)

					if endDate == nil or v8 == nil then
						showFeatureRestriction(p2, options)
						return
					end

					local clone = table.clone(options or {})
					clone.analyticsEventId = data.decisionEventId

					showFeatureRestrictionDirect(p2, buildModerationDetail(data, endDate, v8), clone)

					return
				end
			end
		end
	end

	showFeatureRestriction(p2, options)
end

return showFeatureRestrictionFromRealtime
