local parent = script:FindFirstAncestor("InterventionShared").Parent

local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)

local v = {
	{
		unitInSeconds = 86400,
		singularKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Day",
		pluralKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Days"
	},
	{
		unitInSeconds = 3600,
		singularKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Hour",
		pluralKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Hours"
	},
	{
		unitInSeconds = 60,
		singularKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Minute",
		pluralKey = "Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Suspended.Minutes"
	}
}

local function parseErrorDetails(data)
	if data == nil then
		return {
			beginTimestamp = "",
			endTimestamp = "",
			labelTranslationKey = "",
			durationSeconds = nil
		}
	end

	return {
		beginTimestamp = data.beginTimestamp or "",
		endTimestamp = data.endTimestamp or "",
		labelTranslationKey = data.labelTranslationKey or "",
		durationSeconds = tonumber(data.durationSeconds)
	}
end

local function buildModerationDetail(messageToUser: string, data)
	return {
		messageToUser = messageToUser,
		beginDate = data.beginTimestamp,
		endDate = data.endTimestamp,
		duration = data.durationSeconds,
		labelTranslationKey = data.labelTranslationKey,
		interventionId = "",
		punishedUserId = 0,
		punishmentId = 0,
		punishmentTypeDescription = "",
		badUtterances = {},
		context = {},
		verificationCategory = "",
		consequenceTransparencyMessage = "",
		showAppealsProcessLink = false,
		isForeshadowingConsequenceEnabled = false,
		violation = nil,
		acknowledgeable = false,
		showUGCAvatarGuidelinesLink = false
	}
end

local function pickTitleAndBody(callback, durationSeconds: number?)
	if durationSeconds == nil or durationSeconds <= 0 then
		return {
			title = callback("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Banned"),
			body = callback("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Banned")
		}
	end

	for _, v2 in v do
		if v2.unitInSeconds <= durationSeconds then
			local number = math.ceil(durationSeconds / v2.unitInSeconds)
			local v3

			if number == 1 then
				v3 = v2.singularKey
			else
				v3 = v2.pluralKey
			end

			return {
				title = callback(v3, { number = number }),
				body = callback("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Suspended")
			}
		end
	end

	return {
		title = callback(v[3].singularKey, { number = 1 }),
		body = callback("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Suspended")
	}
end

local function buildRobloxExperienceKickContent(messageToUser: string, p, callback)
	local v2 = parseErrorDetails(p)
	local moderationDetail = buildModerationDetail(messageToUser, v2)
	local v3 = pickTitleAndBody(callback, v2.durationSeconds)

	return {
		abuseVector = AbuseVector.RobloxExperienceKick,
		moderationDetail = moderationDetail,
		options = { titleOverride = v3.title, bodyOverride = v3.body }
	}
end

return buildRobloxExperienceKickContent
