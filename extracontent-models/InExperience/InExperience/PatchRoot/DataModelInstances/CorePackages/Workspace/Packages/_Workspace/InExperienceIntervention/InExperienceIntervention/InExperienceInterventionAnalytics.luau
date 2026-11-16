local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local parent = InExperienceIntervention.Parent
local EventIngestService = game:GetService("EventIngestService")
local Analytics = require(parent.Analytics)
local EventIngest = Analytics.AnalyticsReporters.EventIngest
local Cryo = require(parent.Cryo)

local v = EventIngest.new(EventIngestService)

local constants = {
	InterventionTypes = {
		Nudge = "INTERVENTION_CHAT_NUDGE",
		Timeout = "INTERVENTION_CHAT_TIMEOUT",
		PartyChatNudge = "INTERVENTION_PARTY_CHAT_NUDGE",
		PartyChatTimeout = "INTERVENTION_PARTY_CHAT_TIMEOUT",
		DictationSafetyReminder = "INTERVENTION_DICTATION_SAFETY_REMINDER"
	},
	EventTypes = {
		AppealClicked = "EVENT_APPEAL_CLICKED",
		CtaClicked = "EVENT_CTA_CLICKED",
		ModalAppeared = "EVENT_MODAL_APPEARED",
		ModalMessageReceived = "EVENT_MODAL_MESSAGE_RECEIVED",
		ToastMessageReceived = "EVENT_TOAST_MESSAGE_RECEIVED",
		NudgeToastAppeared = "EVENT_NUDGE_TOAST_APPEARED",
		NudgeToastDismissed = "EVENT_NUDGE_TOAST_DISMISSED",
		ChatAttemptToastAppeared = "EVENT_CHAT_ATTEMPT_TOAST_APPEARED",
		ChatAttemptToastDismissed = "EVENT_CHAT_ATTEMPT_TOAST_DISMISSED",
		DictationSafetyReminderToastAppeared = "EVENT_DICTATION_SAFETY_REMINDER_TOAST_APPEARED",
		DictationSafetyReminderToastDismissed = "EVENT_DICTATION_SAFETY_REMINDER_TOAST_DISMISSED",
		GetModerationDetailFailed = "EVENT_GET_MODERATION_DETAIL_FAILED"
	},
	EventContext = "InExperienceInterventionEvent",
	EventName = "InExperienceInterventionEvent"
}

local user_id = not LocalPlayer and 0 or LocalPlayer.UserId

local function fn(event_type, intervention_type, p, event_id, evidence, timeout_duration_seconds, err, acknowledgeable)
	local unixTimestampMillis = DateTime.now().UnixTimestampMillis
	local joined = {
		user_id = user_id,
		timestamp_milliseconds = unixTimestampMillis,
		event_type = event_type,
		intervention_type = intervention_type,
		event_id = event_id,
		evidence = evidence,
		timeout_duration_seconds = timeout_duration_seconds,
		acknowledgeable = acknowledgeable
	}

	if
		event_type == constants.EventTypes.CtaClicked
		or event_type == constants.EventTypes.AppealClicked
		or event_type == constants.EventTypes.NudgeToastDismissed
		or event_type == constants.EventTypes.ChatAttemptToastDismissed
		or event_type == constants.EventTypes.DictationSafetyReminderToastDismissed
	then
		joined = Cryo.Dictionary.join({
			time_to_interact_seconds = (unixTimestampMillis - p) / 1000
		}, joined)
	end

	if event_type == constants.EventTypes.GetModerationDetailFailed then
		joined = Cryo.Dictionary.join({ error = err }, joined)
	end

	return joined
end

return {
	sendAnalyticsEvent = function(event_type, intervention_type, p, event_id, evidence, timeout_duration_seconds, err, acknowledgeable)
		v:sendEventDeferred(
			constants.EventContext,
			constants.EventName,
			fn(event_type, intervention_type, p, event_id, evidence, timeout_duration_seconds, err, acknowledgeable)
		)
	end,
	Constants = constants
}
