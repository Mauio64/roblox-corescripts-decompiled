local TelemetryService = game:GetService("TelemetryService")

local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

require(parent.AppChat.GetExternalChatMessageSenderStore)
local LoggingProtocol = require(parent.LoggingProtocol)
require(ShareSheet.Recipients.RecipientSource)
local getElapsedTimeMs = require(ShareSheet.getElapsedTimeMs)

local EventIngest = LoggingProtocol.TelemetryBackends.EventIngest

local defineFastInt = game:DefineFastInt("ShareSheetTelemetryThrottleHundredthsPercent", 10000)

local v = {
	shareSheetOpened = {
		eventName = "shareSheetOpened",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Share sheet was opened"
	},
	shareSheetLinkCopied = {
		eventName = "shareSheetLinkCopied",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Link was copied from share sheet"
	},
	shareSheetMessageSent = {
		eventName = "shareSheetMessageSent",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Message was sent from share sheet"
	},
	Lifecycle = {
		eventName = "shareSheetLifecycle",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 3 },
		description = "Share sheet request lifecycle transitions"
	},
	Interaction = {
		eventName = "shareSheetInteraction",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 3 },
		description = "User interactions within the share sheet"
	},
	MessageSendResult = {
		eventName = "shareSheetMessageSendResult",
		backends = { EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 9, 8 },
		description = "Per-recipient share sheet message send results"
	}
}

local standardizedFields = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" }

local ShareSheetTelemetry = {}

ShareSheetTelemetry.LifecycleType = { Open = "open", Close = "close" }

ShareSheetTelemetry.CloseReason = {
	UserDismissed = "userDismissed",
	SendSuccess = "sendSuccess",
	Programmatic = "programmatic",
	Replaced = "replaced"
}

ShareSheetTelemetry.InteractionType = {
	CopyLink = "copyLink",
	NativeShare = "nativeShare",
	ConversationSelected = "conversationSelected",
	ConversationDeselected = "conversationDeselected",
	CustomMessageComposerFocused = "customMessageComposerFocused",
	CustomMessageSubmitted = "customMessageSubmitted",
	ViewMessage = "viewMessage"
}

ShareSheetTelemetry.ViewDestination = { Conversation = "conversation", ChatLanding = "chatLanding" }

local v2 = {
	eventName = "shareSheetOpened",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet requests opened"
}

local v3 = {
	eventName = "shareSheetClosed",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet requests closed"
}

local v4 = {
	eventName = "shareSheetInteraction",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet interactions"
}

local v5 = {
	eventName = "shareSheetMessageSendResult",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 8 },
	description = "Count of per-recipient share sheet message send results"
}

local v6 = {
	eventName = "shareSheetMessageSendResultDurationMs",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 8 },
	description = "Duration in milliseconds from recipient send invocation to result"
}

function ShareSheetTelemetry.logShareSheetOpened(customFields)
	TelemetryService:LogEvent(v.shareSheetOpened, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function ShareSheetTelemetry.logShareSheetLinkCopied(customFields)
	TelemetryService:LogEvent(v.shareSheetLinkCopied, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function ShareSheetTelemetry.logShareSheetMessageSent(customFields)
	TelemetryService:LogEvent(v.shareSheetMessageSent, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function ShareSheetTelemetry.logLifecycle(customFields)
	TelemetryService:LogEvent(v.Lifecycle, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
	local v7

	if customFields.lifecycleType == ShareSheetTelemetry.LifecycleType.Open then
		v7 = v2
	else
		v7 = v3
	end

	TelemetryService:LogCounter(v7, {
		customFields = { context = customFields.context, closeReason = customFields.closeReason }
	}, 1)
end

function ShareSheetTelemetry.logInteraction(customFields)
	TelemetryService:LogEvent(v.Interaction, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})

	TelemetryService:LogCounter(v4, {
		customFields = {
			context = customFields.context,
			interactionType = customFields.interactionType
		}
	}, 1)
end

function ShareSheetTelemetry.logMessageSendResult(customFields)
	TelemetryService:LogEvent(v.MessageSendResult, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})

	TelemetryService:LogStat(v6, {
		customFields = {
			context = customFields.context,
			sendStatus = customFields.sendStatus,
			hasCustomMessage = customFields.hasCustomMessage
		}
	}, customFields.durationMs)
	TelemetryService:LogCounter(v5, {
		customFields = {
			context = customFields.context,
			sendStatus = customFields.sendStatus,
			hasCustomMessage = customFields.hasCustomMessage
		}
	}, 1)
end

function ShareSheetTelemetry.startMessageSendResult(data)
	local now = os.clock()
	return function(p)
		ShareSheetTelemetry.logMessageSendResult({
			context = data.context,
			recipientSource = data.recipientSource,
			telemetryId = data.telemetryId,
			requestedConversationId = data.requestedConversationId,
			resolvedConversationId = p.conversationId,
			sendStatus = p.status,
			hasCustomMessage = data.hasCustomMessage,
			durationMs = getElapsedTimeMs(now)
		})
	end
end

return ShareSheetTelemetry
