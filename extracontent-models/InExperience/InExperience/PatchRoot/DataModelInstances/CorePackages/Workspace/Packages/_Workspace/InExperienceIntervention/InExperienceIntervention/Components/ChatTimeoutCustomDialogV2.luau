local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local React = require(InExperienceInterventionParent.React)
local AppUserLayers = require(InExperienceInterventionParent.ExperimentLayers).AppUserLayers
local GenericInterventionDialog = require(InExperienceInterventionParent.InterventionShared).Components.GenericInterventionDialog
local useTimeoutInfoBinding = require(InExperienceInterventionParent.InterventionShared).Hooks.useTimeoutInfoBinding
local InterventionAnalytics = require(InExperienceInterventionParent.InterventionShared).InterventionAnalytics
local useParsedBadUtterances = require(InExperienceInterventionParent.InterventionShared).Hooks.useParsedBadUtterances
local v11 = require(InExperienceInterventionParent.RobloxAppLocales).Localization.new(LocalizationService.RobloxLocaleId)
local FFlagNotApprovedPageIXPExposure = require(InExperienceInterventionParent.SharedFlags).FFlagNotApprovedPageIXPExposure

require(InExperienceIntervention.Utils.Types)

local function ChatTimeoutCustomDialogV2(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy), useTimeoutInfoBinding (copy), useParsedBadUtterances (copy), v11 (copy), GenericInterventionDialog (copy), InterventionAnalytics (copy)
	local moderationDetail = t1.moderationDetail

	React.useEffect(function() -- line: 37
		-- upvalues: FFlagNotApprovedPageIXPExposure (copy), IXPService (copy), AppUserLayers (copy)
		if FFlagNotApprovedPageIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.NotApprovedPageUserIDLayer)
		end
	end, {})

	local v16 = useTimeoutInfoBinding(moderationDetail.endDate, moderationDetail.duration)
	local heading = v16.heading
	local description = v16.description
	local consequenceTransparencyMessage = moderationDetail.consequenceTransparencyMessage
	local interventionId = moderationDetail.interventionId
	local acknowledgeable = moderationDetail.acknowledgeable
	local badUtterances = moderationDetail.badUtterances
	local v23 = useParsedBadUtterances(badUtterances or {})
	local v24 = table.concat(v23.textItems, "\n")
	local v25 = table.concat(v23.abuseTypes, ", ")

	if v25 == "" then
		v25 = v11:Format("Feature.NotApproved.Label.AbuseType.Other")
	end

	return React.createElement(GenericInterventionDialog, {
		isAppealable = true,
		titleText = heading:map(function(p1) -- line: 62
			return p1
		end),
		bodyText = description:map(function(p2) -- line: 66
			return p2
		end),
		evidence = v24,
		violationReason = v25,
		onDismiss = t1.onDismiss,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = interventionId,
		durationForAnalytics = moderationDetail.duration / 1000000000,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.Timeout
	})
end

return React.memo(ChatTimeoutCustomDialogV2)
