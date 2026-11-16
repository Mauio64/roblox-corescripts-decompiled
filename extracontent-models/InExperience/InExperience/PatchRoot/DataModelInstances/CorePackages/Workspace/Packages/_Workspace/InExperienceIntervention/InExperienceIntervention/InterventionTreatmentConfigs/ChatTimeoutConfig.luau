local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants

local InterventionShared2 = require(parent.InterventionShared)
local experienceChatInterventionShownSignal = InterventionShared2.Signals.experienceChatInterventionShownSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatDictationStopOnSafetyIntervention = SharedFlags.FFlagExpChatDictationStopOnSafetyIntervention
require(InExperienceIntervention.Utils.Types)
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatTimeoutConfig = {}
ChatTimeoutConfig.configName = "ChatTimeout"

function ChatTimeoutConfig.shouldTriggerVisualTreatment(data): boolean
	return data.type == Constants.NotificationDialogType.ChatTimeout
		and data.abuseVector == Constants.AbuseVectorType.ExperienceChat
		and not data.acknowledgeable
end

function ChatTimeoutConfig.shouldTriggerBehavioralTreatment(p): boolean
	return p.type == Constants.NotificationDialogType.ChatTimeout
		and p.abuseVector == Constants.AbuseVectorType.ExperienceChat
end

function ChatTimeoutConfig.shouldTriggerEventReceived(p): boolean
	return p.type == Constants.NotificationDialogType.ChatTimeout
		and p.abuseVector == Constants.AbuseVectorType.ExperienceChat
end

function ChatTimeoutConfig.onTriggerVisualTreatment(callback, detail)
	callback({
		type = Constants.UIStateActions.ToggleNotificationDialog,
		treatmentType = Constants.TreatmentType.ChatTimeoutDialog,
		isShown = true,
		detail = detail
	})

	if FFlagExpChatDictationStopOnSafetyIntervention then
		experienceChatInterventionShownSignal:fire()
	end
end
function ChatTimeoutConfig.onTriggerBehavioralTreatment(_) end
function ChatTimeoutConfig.onTriggerEventReceived(data)
	InExperienceInterventionAnalytics.sendAnalyticsEvent(
		InExperienceInterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
		InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
		DateTime.now().UnixTimestampMillis,
		data.decisionEventId,
		data.evidence,
		data.timeoutDurationSeconds
	)
end

return ChatTimeoutConfig
