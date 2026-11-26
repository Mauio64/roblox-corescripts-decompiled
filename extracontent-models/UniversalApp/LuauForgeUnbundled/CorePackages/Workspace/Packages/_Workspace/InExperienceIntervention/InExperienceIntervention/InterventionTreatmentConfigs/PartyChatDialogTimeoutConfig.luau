local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/AbuseVector")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Utils.Constants
local interventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").InterventionAnalytics
local interventionTreatmentShownSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Signals.interventionTreatmentShownSignal
local partyChatTimeoutReceivedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Signals.partyChatTimeoutReceivedSignal

local showFeatureRestrictionFromRealtime = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/showFeatureRestrictionFromRealtime")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local fFlagAppChatUniversalFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/SharedFlags").FFlagAppChatUniversalFeatureRestriction

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/Utils/Types")

local function onPartyChatTimeoutUFRAppeal() end
local function onPartyChatTimeoutUFRShown()
	interventionTreatmentShownSignal:fire(constants.TreatmentType.PartyChatTimeoutDialog)
end
local function onPartyChatTimeoutAcknowledgementSuccess()
	partyChatTimeoutReceivedSignal:fire(nil)
end

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(p2, p3): boolean
		return p2.type == constants.NotificationDialogType.ChatTimeout
			and p2.abuseVector == constants.AbuseVectorType.PartyChat
			and not p3.isUserInExperience
	end,
	shouldTriggerBehavioralTreatment = function(p2): boolean
		return p2.type == constants.NotificationDialogType.ChatTimeout
			and p2.abuseVector == constants.AbuseVectorType.PartyChat
	end,
	shouldTriggerEventReceived = function(p2, p3): boolean
		return p2.type == constants.NotificationDialogType.ChatTimeout
			and p2.abuseVector == constants.AbuseVectorType.PartyChat
			and not p3.isUserInExperience
	end,
	onTriggerVisualTreatment = function(p2, callback, p3)
		if not fFlagAppChatUniversalFeatureRestriction then
			callback({
				type = constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = constants.TreatmentType.PartyChatTimeoutDialog,
				isShown = true,
				endTime = DateTime.now().UnixTimestamp + p3.timeoutDurationSeconds,
				interventionDetail = p3
			})

			return
		end

		showFeatureRestrictionFromRealtime(AbuseVector.PartyChat, p3, {
			onAppeal = onPartyChatTimeoutUFRAppeal,
			onShown = onPartyChatTimeoutUFRShown,
			onAcknowledgementSuccess = if fFlagAppChatReactiveFeatureRestrictions then onPartyChatTimeoutAcknowledgementSuccess else nil
		})
	end,
	onTriggerBehavioralTreatment = function(p2)
		partyChatTimeoutReceivedSignal:fire(p2.vectorTargetId)
	end,
	onTriggerEventReceived = function(p2)
		interventionAnalytics.sendAnalyticsEvent(interventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = interventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = interventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = interventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p2.decisionEventId,
			duration = p2.timeoutDurationSeconds,
			placement = constants.InterventionPlacementType.InApp
		})
	end
}
