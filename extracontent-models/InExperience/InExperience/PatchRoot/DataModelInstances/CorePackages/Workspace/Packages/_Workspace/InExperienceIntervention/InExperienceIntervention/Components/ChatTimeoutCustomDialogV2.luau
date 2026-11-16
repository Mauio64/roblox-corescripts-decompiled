local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local InterventionShared = require(parent.InterventionShared)
local GenericInterventionDialog = InterventionShared.Components.GenericInterventionDialog
local InterventionShared2 = require(parent.InterventionShared)
local useTimeoutInfoBinding = InterventionShared2.Hooks.useTimeoutInfoBinding
local InterventionShared3 = require(parent.InterventionShared)
local InterventionAnalytics = InterventionShared3.InterventionAnalytics
local InterventionShared4 = require(parent.InterventionShared)
local useParsedBadUtterances = InterventionShared4.Hooks.useParsedBadUtterances
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization.new(LocalizationService.RobloxLocaleId)

local SharedFlags = require(parent.SharedFlags)
local FFlagNotApprovedPageIXPExposure = SharedFlags.FFlagNotApprovedPageIXPExposure

require(InExperienceIntervention.Utils.Types)

local function ChatTimeoutCustomDialogV2(p)
	local moderationDetail = p.moderationDetail

	React.useEffect(function()
		if FFlagNotApprovedPageIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.NotApprovedPageUserIDLayer)
		end
	end, {})

	local v = useTimeoutInfoBinding(moderationDetail.endDate, moderationDetail.duration)
	local heading = v.heading
	local description = v.description

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
		titleText = heading:map(function(p2)
			return p2
		end),
		isAppealable = true,
		bodyText = description:map(function(p2)
			return p2
		end),
		evidence = joined,
		violationReason = violationReason,
		onDismiss = p.onDismiss,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = interventionId,
		durationForAnalytics = moderationDetail.duration / 1000000000,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.Timeout
	})
end

return React.memo(ChatTimeoutCustomDialogV2)
