local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local LocalPlayer = game:GetService("Players").LocalPlayer
local InExperienceInterventionParent = InExperienceIntervention.Parent
local EventIngestService = game:GetService("EventIngestService")
local EventIngest = require(InExperienceInterventionParent.Analytics).AnalyticsReporters.EventIngest
local Cryo = require(InExperienceInterventionParent.Cryo)
local v7 = EventIngest.new(EventIngestService)
local t1 = {
	EventContext = "InExperienceInterventionEvent",
	EventName = "InExperienceInterventionEvent",
	InterventionTypes = {
		Nudge = "INTERVENTION_CHAT_NUDGE",
		Timeout = "INTERVENTION_CHAT_TIMEOUT",
		PartyChatNudge = "INTERVENTION_PARTY_CHAT_NUDGE",
		PartyChatTimeout = "INTERVENTION_PARTY_CHAT_TIMEOUT"
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
		GetModerationDetailFailed = "EVENT_GET_MODERATION_DETAIL_FAILED"
	}
}
local n1 = 0

if LocalPlayer then
	n1 = LocalPlayer.UserId
end

local function v10(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 43
	-- upvalues: n1 (ref), t1 (copy), Cryo (copy)
	local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
	local t2 = {
		user_id = n1,
		timestamp_milliseconds = UnixTimestampMillis,
		event_type = p1,
		intervention_type = p2,
		event_id = p4,
		evidence = p5,
		timeout_duration_seconds = p6,
		acknowledgeable = p8
	}

	if p1 == t1.EventTypes.CtaClicked or (p1 == t1.EventTypes.AppealClicked or p1 == t1.EventTypes.NudgeToastDismissed or p1 == t1.EventTypes.ChatAttemptToastDismissed) then
		t2 = Cryo.Dictionary.join({
			time_to_interact_seconds = (UnixTimestampMillis - p3) / 1000
		}, t2)
	end

	if p1 == t1.EventTypes.GetModerationDetailFailed then
		t2 = Cryo.Dictionary.join({
			error = p7
		}, t2)
	end

	return t2
end

return {
	sendAnalyticsEvent = function(p9, p10, p11, p12, p13, p14, p15, p16) -- line: 85
		-- upvalues: v7 (copy), t1 (copy), v10 (copy)
		v7:sendEventDeferred(t1.EventContext, t1.EventName, (v10(p9, p10, p11, p12, p13, p14, p15, p16)))
	end,
	Constants = t1
}
