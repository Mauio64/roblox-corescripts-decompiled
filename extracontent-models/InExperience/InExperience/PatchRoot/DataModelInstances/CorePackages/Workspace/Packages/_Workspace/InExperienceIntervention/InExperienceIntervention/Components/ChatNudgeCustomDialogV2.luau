local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local React = require(InExperienceInterventionParent.React)
local AppUserLayers = require(InExperienceInterventionParent.ExperimentLayers).AppUserLayers
local GenericInterventionDialog = require(InExperienceInterventionParent.InterventionShared).Components.GenericInterventionDialog
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local InterventionAnalytics = require(InExperienceInterventionParent.InterventionShared).InterventionAnalytics
local useParsedBadUtterances = require(InExperienceInterventionParent.InterventionShared).Hooks.useParsedBadUtterances
local v11 = require(InExperienceInterventionParent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local FFlagNotApprovedPageIXPExposure = require(InExperienceInterventionParent.SharedFlags).FFlagNotApprovedPageIXPExposure
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local function ChatNudgeCustomDialogV2(t1: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), Constants (copy), React (copy), FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy), useParsedBadUtterances (copy), v11 (copy), GenericInterventionDialog (copy), InterventionAnalytics (copy)
	local v16 = useLocalization(Constants.localizationKeys)

	React.useEffect(function() -- line: 34
		-- upvalues: FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy)
		if FFlagNotApprovedPageIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.NotApprovedPageUserIDLayer)
		end
	end, {})

	local moderationDetail = t1.moderationDetail
	local consequenceTransparencyMessage = moderationDetail.consequenceTransparencyMessage
	local interventionId = moderationDetail.interventionId
	local acknowledgeable = moderationDetail.acknowledgeable
	local badUtterances = moderationDetail.badUtterances
	local v22 = useParsedBadUtterances(badUtterances or {})
	local v23 = table.concat(v22.textItems, "\n")
	local v24 = table.concat(v22.abuseTypes, ", ")

	if v24 == "" then
		v24 = v11:Format("Feature.NotApproved.Label.AbuseType.Other")
	end

	return React.createElement(GenericInterventionDialog, {
		isAppealable = true,
		titleText = v16.ChatBreaksRulesText,
		bodyText = v16.TextChatMayBeSuspendedText,
		evidence = v23,
		violationReason = v24,
		onDismiss = t1.onDismiss,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = interventionId,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.Nudge
	})
end

return React.memo(ChatNudgeCustomDialogV2)
