local v = game:GetService("TelemetryService")

local standardizedFields = { "addPlaceId", "addUniverseId", "addSessionInfo", "addPlaySessionId" }
local v2 = {
	eventName = "PlayerSupportPromptAction",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("PlayerSupportPromptTelemetryThrottleHundredthsPercent", 10000),
	lastUpdated = { 2026, 9, 23 },
	description = "Funnel events for the player support ticket prompt."
}

local action = {
	Opened = "opened",
	Submitted = "submitted",
	Dismissed = "dismissed",
	ReportAbuseClicked = "report_abuse_clicked",
	EligibilityBlocked = "eligibility_blocked",
	ErrorShown = "error_shown",
	RejectionRetry = "rejection_retry",
	TicketResult = "ticket_result"
}

local ticketResult = { Submitted = "submitted", Failed = "failed", Rejected = "rejected" }

local v3 = {
	TICKET_CREATION_SUBMITTED = ticketResult.Submitted,
	TICKET_CREATION_FAILED = ticketResult.Failed,
	TICKET_CREATION_TEXT_FILTER_ERROR = ticketResult.Rejected,
	TICKET_CREATION_GIBBERISH_ERROR = ticketResult.Rejected
}

local function fieldString(p) -- 3 equivalent calls inferred from this helper
	if p == nil then
		return ""
	end

	return (tostring(p))
end

local PlayerSupportPromptTelemetry = {
	Action = action,
	DismissMethod = { Escape = "escape", DialogClose = "dialog_close" },
	TicketResult = ticketResult
}

function PlayerSupportPromptTelemetry.log(data)
	pcall(function()
		v:LogEvent(v2, {
			eventContext = "PlayerSupportPrompt",
			standardizedFields = standardizedFields,
			customFields = {
				action = data.action,
				category = data.category or "",
				share_user_id = fieldString(data.shareUserId), -- inferred equivalent call
				share_user_id_required = fieldString(data.shareUserIdRequired), -- inferred equivalent call
				description_length = fieldString(data.descriptionLength), -- inferred equivalent call
				dismiss_method = data.dismissMethod or "",
				reason = data.reason or "",
				result = data.result or ""
			}
		})
	end)
end

function PlayerSupportPromptTelemetry.logTicketResult(reason: string, options)
	local v4 = v3[reason]

	if not v4 then
		return
	end

	local v5 = options or {}
	PlayerSupportPromptTelemetry.log({
		action = action.TicketResult,
		result = v4,
		reason = reason,
		category = v5.category,
		shareUserId = v5.shareUserId,
		descriptionLength = v5.descriptionLength
	})
end

function PlayerSupportPromptTelemetry.logUnavailableShown(reason: string)
	if v3[reason] then
		return
	end

	local action2

	if string.sub(reason, 1, 43) == "TICKET_CREATION_ELIGIBILITY_FAILURE_REASON_" then
		action2 = action.EligibilityBlocked
	else
		action2 = action.ErrorShown
	end

	PlayerSupportPromptTelemetry.log({ action = action2, reason = reason })
end

function PlayerSupportPromptTelemetry._setServicesForTesting(p)
	v = p
end

return PlayerSupportPromptTelemetry
