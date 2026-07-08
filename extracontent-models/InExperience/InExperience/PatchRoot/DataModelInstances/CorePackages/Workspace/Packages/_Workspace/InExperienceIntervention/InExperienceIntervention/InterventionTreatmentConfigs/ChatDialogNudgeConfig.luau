local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)

return {
	configName = "ChatDialogNudge",
	shouldTriggerVisualTreatment = function(p1) -- line: 10
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatNudge and (p1.modalType == Constants.NotificationModalType.Dialog and (p1.abuseVector == Constants.AbuseVectorType.ExperienceChat and not p1.acknowledgeable))
	end,
	shouldTriggerBehavioralTreatment = function(_) -- line: 16
		return false
	end,
	shouldTriggerEventReceived = function(p3) -- line: 19
		-- upvalues: Constants (copy)
		return p3.type == Constants.NotificationDialogType.ChatNudge and (p3.modalType == Constants.NotificationModalType.Dialog and p3.abuseVector == Constants.AbuseVectorType.ExperienceChat)
	end,
	onTriggerVisualTreatment = function(p4, p5) -- line: 24
		-- upvalues: Constants (copy)
		p4({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.ChatNudgeDialog,
			detail = p5
		})
	end,
	onTriggerBehavioralTreatment = function(_) -- line: 32
	end,
	onTriggerEventReceived = function(p7) -- line: 33
		-- upvalues: InExperienceInterventionAnalytics (copy)
		InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.ModalMessageReceived, InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge, DateTime.now().UnixTimestampMillis, p7.decisionEventId, p7.evidence, p7.timeoutDurationSeconds)
	end
}
