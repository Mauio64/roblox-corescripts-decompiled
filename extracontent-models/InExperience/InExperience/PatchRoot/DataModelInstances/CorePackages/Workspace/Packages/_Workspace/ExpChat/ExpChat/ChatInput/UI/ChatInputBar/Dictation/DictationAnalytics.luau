local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local TelemetryService = game:GetService("TelemetryService")

local parent = script:FindFirstAncestor("ExpChat").Parent

local ExpChatShared = require(parent.ExpChatShared)

local Analytics = ExpChatShared.Analytics

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local properties = {
	SttMode = "stt_mode",
	SttOutcome = "stt_outcome",
	EntryPoint = "entry_point",
	TriggerType = "trigger_type",
	Status = "status",
	Timestamp = "client_timestamp",
	PlaySessionId = "play_session_id",
	Success = "success",
	ErrorReason = "error_reason",
	LatencyMs = "latency_ms",
	CharCount = "char_count",
	FinalCharCount = "final_char_count",
	DurationSeconds = "duration_seconds",
	EditType = "edit_type",
	WasEdited = "was_edited",
	EditDistance = "edit_distance",
	TextStt = "text_stt",
	TextSent = "text_sent",
	TextSttTruncated = "text_stt_truncated",
	TextSentTruncated = "text_sent_truncated",
	DismissReason = "dismiss_reason",
	CanDeepLink = "can_deep_link"
}

local function getPlaySessionId() -- 1 equivalent call inferred from this helper
	if engineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return ""
end

local counters = {
	Started = {
		eventName = "ExpChatDictationStarted",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 9 },
		description = "A user initiated a dictation session from the chat input mic. customFields: mode (standard/continuous), entry_point (tap/long_press).",
		links = ""
	},
	Ended = {
		eventName = "ExpChatDictationEnded",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 11, 2 },
		description = "A dictation recording session ended. Session-level only; continuous auto-chunk stops are excluded. customFields: mode, reason (user_manual/time_up/auto_pause/safety_intervention/rate_limited).",
		links = ""
	},
	VadStop = {
		eventName = "ExpChatDictationVadStop",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 10 },
		description = "A standard-mode dictation recording ended early because the engine VAD finalized the utterance (end-of-speech detected) rather than the user tapping stop or the timer running out. customFields: mode.",
		links = ""
	},
	Permission = {
		eventName = "ExpChatDictationPermission",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 9 },
		description = "Microphone permission resolved for a dictation attempt. customFields: mode, result (granted/denied/already_allowed).",
		links = ""
	},
	Transcription = {
		eventName = "ExpChatDictationTranscription",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 9 },
		description = "A speech-to-text transcription completed for a dictation utterance. customFields: mode, result (success/failure).",
		links = ""
	},
	SafetyReminder = {
		eventName = "ExpChatDictationSafetyReminder",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 30 },
		description = "A continuous-dictation message came back fully text-filtered and the once-per-session \"use kind words\" reminder was requested.",
		links = ""
	},
	MessageSent = {
		eventName = "ExpChatDictationMessageSent",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 9, 9 },
		description = "A chat message produced via dictation was sent. customFields: mode.",
		links = ""
	}
}

local v = TelemetryService

local function logDictationCounter(p, customFields) -- 7 equivalent calls inferred from this helper
	if v then
		v:LogCounter(p, { customFields = customFields }, 1)
	end
end

local DictationAnalytics = {}
DictationAnalytics.Events = {
	MicClick = "dictation_mic_click",
	PermissionPrompt = "dictation_permission_prompt",
	RecordingStart = "dictation_recording_start",
	RecordingStop = "dictation_recording_stop",
	VadStop = "dictation_vad_stop",
	TranscriptionDone = "transcription_done",
	TextEdit = "text_edit",
	MessageSent = "dictation_message_sent",
	FtuxShown = "dictation_ftux_shown",
	FtuxDismiss = "dictation_ftux_dismiss",
	MicToastShown = "dictation_mic_toast_shown",
	MicToastActivated = "dictation_mic_toast_activated",
	MicToastDismiss = "dictation_mic_toast_dismiss",
	SafetyReminderTriggered = "dictation_safety_reminder_triggered"
}
DictationAnalytics.Properties = properties
DictationAnalytics.Modes = { Standard = "standard", Continuous = "continuous" }

DictationAnalytics.EntryPoints = { Tap = "tap", LongPress = "long_press" }

DictationAnalytics.TriggerTypes = {
	UserManual = "user_manual",
	TimeUp = "time_up",
	AutoPause = "auto_pause",
	AutoChunk = "auto_chunk",
	SafetyIntervention = "safety_intervention",
	RateLimited = "rate_limited"
}

DictationAnalytics.PermissionStatuses = {
	Granted = "granted",
	Denied = "denied",
	AlreadyAllowed = "already_allowed"
}

DictationAnalytics.EditTypes = {
	Addition = "addition",
	Deletion = "deletion",
	FullClear = "full_clear",
	Mixed = "mixed"
}

DictationAnalytics.Outcomes = { Full = "stt_full", Partial = "stt_partial" }

DictationAnalytics.DismissReasons = {
	Visibility = "visibility",
	UserInteraction = "user_interaction"
}
DictationAnalytics.Counters = counters

function DictationAnalytics.fire(p, p2)
	local v2 = not p2 and {} or table.clone(p2)
	v2[properties.PlaySessionId] = getPlaySessionId() -- inferred equivalent call

	if v2[properties.Timestamp] == nil then
		v2[properties.Timestamp] = os.clock()
	end

	Analytics.FireClientAnalyticsWithEventName(p, v2)
end

function DictationAnalytics.withTelemetryService(p)
	v = p or TelemetryService
end

function DictationAnalytics.reportStartedCounter(mode, entry_point)
	logDictationCounter(counters.Started, { mode = mode, entry_point = entry_point }) -- inferred equivalent call
end

function DictationAnalytics.reportEndedCounter(mode, reason)
	logDictationCounter(counters.Ended, { mode = mode, reason = reason }) -- inferred equivalent call
end

function DictationAnalytics.reportVadStopCounter(mode)
	logDictationCounter(counters.VadStop, { mode = mode }) -- inferred equivalent call
end

function DictationAnalytics.reportPermissionCounter(mode, p)
	logDictationCounter(counters.Permission, { mode = mode, result = p }) -- inferred equivalent call
end

function DictationAnalytics.reportTranscriptionCounter(value, flag: boolean)
	logDictationCounter(counters.Transcription, { -- inferred equivalent call
		mode = value or "unknown",
		result = flag and "success" or "failure"
	})
end

function DictationAnalytics.reportMessageSentCounter(mode)
	logDictationCounter(counters.MessageSent, { mode = mode }) -- inferred equivalent call
end

function DictationAnalytics.reportSafetyReminderCounter()
	logDictationCounter(counters.SafetyReminder, {}) -- inferred equivalent call
end

return DictationAnalytics
