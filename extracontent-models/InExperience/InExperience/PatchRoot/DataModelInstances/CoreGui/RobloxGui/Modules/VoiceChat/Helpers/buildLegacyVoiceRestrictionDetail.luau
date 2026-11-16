local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.ModerationCommon.Types)

require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController)

local function buildLegacyVoiceRestrictionDetail(data)
	local settings = data.settings
	local format = data.format

	local endDate = ""
	local formatted, formatted2, punishmentTypeDescription

	if settings then
		if settings.bannedUntil then
			local number = math.max(1, (math.ceil((settings.bannedUntil.Seconds - data.now) / 60)))

			formatted = format("Feature.UniversalFeatureRestrictions.Generic.DialogBody.Suspended")
			formatted2 = format(
				number == 1 and "Feature.UniversalFeatureRestrictions.Generic.DialogTitleV2.Suspended.Minute" or "Feature.UniversalFeatureRestrictions.Generic.DialogTitleV2.Suspended.Minutes",
				{
					abuseVector = format("Feature.UniversalFeatureRestrictions.AbuseVector.LabelName.Voice"),
					number = number
				}
			)

			endDate = DateTime.fromUnixTimestamp(settings.bannedUntil.Seconds):ToIsoDate()
			punishmentTypeDescription = "timeout"
		else
			formatted = format("Feature.UniversalFeatureRestrictions.Generic.DialogBody.Banned")
			formatted2 = format("Feature.UniversalFeatureRestrictions.Generic.DialogTitle.Banned", {
				abuseVector = format("Feature.UniversalFeatureRestrictions.AbuseVector.Lowercase.LabelName.Voice")
			})
			punishmentTypeDescription = "ban"
		end
	else
		formatted = format("Feature.UniversalFeatureRestrictions.Generic.DialogBody.Nudge")
		formatted2 = format("Feature.UniversalFeatureRestrictions.Generic.DialogTitleV2.Nudge", {
			abuseVector = format("Feature.UniversalFeatureRestrictions.AbuseVector.Lowercase.LabelName.Voice")
		})
		punishmentTypeDescription = "nudge"
	end

	return {
		punishmentId = 0,
		punishedUserId = data.userId,
		interventionId = "",
		messageToUser = "",
		title = formatted2,
		body = formatted,
		punishmentTypeDescription = punishmentTypeDescription,
		acknowledgeable = false,
		beginDate = "",
		endDate = endDate,
		badUtterances = {},
		context = {},
		verificationCategory = "",
		consequenceTransparencyMessage = "",
		showAppealsProcessLink = false,
		isForeshadowingConsequenceEnabled = false,
		showUGCAvatarGuidelinesLink = false,
		labelTranslationKey = ""
	}
end

return buildLegacyVoiceRestrictionDetail
