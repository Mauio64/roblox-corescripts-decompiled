local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local InAppInterventionParent = InAppIntervention.Parent
local Constants = require(InAppInterventionParent.InterventionShared).Utils.Constants

require(InAppIntervention.Utils.Types)

local InterventionAnalytics = require(InAppInterventionParent.InterventionShared).InterventionAnalytics

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(p1, p2) -- line: 10
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatNudge and (p1.modalType == Constants.NotificationModalType.Dialog and (p1.abuseVector == Constants.AbuseVectorType.PartyChat and not p2.isUserInExperience))
	end,
	shouldTriggerBehavioralTreatment = function(_) -- line: 16
		return false
	end,
	shouldTriggerEventReceived = function(p4, p5) -- line: 19
		-- upvalues: Constants (copy)
		return p4.type == Constants.NotificationDialogType.ChatNudge and (p4.modalType == Constants.NotificationModalType.Dialog and (p4.abuseVector == Constants.AbuseVectorType.PartyChat and not p5.isUserInExperience))
	end,
	onTriggerVisualTreatment = function(_, p7: ((...any) -> ...any), p8) -- line: 25
		-- upvalues: Constants (copy)
		p7({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatNudgeDialog,
			interventionDetail = p8
		})
	end,
	onTriggerBehavioralTreatment = function(_) -- line: 37
	end,
	onTriggerEventReceived = function(p10) -- line: 38
		-- upvalues: InterventionAnalytics (copy), Constants (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p10.decisionEventId,
			duration = p10.timeoutDurationSeconds,
			placement = Constants.InterventionPlacementType.InApp
		})
	end
}
