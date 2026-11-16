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
local ChatToastNudgeConfig = {}
ChatToastNudgeConfig.configName = "ChatToastNudge"

function ChatToastNudgeConfig.shouldTriggerVisualTreatment(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Toast
		and data.abuseVector == Constants.AbuseVectorType.ExperienceChat
end

function ChatToastNudgeConfig.shouldTriggerBehavioralTreatment(_): boolean
	return false
end

function ChatToastNudgeConfig.shouldTriggerEventReceived(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Toast
		and data.abuseVector == Constants.AbuseVectorType.ExperienceChat
end

function ChatToastNudgeConfig.onTriggerVisualTreatment(callback, detail)
	callback({
		type = Constants.UIStateActions.ToggleNotificationDialog,
		treatmentType = Constants.TreatmentType.ChatNudgeToast,
		isShown = true,
		detail = detail
	})

	if FFlagExpChatDictationStopOnSafetyIntervention then
		experienceChatInterventionShownSignal:fire()
	end
end
function ChatToastNudgeConfig.onTriggerBehavioralTreatment(_) end
function ChatToastNudgeConfig.onTriggerEventReceived(data)
	InExperienceInterventionAnalytics.sendAnalyticsEvent(
		InExperienceInterventionAnalytics.Constants.EventTypes.ToastMessageReceived,
		InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
		DateTime.now().UnixTimestampMillis,
		data.decisionEventId,
		data.evidence,
		data.timeoutDurationSeconds
	)
end

return ChatToastNudgeConfig
