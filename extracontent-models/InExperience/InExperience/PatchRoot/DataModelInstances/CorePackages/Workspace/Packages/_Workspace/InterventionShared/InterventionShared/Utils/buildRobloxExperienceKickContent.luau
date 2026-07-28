local Parent = script:FindFirstAncestor("InterventionShared").Parent
local AbuseVector = require(Parent.UniversalFeatureRestrictions.AbuseVector)
local t1 = {
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

local function parseErrorDetails(t2: {[any]: any}?) -- line: 37
	if t2 == nil then
		return {
			beginTimestamp = "",
			endTimestamp = "",
			labelTranslationKey = "",
			durationSeconds = nil
		}
	end

	return {
		beginTimestamp = t2.beginTimestamp or "",
		endTimestamp = t2.endTimestamp or "",
		labelTranslationKey = t2.labelTranslationKey or "",
		durationSeconds = tonumber(t2.durationSeconds)
	}
end
local function buildModerationDetail(s1: string, t3: {[any]: any}) -- line: 55
	return {
		interventionId = "",
		punishedUserId = 0,
		punishmentId = 0,
		punishmentTypeDescription = "",
		verificationCategory = "",
		consequenceTransparencyMessage = "",
		showAppealsProcessLink = false,
		isForeshadowingConsequenceEnabled = false,
		violation = nil,
		acknowledgeable = false,
		showUGCAvatarGuidelinesLink = false,
		messageToUser = s1,
		beginDate = t3.beginTimestamp,
		endDate = t3.endTimestamp,
		duration = t3.durationSeconds,
		labelTranslationKey = t3.labelTranslationKey,
		badUtterances = {},
		context = {}
	}
end
local function pickTitleAndBody(p1: ((...any) -> ...any), n1: number?) -- line: 79
	-- upvalues: t1 (copy)
	if n1 == nil or n1 <= 0 then
		return {
			title = p1("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogTitle.Banned"),
			body = p1("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Banned")
		}
	end

	for _, v14 in t1 do
		if n1 >= v14.unitInSeconds then
			local v15 = math.ceil(n1 / v14.unitInSeconds)

			return {
				title = p1(if v15 ~= 1 then v14.pluralKey else v14.singularKey, {
					number = v15
				}),
				body = p1("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Suspended")
			}
		end
	end

	return {
		title = p1(t1[3].singularKey, {
			number = 1
		}),
		body = p1("Feature.UniversalFeatureRestrictions.AbuseVector.RobloxKick.DialogBody.Suspended")
	}
end
local function buildRobloxExperienceKickContent(s2: string, t4: {[any]: any}?, p2: ((...any) -> ...any)) -- line: 119
	-- upvalues: parseErrorDetails (copy), buildModerationDetail (copy), pickTitleAndBody (copy), AbuseVector (copy)
	local v19 = parseErrorDetails(t4)
	local v20 = buildModerationDetail(s2, v19)
	local v21 = pickTitleAndBody(p2, v19.durationSeconds)

	return {
		abuseVector = AbuseVector.RobloxExperienceKick,
		moderationDetail = v20,
		options = {
			titleOverride = v21.title,
			bodyOverride = v21.body
		}
	}
end

return buildRobloxExperienceKickContent
