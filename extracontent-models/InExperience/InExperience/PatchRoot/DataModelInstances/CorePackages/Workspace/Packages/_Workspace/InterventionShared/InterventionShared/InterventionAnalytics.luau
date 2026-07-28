local InterventionShared = script:FindFirstAncestor("InterventionShared")
local Players = game:GetService("Players")
local InterventionSharedParent = InterventionShared.Parent
local Cryo = require(InterventionSharedParent.Cryo)
local LoggingProtocol = require(InterventionSharedParent.LoggingProtocol)
local default = LoggingProtocol.default
local FFlagUniversalFeatureRestrictionReceivers = require(InterventionSharedParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local t1 = {
	EventContext = "InExperienceInterventionEvent",
	EventName = "InExperienceInterventionEvent",
	InterventionTypes = {
		Nudge = "INTERVENTION_CHAT_NUDGE",
		Timeout = "INTERVENTION_CHAT_TIMEOUT",
		PartyChatNudge = "INTERVENTION_PARTY_CHAT_NUDGE",
		PartyChatTimeout = "INTERVENTION_PARTY_CHAT_TIMEOUT",
		UFRNudge = "INTERVENTION_UFR_NUDGE",
		UFRTimeout = "INTERVENTION_UFR_TIMEOUT"
	},
	CounterNamespaceTypes = {
		PartyChat = "PartyChat"
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
		DialogInterventionDismissSuccess = "EVENT_DIALOG_INTERVENTION_DISMISS_SUCCESS",
		DialogInterventionDismissFailed = "EVENT_DIALOG_INTERVENTION_DISMISS_FAILED",
		GetModerationDetailFailed = "EVENT_GET_MODERATION_DETAIL_FAILED"
	}
}
local t4 = {
	eventName = t1.EventName,
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	formatCustomFields = function(t2: {[any]: any}) -- line: 77
		-- upvalues: Players (copy), Cryo (copy), FFlagUniversalFeatureRestrictionReceivers (copy), t1 (copy)
		local eventType = t2.eventType
		local interventionType = t2.interventionType
		local renderedTimestamp = t2.renderedTimestamp
		local eventId = t2.eventId
		local evidence = t2.evidence
		local duration = t2.duration
		local acknowledgeable = t2.acknowledgeable
		local v20 = Players and (not not Players.LocalPlayer and Players.LocalPlayer.UserId) or 0
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local t3 = {
			user_id = tostring(v20),
			timestamp_milliseconds = tostring(UnixTimestampMillis),
			event_type = eventType,
			intervention_type = interventionType,
			event_id = eventId,
			evidence = evidence,
			timeout_duration_seconds = if duration == nil then nil else tostring(duration),
			placement = t2.placement
		}

		if acknowledgeable ~= nil then
			t3 = Cryo.Dictionary.join({
				acknowledgeable = tostring(acknowledgeable)
			}, t3)
		end

		if FFlagUniversalFeatureRestrictionReceivers and t2.abuseVector ~= nil then
			t3 = Cryo.Dictionary.join({
				abuse_vector = t2.abuseVector
			}, t3)
		end

		if eventType == t1.EventTypes.CtaClicked or eventType == t1.EventTypes.AppealClicked or eventType == t1.EventTypes.NudgeToastDismissed or eventType == t1.EventTypes.ChatAttemptToastDismissed then
			t3 = Cryo.Dictionary.join({
				time_to_interact_seconds = tostring((UnixTimestampMillis - renderedTimestamp) / 1000)
			}, t3)
		end

		if eventType == t1.EventTypes.DialogInterventionDismissFailed or eventType == t1.EventTypes.GetModerationDetailFailed then
			t3 = Cryo.Dictionary.join({
				error = t2.error
			}, t3)
		end

		return t3
	end
}

local function v10(s1: string) -- line: 140
	-- upvalues: LoggingProtocol (copy)
	return {
		counterSuffix = s1,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		formatCustomFields = function(t5: {[any]: any}) -- line: 144
			return {
				eventType = t5.eventType,
				interventionType = t5.interventionType,
				placement = t5.placement
			}
		end
	}
end

local t6 = {
	MessageReceived = {
		throttlingPercentage = 10000,
		description = "Intervention RTN message Received",
		loggingTypes = {
			Event = t4,
			Counter = v10("Message.Received")
		},
		lastUpdated = {
			2025,
			3,
			25
		}
	},
	DialogRendered = {
		throttlingPercentage = 10000,
		description = "Intervention Dialog Rendered",
		loggingTypes = {
			Event = t4,
			Counter = v10("Dialog.Rendered")
		},
		lastUpdated = {
			2025,
			3,
			25
		}
	},
	DialogCtaClicked = {
		throttlingPercentage = 10000,
		description = "Intervention Dialog CTA Clicked",
		loggingTypes = {
			Event = t4,
			Counter = v10("Dialog.Button.Cta")
		},
		lastUpdated = {
			2025,
			3,
			25
		}
	},
	DialogAppealClicked = {
		throttlingPercentage = 10000,
		description = "Intervention Dialog Appeal Clicked",
		loggingTypes = {
			Event = t4,
			Counter = v10("Dialog.Button.Appeal")
		},
		lastUpdated = {
			2025,
			3,
			25
		}
	},
	DialogInterventionDismissSuccess = {
		throttlingPercentage = 10000,
		description = "Intervention Dialog Intervention Dismiss Success",
		loggingTypes = {
			Event = t4
		},
		lastUpdated = {
			2025,
			10,
			20
		}
	},
	DialogInterventionDismissFailed = {
		throttlingPercentage = 10000,
		description = "Intervention Dialog Intervention Dismiss Failed",
		loggingTypes = {
			Event = t4
		},
		lastUpdated = {
			2025,
			10,
			20
		}
	},
	GetModerationDetailFailed = {
		throttlingPercentage = 10000,
		description = "Intervention Get Moderation Detail Failed",
		loggingTypes = {
			Event = t4
		},
		lastUpdated = {
			2026,
			3,
			27
		}
	}
}

return {
	sendAnalyticsEvent = function(t7: {[any]: any}, t8: {[any]: any}) -- line: 217
		-- upvalues: default (copy)
		local loggingTypes = t7.loggingTypes

		if loggingTypes.Event then
			local Event = loggingTypes.Event
			local v28 = Event.formatCustomFields(t8)

			default:logRobloxTelemetryEvent({
				eventName = Event.eventName,
				backends = Event.backends,
				throttlingPercentage = t7.throttlingPercentage,
				lastUpdated = t7.lastUpdated,
				description = t7.description,
				links = t7.links
			}, Event.standardizedFields or {}, v28)
		end

		if loggingTypes.Counter then
			local Counter = loggingTypes.Counter
			local v30 = Counter.formatCustomFields(t8)
			local v31 = t8.counterNamespace or "Unknown"

			default:logRobloxTelemetryCounter({
				eventName = `Intervention.{ v31 }.{ Counter.counterSuffix }`,
				backends = Counter.backends,
				throttlingPercentage = t7.throttlingPercentage,
				lastUpdated = t7.lastUpdated,
				description = t7.description,
				links = t7.links
			}, 1, v30)
		end
	end,
	Constants = t1,
	TelemetryConfigs = t6
}
