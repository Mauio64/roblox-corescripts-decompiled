local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local InterventionAnalytics = require(InExperienceInterventionParent.InterventionShared).InterventionAnalytics
local partyChatTimeoutReceivedSignal = require(InExperienceInterventionParent.InterventionShared).Signals.partyChatTimeoutReceivedSignal

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(p1) -- line: 11
		-- upvalues: Constants (copy)
		return p1.type == Constants.NotificationDialogType.ChatTimeout and p1.abuseVector == Constants.AbuseVectorType.PartyChat
	end,
	shouldTriggerBehavioralTreatment = function(p2) -- line: 15
		-- upvalues: Constants (copy)
		return p2.type == Constants.NotificationDialogType.ChatTimeout and p2.abuseVector == Constants.AbuseVectorType.PartyChat
	end,
	shouldTriggerEventReceived = function(p3) -- line: 19
		-- upvalues: Constants (copy)
		return p3.type == Constants.NotificationDialogType.ChatTimeout and p3.abuseVector == Constants.AbuseVectorType.PartyChat
	end,
	onTriggerVisualTreatment = function(p4, p5) -- line: 23
		-- upvalues: Constants (copy)
		p4({
			isShown = true,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
			endTime = DateTime.now().UnixTimestamp + p5.timeoutDurationSeconds,
			detail = p5
		})
	end,
	onTriggerBehavioralTreatment = function(p6) -- line: 32
		-- upvalues: partyChatTimeoutReceivedSignal (copy)
		partyChatTimeoutReceivedSignal:fire(p6.vectorTargetId)
	end,
	onTriggerEventReceived = function(p7) -- line: 35
		-- upvalues: InterventionAnalytics (copy), Constants (copy)
		InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p7.decisionEventId,
			duration = p7.timeoutDurationSeconds,
			placement = Constants.InterventionPlacementType.InExperience
		})
	end
}
