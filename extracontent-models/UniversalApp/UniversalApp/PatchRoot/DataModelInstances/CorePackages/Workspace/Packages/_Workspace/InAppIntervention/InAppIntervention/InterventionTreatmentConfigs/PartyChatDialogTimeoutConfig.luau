local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local InAppInterventionParent = InAppIntervention.Parent
local Constants = require(InAppInterventionParent.InterventionShared).Utils.Constants

require(InAppIntervention.Utils.Types)

local InterventionAnalytics = require(InAppInterventionParent.InterventionShared).InterventionAnalytics
local partyChatTimeoutReceivedSignal = require(InAppInterventionParent.InterventionShared).Signals.partyChatTimeoutReceivedSignal

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(p1, p2) -- line: 11
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatTimeout and (p1.abuseVector == Constants.AbuseVectorType.PartyChat and not p2.isUserInExperience)
	end,
	shouldTriggerBehavioralTreatment = function(p3) -- line: 16
		-- upvalues: Constants (copy)
		return p3.type == Constants.NotificationDialogType.ChatTimeout and p3.abuseVector == Constants.AbuseVectorType.PartyChat
	end,
	shouldTriggerEventReceived = function(p4, p5) -- line: 20
		-- upvalues: Constants (copy)
		return p4.type == Constants.NotificationDialogType.ChatTimeout and (p4.abuseVector == Constants.AbuseVectorType.PartyChat and not p5.isUserInExperience)
	end,
	onTriggerVisualTreatment = function(_, p7: ((...any) -> ...any), p8) -- line: 25
		-- upvalues: Constants (copy)
		p7({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
			endTime = DateTime.now().UnixTimestamp + p8.timeoutDurationSeconds,
			interventionDetail = p8
		})
	end,
	onTriggerBehavioralTreatment = function(p9) -- line: 38
		-- upvalues: partyChatTimeoutReceivedSignal (copy)
		partyChatTimeoutReceivedSignal:fire(p9.vectorTargetId)
	end,
	onTriggerEventReceived = function(p10) -- line: 41
		-- upvalues: InterventionAnalytics (copy), Constants (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p10.decisionEventId,
			duration = p10.timeoutDurationSeconds,
			placement = Constants.InterventionPlacementType.InApp
		})
	end
}
