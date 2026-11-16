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
local ChatDialogNudgeConfig = {}
ChatDialogNudgeConfig.configName = "ChatDialogNudge"

function ChatDialogNudgeConfig.shouldTriggerVisualTreatment(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Dialog
		and data.abuseVector == Constants.AbuseVectorType.ExperienceChat
		and not data.acknowledgeable
end

function ChatDialogNudgeConfig.shouldTriggerBehavioralTreatment(_): boolean
	return false
end

function ChatDialogNudgeConfig.shouldTriggerEventReceived(data): boolean
	return data.type == Constants.NotificationDialogType.ChatNudge
		and data.modalType == Constants.NotificationModalType.Dialog
		and data.abuseVector == Constants.AbuseVectorType.ExperienceChat
end

function ChatDialogNudgeConfig.onTriggerVisualTreatment(callback, detail)
	callback({
		type = Constants.UIStateActions.ToggleNotificationDialog,
		treatmentType = Constants.TreatmentType.ChatNudgeDialog,
		isShown = true,
		detail = detail
	})

	if FFlagExpChatDictationStopOnSafetyIntervention then
		experienceChatInterventionShownSignal:fire()
	end
end
function ChatDialogNudgeConfig.onTriggerBehavioralTreatment(_) end
function ChatDialogNudgeConfig.onTriggerEventReceived(data)
	InExperienceInterventionAnalytics.sendAnalyticsEvent(
		InExperienceInterventionAnalytics.Constants.EventTypes.ModalMessageReceived,
		InExperienceInterventionAnalytics.Constants.InterventionTypes.Nudge,
		DateTime.now().UnixTimestampMillis,
		data.decisionEventId,
		data.evidence,
		data.timeoutDurationSeconds
	)
end

return ChatDialogNudgeConfig
