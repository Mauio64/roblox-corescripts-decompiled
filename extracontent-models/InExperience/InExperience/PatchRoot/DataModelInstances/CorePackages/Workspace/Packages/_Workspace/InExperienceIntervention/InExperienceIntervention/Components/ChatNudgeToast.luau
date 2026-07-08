local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatInterventionGenericToast = require(InExperienceIntervention.Components.ChatInterventionGenericToast)

function ChatNudgeToast(t1: {[any]: any}) -- line: 14
	-- upvalues: useLocalization (copy), Constants (copy), React (copy), ChatInterventionGenericToast (copy), InExperienceInterventionAnalytics (copy)
	local v9 = useLocalization(Constants.localizationKeys)

	return React.createElement(ChatInterventionGenericToast, {
		eventId = t1.eventId,
		violatingChatLine = t1.violatingChatLine,
		toastTitle = v9.ChatBreaksRulesText,
		toastBody = v9.TextChatMayBeSuspendedText,
		interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
		toastAppearEventName = InExperienceInterventionAnalytics.Constants.EventTypes.NudgeToastAppeared,
		toastDismissEventName = InExperienceInterventionAnalytics.Constants.EventTypes.NudgeToastDismissed
	})
end

return ChatNudgeToast
