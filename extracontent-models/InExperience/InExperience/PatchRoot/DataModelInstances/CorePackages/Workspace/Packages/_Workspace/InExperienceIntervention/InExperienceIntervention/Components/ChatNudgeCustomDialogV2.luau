local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local InterventionShared = require(parent.InterventionShared)
local GenericInterventionDialog = InterventionShared.Components.GenericInterventionDialog
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local InterventionShared2 = require(parent.InterventionShared)
local InterventionAnalytics = InterventionShared2.InterventionAnalytics
local InterventionShared3 = require(parent.InterventionShared)
local useParsedBadUtterances = InterventionShared3.Hooks.useParsedBadUtterances
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)

local SharedFlags = require(parent.SharedFlags)
local FFlagNotApprovedPageIXPExposure = SharedFlags.FFlagNotApprovedPageIXPExposure

local InterventionShared4 = require(parent.InterventionShared)
local Constants = InterventionShared4.Utils.Constants
require(InExperienceIntervention.Utils.Types)

local function ChatNudgeCustomDialogV2(p)
	local v = useLocalization(Constants.localizationKeys)

	React.useEffect(function()
		if FFlagNotApprovedPageIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.NotApprovedPageUserIDLayer)
		end
	end, {})

	local moderationDetail = p.moderationDetail
	local consequenceTransparencyMessage = moderationDetail.consequenceTransparencyMessage
	local interventionId = moderationDetail.interventionId
	local acknowledgeable = moderationDetail.acknowledgeable
	local v2 = useParsedBadUtterances(moderationDetail.badUtterances or {}, {
		shouldAddPlayerName = true
	})

	local joined = table.concat(v2.textItems, "\n")
	local violationReason = table.concat(v2.abuseTypes, ", ")

	if violationReason == "" then
		violationReason = localization:Format("Feature.NotApproved.Label.AbuseType.Other")
	end

	return React.createElement(GenericInterventionDialog, {
		titleText = v.ChatBreaksRulesText,
		isAppealable = true,
		bodyText = v.TextChatMayBeSuspendedText,
		evidence = joined,
		violationReason = violationReason,
		onDismiss = p.onDismiss,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = interventionId,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.Nudge
	})
end

return React.memo(ChatNudgeCustomDialogV2)
