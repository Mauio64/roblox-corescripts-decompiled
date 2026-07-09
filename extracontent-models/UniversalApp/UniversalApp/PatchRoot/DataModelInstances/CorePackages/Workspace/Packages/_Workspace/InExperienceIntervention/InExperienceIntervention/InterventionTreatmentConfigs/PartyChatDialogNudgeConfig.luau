local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local InterventionAnalytics = require(InExperienceInterventionParent.InterventionShared).InterventionAnalytics

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(p1) -- line: 10
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatNudge and (p1.modalType == Constants.NotificationModalType.Dialog and p1.abuseVector == Constants.AbuseVectorType.PartyChat)
	end,
	shouldTriggerBehavioralTreatment = function(_) -- line: 15
		return false
	end,
	shouldTriggerEventReceived = function(p3) -- line: 18
		-- upvalues: Constants (copy)
		return p3.type == Constants.NotificationDialogType.ChatNudge and (p3.modalType == Constants.NotificationModalType.Dialog and p3.abuseVector == Constants.AbuseVectorType.PartyChat)
	end,
	onTriggerVisualTreatment = function(p4, p5) -- line: 23
		-- upvalues: Constants (copy)
		p4({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatNudgeDialog,
			detail = p5
		})
	end,
	onTriggerBehavioralTreatment = function(_) -- line: 31
	end,
	onTriggerEventReceived = function(p7) -- line: 32
		-- upvalues: InterventionAnalytics (copy), Constants (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p7.decisionEventId,
			duration = p7.timeoutDurationSeconds,
			placement = Constants.InterventionPlacementType.InExperience
		})
	end
}
