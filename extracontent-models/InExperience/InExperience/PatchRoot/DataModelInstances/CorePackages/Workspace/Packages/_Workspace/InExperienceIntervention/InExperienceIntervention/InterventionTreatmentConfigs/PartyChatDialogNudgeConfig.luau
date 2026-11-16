local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local InterventionShared2 = require(parent.InterventionShared)
local InterventionAnalytics = InterventionShared2.InterventionAnalytics
local InterventionShared3 = require(parent.InterventionShared)
local interventionTreatmentShownSignal = InterventionShared3.Signals.interventionTreatmentShownSignal
local InterventionShared4 = require(parent.InterventionShared)
local partyChatTimeoutReceivedSignal = InterventionShared4.Signals.partyChatTimeoutReceivedSignal

local showFeatureRestrictionFromRealtime = require(parent.UniversalFeatureRestrictions.showFeatureRestrictionFromRealtime)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatUniversalFeatureRestriction = SharedFlags2.FFlagAppChatUniversalFeatureRestriction

require(InExperienceIntervention.Utils.Types)

local function onPartyChatNudgeUFRAppeal() end
local function onPartyChatNudgeUFRShown()
	interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatNudgeDialog)
end
local function onPartyChatNudgeAcknowledgementSuccess()
	partyChatTimeoutReceivedSignal:fire(nil)
end

local PartyChatDialogNudgeConfig = {}
PartyChatDialogNudgeConfig.configName = "PartyChatDialogNudge"

function PartyChatDialogNudgeConfig.shouldTriggerVisualTreatment(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Dialog
		and data.abuseVector == Constants.AbuseVectorType.PartyChat
end

function PartyChatDialogNudgeConfig.shouldTriggerBehavioralTreatment(data)
	local fFlagAppChatReactiveFeatureRestrictions = FFlagAppChatReactiveFeatureRestrictions

	if fFlagAppChatReactiveFeatureRestrictions then
		if
			data.type == Constants.NotificationDialogType.ChatNudge
			and data.modalType == Constants.NotificationModalType.Dialog
			and data.abuseVector == Constants.AbuseVectorType.PartyChat
		then
			return data.acknowledgeable == true
		end

		return false
	end

	return fFlagAppChatReactiveFeatureRestrictions
end

function PartyChatDialogNudgeConfig.shouldTriggerEventReceived(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Dialog
		and data.abuseVector == Constants.AbuseVectorType.PartyChat
end

function PartyChatDialogNudgeConfig.onTriggerVisualTreatment(callback, detail)
	if not FFlagAppChatUniversalFeatureRestriction then
		callback({
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatNudgeDialog,
			isShown = true,
			detail = detail
		})

		return
	end

	local partyChat = AbuseVector.PartyChat
	local v = {
		onAppeal = onPartyChatNudgeUFRAppeal,
		onShown = onPartyChatNudgeUFRShown,
		onAcknowledgementSuccess = nil
	}
	local onAcknowledgementSuccess

	if FFlagAppChatReactiveFeatureRestrictions then
		onAcknowledgementSuccess = onPartyChatNudgeAcknowledgementSuccess
	end

	v.onAcknowledgementSuccess = onAcknowledgementSuccess
	showFeatureRestrictionFromRealtime(partyChat, detail, v)
end
function PartyChatDialogNudgeConfig.onTriggerBehavioralTreatment(_)
	partyChatTimeoutReceivedSignal:fire(nil)
end
function PartyChatDialogNudgeConfig.onTriggerEventReceived(p)
	InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
		eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
		counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge,
		renderedTimestamp = DateTime.now().UnixTimestampMillis,
		eventId = p.decisionEventId,
		duration = p.timeoutDurationSeconds,
		placement = Constants.InterventionPlacementType.InExperience
	})
end

return PartyChatDialogNudgeConfig
