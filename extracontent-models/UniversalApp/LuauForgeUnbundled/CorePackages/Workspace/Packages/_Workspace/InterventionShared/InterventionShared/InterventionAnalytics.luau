local Players = game:GetService("Players")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Cryo")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/LoggingProtocol")
local default = LoggingProtocol.default

local v5 = {
	InterventionTypes = {
		Nudge = "INTERVENTION_CHAT_NUDGE",
		Timeout = "INTERVENTION_CHAT_TIMEOUT",
		PartyChatNudge = "INTERVENTION_PARTY_CHAT_NUDGE",
		PartyChatTimeout = "INTERVENTION_PARTY_CHAT_TIMEOUT",
		UFRNudge = "INTERVENTION_UFR_NUDGE",
		UFRTimeout = "INTERVENTION_UFR_TIMEOUT"
	},
	CounterNamespaceTypes = { PartyChat = "PartyChat" },
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
		DialogInterventionDismissSuccess = "EVENT_DIALOG_INTERVENTION_DISMISS_SUCCESS",
		DialogInterventionDismissFailed = "EVENT_DIALOG_INTERVENTION_DISMISS_FAILED",
		GetModerationDetailFailed = "EVENT_GET_MODERATION_DETAIL_FAILED"
	},
	EventContext = "InExperienceInterventionEvent",
	EventName = "InExperienceInterventionEvent"
}

local v6 = {
	eventName = v5.EventName,
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	formatCustomFields = function(data)
		local eventType = data.eventType
		local interventionType = data.interventionType
		local renderedTimestamp = data.renderedTimestamp
		local eventId = data.eventId
		local evidence = data.evidence
		local duration = data.duration
		local acknowledgeable = data.acknowledgeable
		local userId = Players and Players.LocalPlayer and Players.LocalPlayer.UserId or 0

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local joined = {
			user_id = tostring(userId),
			timestamp_milliseconds = tostring(unixTimestampMillis),
			event_type = eventType,
			intervention_type = interventionType,
			event_id = eventId,
			evidence = evidence,
			timeout_duration_seconds = 0,
			placement = 0
		}

		local v7 = if duration ~= nil then tostring(duration) else nil
		joined.timeout_duration_seconds = v7
		joined.placement = data.placement

		if acknowledgeable ~= nil then
			joined = Cryo.Dictionary.join({
				acknowledgeable = tostring(acknowledgeable)
			}, joined)
		end

		if data.abuseVector ~= nil then
			joined = Cryo.Dictionary.join({ abuse_vector = data.abuseVector }, joined)
		end

		if
			eventType == v5.EventTypes.CtaClicked
			or eventType == v5.EventTypes.AppealClicked
			or eventType == v5.EventTypes.NudgeToastDismissed
			or eventType == v5.EventTypes.ChatAttemptToastDismissed
		then
			joined = Cryo.Dictionary.join({
				time_to_interact_seconds = tostring((unixTimestampMillis - renderedTimestamp) / 1000)
			}, joined)
		end

		if
			eventType == v5.EventTypes.DialogInterventionDismissFailed
			or eventType == v5.EventTypes.GetModerationDetailFailed
		then
			joined = Cryo.Dictionary.join({ error = data.error }, joined)
		end

		return joined
	end
}

local function fn(p2)
	return {
		counterSuffix = p2,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		formatCustomFields = function(data)
			return {
				eventType = data.eventType,
				interventionType = data.interventionType,
				placement = data.placement
			}
		end
	}
end

return {
	sendAnalyticsEvent = function(data, p2)
		local loggingTypes = data.loggingTypes

		if loggingTypes.Event then
			local event = loggingTypes.Event
			local formatCustomFields = event.formatCustomFields(p2)

			default:logRobloxTelemetryEvent({
				eventName = event.eventName,
				backends = event.backends,
				throttlingPercentage = data.throttlingPercentage,
				lastUpdated = data.lastUpdated,
				description = data.description,
				links = data.links
			}, event.standardizedFields or {}, formatCustomFields)
		end

		if loggingTypes.Counter then
			local counter = loggingTypes.Counter
			local formatCustomFields = counter.formatCustomFields(p2)
			local counterNamespace = p2.counterNamespace or "Unknown"

			default:logRobloxTelemetryCounter({
				eventName = `Intervention.{counterNamespace}.{counter.counterSuffix}`,
				backends = counter.backends,
				throttlingPercentage = data.throttlingPercentage,
				lastUpdated = data.lastUpdated,
				description = data.description,
				links = data.links
			}, 1, formatCustomFields)
		end
	end,
	Constants = v5,
	TelemetryConfigs = {
		MessageReceived = {
			loggingTypes = { Event = v6, Counter = fn("Message.Received") },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 3, 25 },
			description = "Intervention RTN message Received"
		},
		DialogRendered = {
			loggingTypes = { Event = v6, Counter = fn("Dialog.Rendered") },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 3, 25 },
			description = "Intervention Dialog Rendered"
		},
		DialogCtaClicked = {
			loggingTypes = { Event = v6, Counter = fn("Dialog.Button.Cta") },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 3, 25 },
			description = "Intervention Dialog CTA Clicked"
		},
		DialogAppealClicked = {
			loggingTypes = { Event = v6, Counter = fn("Dialog.Button.Appeal") },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 3, 25 },
			description = "Intervention Dialog Appeal Clicked"
		},
		DialogInterventionDismissSuccess = {
			loggingTypes = { Event = v6 },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 10, 20 },
			description = "Intervention Dialog Intervention Dismiss Success"
		},
		DialogInterventionDismissFailed = {
			loggingTypes = { Event = v6 },
			throttlingPercentage = 10000,
			lastUpdated = { 2025, 10, 20 },
			description = "Intervention Dialog Intervention Dismiss Failed"
		},
		GetModerationDetailFailed = {
			loggingTypes = { Event = v6 },
			throttlingPercentage = 10000,
			lastUpdated = { 2026, 3, 27 },
			description = "Intervention Get Moderation Detail Failed"
		}
	}
}
