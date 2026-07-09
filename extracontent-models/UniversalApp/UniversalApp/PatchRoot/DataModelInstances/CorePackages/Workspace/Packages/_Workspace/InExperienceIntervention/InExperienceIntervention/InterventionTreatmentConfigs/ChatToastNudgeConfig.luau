local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)

return {
	configName = "ChatToastNudge",
	shouldTriggerVisualTreatment = function(p1) -- line: 10
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatNudge and (p1.modalType == Constants.NotificationModalType.Toast and p1.abuseVector == Constants.AbuseVectorType.ExperienceChat)
	end,
	shouldTriggerBehavioralTreatment = function(_) -- line: 15
		return false
	end,
	shouldTriggerEventReceived = function(p3) -- line: 18
		-- upvalues: Constants (copy)
		return p3.type == Constants.NotificationDialogType.ChatNudge and (p3.modalType == Constants.NotificationModalType.Toast and p3.abuseVector == Constants.AbuseVectorType.ExperienceChat)
	end,
	onTriggerVisualTreatment = function(p4, p5) -- line: 23
		-- upvalues: Constants (copy)
		p4({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.ChatNudgeToast,
			detail = p5
		})
	end,
	onTriggerBehavioralTreatment = function(_) -- line: 31
	end,
	onTriggerEventReceived = function(p7) -- line: 32
		-- upvalues: InExperienceInterventionAnalytics (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.ToastMessageReceived, InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge, DateTime.now().UnixTimestampMillis, p7.decisionEventId, p7.evidence, p7.timeoutDurationSeconds)
	end
}
