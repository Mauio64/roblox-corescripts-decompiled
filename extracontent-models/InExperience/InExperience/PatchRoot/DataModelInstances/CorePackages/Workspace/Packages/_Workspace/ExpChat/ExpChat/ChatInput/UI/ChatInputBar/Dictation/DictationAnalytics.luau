local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local Analytics = require(Parent.ExpChatShared).Analytics
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local t1 = {
	MicClick = "dictation_mic_click",
	PermissionPrompt = "dictation_permission_prompt",
	RecordingStart = "dictation_recording_start",
	RecordingStop = "dictation_recording_stop",
	TranscriptionDone = "transcription_done",
	TextEdit = "text_edit",
	MessageSent = "dictation_message_sent",
	FtuxShown = "dictation_ftux_shown",
	FtuxDismiss = "dictation_ftux_dismiss"
}
local t2 = {
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
	DismissReason = "dismiss_reason"
}
local t3 = {
	Standard = "standard",
	Continuous = "continuous"
}
local t4 = {
	Tap = "tap",
	LongPress = "long_press"
}
local t5 = {
	UserManual = "user_manual",
	TimeUp = "time_up",
	AutoPause = "auto_pause",
	AutoChunk = "auto_chunk"
}
local t6 = {
	Granted = "granted",
	Denied = "denied",
	AlreadyAllowed = "already_allowed"
}
local t7 = {
	Addition = "addition",
	Deletion = "deletion",
	FullClear = "full_clear",
	Mixed = "mixed"
}
local t8 = {
	Full = "stt_full",
	Partial = "stt_partial"
}
local t9 = {
	Visibility = "visibility",
	UserInteraction = "user_interaction"
}

local function getPlaySessionId() -- line: 125
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	if EngineFeature then
		return RbxAnalyticsService:GetPlaySessionId()
	end

	return ""
end

return {
	Events = t1,
	Properties = t2,
	Modes = t3,
	EntryPoints = t4,
	TriggerTypes = t5,
	PermissionStatuses = t6,
	EditTypes = t7,
	Outcomes = t8,
	DismissReasons = t9,
	fire = function(p1, t10: {[any]: any}?) -- line: 132
		-- upvalues: t2 (copy), EngineFeature (copy), RbxAnalyticsService (copy), Analytics (copy)
		local v17 = if not t10 then {} else table.clone(t10)

		v17[t2.PlaySessionId] = not EngineFeature and "" or RbxAnalyticsService:GetPlaySessionId()

		if v17[t2.Timestamp] == nil then
			v17[t2.Timestamp] = os.clock()
		end

		Analytics.FireClientAnalyticsWithEventName(p1, v17)
	end
}
