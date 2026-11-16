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

local function onPartyChatTimeoutUFRShown()
	interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatTimeoutDialog)
end
local function onPartyChatTimeoutAcknowledgementSuccess()
	partyChatTimeoutReceivedSignal:fire(nil)
end

local function onPartyChatTimeoutUFRAppeal() end

local PartyChatDialogTimeoutConfig = {}
PartyChatDialogTimeoutConfig.configName = "PartyChatDialogNudge"

function PartyChatDialogTimeoutConfig.shouldTriggerVisualTreatment(p): boolean
	return p.type == Constants.NotificationDialogType.ChatTimeout
		and p.abuseVector == Constants.AbuseVectorType.PartyChat
end

function PartyChatDialogTimeoutConfig.shouldTriggerBehavioralTreatment(p): boolean
	return p.type == Constants.NotificationDialogType.ChatTimeout
		and p.abuseVector == Constants.AbuseVectorType.PartyChat
end

function PartyChatDialogTimeoutConfig.shouldTriggerEventReceived(p): boolean
	return p.type == Constants.NotificationDialogType.ChatTimeout
		and p.abuseVector == Constants.AbuseVectorType.PartyChat
end

function PartyChatDialogTimeoutConfig.onTriggerVisualTreatment(callback, detail)
	if not FFlagAppChatUniversalFeatureRestriction then
		callback({
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
			isShown = true,
			endTime = DateTime.now().UnixTimestamp + detail.timeoutDurationSeconds,
			detail = detail
		})

		return
	end

	local partyChat = AbuseVector.PartyChat
	local v = {
		onAppeal = onPartyChatTimeoutUFRAppeal,
		onShown = onPartyChatTimeoutUFRShown,
		onAcknowledgementSuccess = nil
	}
	local onAcknowledgementSuccess

	if FFlagAppChatReactiveFeatureRestrictions then
		onAcknowledgementSuccess = onPartyChatTimeoutAcknowledgementSuccess
	end

	v.onAcknowledgementSuccess = onAcknowledgementSuccess
	showFeatureRestrictionFromRealtime(partyChat, detail, v)
end
function PartyChatDialogTimeoutConfig.onTriggerBehavioralTreatment(p)
	partyChatTimeoutReceivedSignal:fire(p.vectorTargetId)
end
function PartyChatDialogTimeoutConfig.onTriggerEventReceived(p)
	InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.MessageReceived, {
		eventType = InterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
		counterNamespace = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionType = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
		renderedTimestamp = DateTime.now().UnixTimestampMillis,
		eventId = p.decisionEventId,
		duration = p.timeoutDurationSeconds,
		placement = Constants.InterventionPlacementType.InExperience
	})
end

return PartyChatDialogTimeoutConfig
