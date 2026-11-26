local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local getElapsedTimeMs = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/getElapsedTimeMs")

local eventIngest = LoggingProtocol.TelemetryBackends.EventIngest

local defineFastInt = game:DefineFastInt("ShareSheetTelemetryThrottleHundredthsPercent", 10000)

local v5 = {
	shareSheetOpened = {
		eventName = "shareSheetOpened",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Share sheet was opened"
	},
	shareSheetLinkCopied = {
		eventName = "shareSheetLinkCopied",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Link was copied from share sheet"
	},
	shareSheetMessageSent = {
		eventName = "shareSheetMessageSent",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2025, 7, 22 },
		description = "Message was sent from share sheet"
	},
	Lifecycle = {
		eventName = "shareSheetLifecycle",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 3 },
		description = "Share sheet request lifecycle transitions"
	},
	Interaction = {
		eventName = "shareSheetInteraction",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 8, 3 },
		description = "User interactions within the share sheet"
	},
	MessageSendResult = {
		eventName = "shareSheetMessageSendResult",
		backends = { eventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 2026, 9, 8 },
		description = "Per-recipient share sheet message send results"
	}
}

local v6 = { "addPlaceId", "addUniverseId", "addPlaySessionId", "addSessionInfo" }

local v7 = {}

v7.LifecycleType = { Open = "open", Close = "close" }

v7.CloseReason = {
	UserDismissed = "userDismissed",
	SendSuccess = "sendSuccess",
	Programmatic = "programmatic",
	Replaced = "replaced"
}

v7.InteractionType = {
	CopyLink = "copyLink",
	NativeShare = "nativeShare",
	ConversationSelected = "conversationSelected",
	ConversationDeselected = "conversationDeselected",
	CustomMessageComposerFocused = "customMessageComposerFocused",
	CustomMessageSubmitted = "customMessageSubmitted",
	ViewMessage = "viewMessage"
}

v7.ViewDestination = { Conversation = "conversation", ChatLanding = "chatLanding" }

local v8 = {
	eventName = "shareSheetOpened",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet requests opened"
}

local v9 = {
	eventName = "shareSheetClosed",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet requests closed"
}

local v10 = {
	eventName = "shareSheetInteraction",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 8, 3 },
	description = "Count of share sheet interactions"
}

local v11 = {
	eventName = "shareSheetMessageSendResult",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 8 },
	description = "Count of per-recipient share sheet message send results"
}

local v12 = {
	eventName = "shareSheetMessageSendResultDurationMs",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 2026, 9, 8 },
	description = "Duration in milliseconds from recipient send invocation to result"
}

function v7.logShareSheetOpened(p2)
	TelemetryService:LogEvent(v5.shareSheetOpened, {
		standardizedFields = v6,
		customFields = p2
	})
end

function v7.logShareSheetLinkCopied(p2)
	TelemetryService:LogEvent(v5.shareSheetLinkCopied, {
		standardizedFields = v6,
		customFields = p2
	})
end

function v7.logShareSheetMessageSent(p2)
	TelemetryService:LogEvent(v5.shareSheetMessageSent, {
		standardizedFields = v6,
		customFields = p2
	})
end

function v7.logLifecycle(data)
	TelemetryService:LogEvent(v5.Lifecycle, {
		standardizedFields = v6,
		customFields = data
	})

	local v14 = if data.lifecycleType == v7.LifecycleType.Open then v8 else v9
	TelemetryService:LogCounter(v14, {
		customFields = { context = data.context, closeReason = data.closeReason }
	}, 1)
end

function v7.logInteraction(p2)
	TelemetryService:LogEvent(v5.Interaction, {
		standardizedFields = v6,
		customFields = p2
	})

	TelemetryService:LogCounter(v10, {
		customFields = { context = p2.context, interactionType = p2.interactionType }
	}, 1)
end

function v7.logMessageSendResult(data)
	TelemetryService:LogEvent(v5.MessageSendResult, {
		standardizedFields = v6,
		customFields = data
	})

	TelemetryService:LogStat(v12, {
		customFields = {
			context = data.context,
			sendStatus = data.sendStatus,
			hasCustomMessage = data.hasCustomMessage
		}
	}, data.durationMs)
	TelemetryService:LogCounter(v11, {
		customFields = {
			context = data.context,
			sendStatus = data.sendStatus,
			hasCustomMessage = data.hasCustomMessage
		}
	}, 1)
end

function v7.startMessageSendResult(data)
	local now = os.clock()
	return function(p2)
		v7.logMessageSendResult({
			context = data.context,
			recipientSource = data.recipientSource,
			telemetryId = data.telemetryId,
			requestedConversationId = data.requestedConversationId,
			resolvedConversationId = p2.conversationId,
			sendStatus = p2.status,
			hasCustomMessage = data.hasCustomMessage,
			durationMs = getElapsedTimeMs(now)
		})
	end
end

return v7
