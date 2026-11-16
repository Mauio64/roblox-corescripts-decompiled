local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local React = require(parent.React)
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatInterventionGenericToast = require(InExperienceIntervention.Components.ChatInterventionGenericToast)

function ChatNudgeToast(p)
	local v = useLocalization(Constants.localizationKeys)

	return React.createElement(ChatInterventionGenericToast, {
		eventId = p.eventId,
		violatingChatLine = p.violatingChatLine,
		toastTitle = v.ChatBreaksRulesText,
		toastBody = v.TextChatMayBeSuspendedText,
		interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
		toastAppearEventName = InExperienceInterventionAnalytics.Constants.EventTypes.NudgeToastAppeared,
		toastDismissEventName = InExperienceInterventionAnalytics.Constants.EventTypes.NudgeToastDismissed
	})
end

return ChatNudgeToast
