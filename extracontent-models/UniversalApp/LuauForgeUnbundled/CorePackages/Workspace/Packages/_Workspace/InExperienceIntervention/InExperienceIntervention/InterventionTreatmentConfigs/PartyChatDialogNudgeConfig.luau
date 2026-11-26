local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/AbuseVector")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Utils.Constants
local interventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").InterventionAnalytics
local interventionTreatmentShownSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Signals.interventionTreatmentShownSignal
local partyChatTimeoutReceivedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Signals.partyChatTimeoutReceivedSignal

local showFeatureRestrictionFromRealtime = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/showFeatureRestrictionFromRealtime")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local fFlagAppChatUniversalFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/SharedFlags").FFlagAppChatUniversalFeatureRestriction

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/Utils/Types")

local function onPartyChatNudgeUFRAppeal() end
local function onPartyChatNudgeUFRShown()
	interventionTreatmentShownSignal:fire(constants.TreatmentType.PartyChatNudgeDialog)
end
local function onPartyChatNudgeAcknowledgementSuccess()
	partyChatTimeoutReceivedSignal:fire(nil)
end

return {
	configName = "PartyChatDialogNudge",
	shouldTriggerVisualTreatment = function(data, p2): boolean
		return data.type == constants.NotificationDialogType.ChatNudge
			and data.modalType == constants.NotificationModalType.Dialog
			and data.abuseVector == constants.AbuseVectorType.PartyChat
			and not p2.isUserInExperience
	end,
	shouldTriggerBehavioralTreatment = function(data, p2)
		local v5 = fFlagAppChatReactiveFeatureRestrictions

		if v5 then
			if
				data.type == constants.NotificationDialogType.ChatNudge
				and data.modalType == constants.NotificationModalType.Dialog
				and data.abuseVector == constants.AbuseVectorType.PartyChat
			then
				v5 = not p2.isUserInExperience and data.acknowledgeable == true
			else
				v5 = false
			end
		end

		return v5
	end,
	shouldTriggerEventReceived = function(data, p2): boolean
		return data.type == constants.NotificationDialogType.ChatNudge
			and data.modalType == constants.NotificationModalType.Dialog
			and data.abuseVector == constants.AbuseVectorType.PartyChat
			and not p2.isUserInExperience
	end,
	onTriggerVisualTreatment = function(p2, callback, p3)
		if not fFlagAppChatUniversalFeatureRestriction then
			callback({
				type = constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = constants.TreatmentType.PartyChatNudgeDialog,
				isShown = true,
				interventionDetail = p3
			})

			return
		end

		showFeatureRestrictionFromRealtime(AbuseVector.PartyChat, p3, {
			onAppeal = onPartyChatNudgeUFRAppeal,
			onShown = onPartyChatNudgeUFRShown,
			onAcknowledgementSuccess = if fFlagAppChatReactiveFeatureRestrictions then onPartyChatNudgeAcknowledgementSuccess else nil
		})
	end,
	onTriggerBehavioralTreatment = function(p2)
		partyChatTimeoutReceivedSignal:fire(nil)
	end,
	onTriggerEventReceived = function(p2)
		interventionAnalytics.sendAnalyticsEvent(interventionAnalytics.TelemetryConfigs.MessageReceived, {
			eventType = interventionAnalytics.Constants.EventTypes.ModalMessageReceived,
			counterNamespace = interventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
			interventionType = interventionAnalytics.Constants.InterventionTypes.PartyChatNudge,
			renderedTimestamp = DateTime.now().UnixTimestampMillis,
			eventId = p2.decisionEventId,
			duration = p2.timeoutDurationSeconds,
			placement = constants.InterventionPlacementType.InApp
		})
	end
}
