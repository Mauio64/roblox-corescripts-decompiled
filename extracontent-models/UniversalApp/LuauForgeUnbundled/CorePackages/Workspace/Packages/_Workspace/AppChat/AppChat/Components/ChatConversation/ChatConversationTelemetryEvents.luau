local Telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Telemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ConversationActionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
local DefaultTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/DefaultTelemetryEvents")
local FFlagAppChatEnableMessageContextMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableMessageContextMenu")

local namedCounterConfigurationNoEmittedInfo = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat

local EVENT_INGEST_NO_EMITTED_INFO = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO

local function targetMessageFormatFunction()
	return DefaultTelemetryEvents.eventIngestWithFormatFunction(function(data)
		return {
			targetMessageId = data.targetMessageId,
			targetMessageSenderId = data.targetMessageSenderId,
			targetMessageSentAt = data.targetMessageSentAt,
			targetMessageLength = data.targetMessageLength,
			targetMessageVisibility = data.targetMessageVisibility
		}
	end)
end

local v5 = {
	ScreenRendered = Telemetry.new({
		name = "conversationScreenRendered",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Rendered"),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { loadedMessageCount = p2.loadedMessageCount }
			end)
		}
	}),
	ScreenExit = Telemetry.new({
		name = "conversationScreenExit",
		description = "",
		lastUpdated = { 2026, 11, 4 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Exit", function(p2)
				return { conversationExitType = p2.conversationExitType }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return {
					conversationExitType = p2.conversationExitType,
					loadedMessageCount = p2.loadedMessageCount
				}
			end)
		}
	}),
	ConversationInfoBtnClicked = Telemetry.new({
		name = "conversationInfoBtnClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Button.Info"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ConversationMessageSent = Telemetry.new({
		name = "conversationMessageSent",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Message.Sent", function(p2)
				return { messageSentResult = p2.messageSentResult }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(data)
				return {
					messageSentResult = data.messageSentResult,
					messageId = data.messageId,
					recipientIds = data.recipientIds,
					targetMessageId = data.targetMessageId,
					targetMessageSenderId = data.targetMessageSenderId,
					targetMessageSentAt = data.targetMessageSentAt,
					targetMessageLength = data.targetMessageLength
				}
			end)
		}
	}),
	ConversationMoreMenuBtnClicked = Telemetry.new({
		name = "conversationMoreMenuBtnClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Button.MoreMenu", function(p2)
				return { action = p2.action }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { action = p2.action }
			end)
		}
	}),
	ConversationSendBtnClicked = Telemetry.new({
		name = "conversationSendBtnClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Button.Send", function(p2)
				return { sendBtnClickResult = p2.sendBtnClickResult }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { sendBtnClickResult = p2.sendBtnClickResult }
			end)
		}
	}),
	ConversationMessagePressed = Telemetry.new({
		name = "chatMessagePressed",
		description = "",
		lastUpdated = { 2025, 9, 9 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.Pressed"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageLongPressed = Telemetry.new({
		name = "chatMessageLongPressed",
		description = "",
		lastUpdated = { 2025, 9, 9 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.LongPressed"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageSwiped = Telemetry.new({
		name = "chatMessageSwiped",
		description = "",
		lastUpdated = { 2025, 11, 25 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.Swiped"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageReplyIconImpression = Telemetry.new({
		name = "chatMessageReplyIconImpression",
		description = "",
		lastUpdated = { 2025, 9, 9 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.ReplyIcon.Impression"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageReplyIconClicked = Telemetry.new({
		name = "chatMessageReplyIconClicked",
		description = "",
		lastUpdated = { 2025, 9, 9 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.ReplyIcon.Clicked"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageOpenMenuIconClicked = 0,
	ConversationInputBarReplyComposeRendered = 0,
	ConversationInputBarReplyComposeCancelBtnActivated = 0,
	ConversationMessageFtuxTooltipImpression = 0,
	ConversationMessageFtuxTooltipDismissed = 0,
	GameCardThumbnailClicked = 0,
	GameCardPlayButtonClicked = 0,
	GameCardMetadataClicked = 0
}

local v6 = if FFlagAppChatEnableMessageContextMenu then Telemetry.new({
	name = "chatMessageOpenMenuIconClicked",
	description = "",
	lastUpdated = { 2025, 9, 9 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.OpenMenuIcon.Clicked"),
		targetMessageFormatFunction()
	}
}) else nil
v5.ConversationMessageOpenMenuIconClicked = v6

v5.ConversationInputBarReplyComposeRendered = Telemetry.new({
	name = "chatInputBarReplyComposeRendered",
	description = "",
	lastUpdated = { 2025, 9, 17 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.ReplyComposeBar.Rendered"),
		targetMessageFormatFunction()
	}
})

v5.ConversationInputBarReplyComposeCancelBtnActivated = Telemetry.new({
	name = "chatInputBarReplyComposeCancelBtnActivated",
	description = "",
	lastUpdated = { 2025, 9, 17 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.ReplyComposeBar.Button.Cancel"),
		targetMessageFormatFunction()
	}
})

v5.ConversationMessageFtuxTooltipImpression = Telemetry.new({
	name = "chatMessageFtuxTooltipImpression",
	description = "",
	lastUpdated = { 2026, 1, 27 },
	backendsList = {
		namedCounterConfigurationAndFormat(
			"AppChat.ChatConversation.Message.FtuxTooltip.Impression",
			function(p2)
				return { tooltipVariant = p2.tooltipVariant }
			end
		),
		DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
			return { tooltipVariant = p2.tooltipVariant }
		end)
	}
})

v5.ConversationMessageFtuxTooltipDismissed = Telemetry.new({
	name = "chatMessageFtuxTooltipDismissed",
	description = "",
	lastUpdated = { 2026, 1, 27 },
	backendsList = {
		namedCounterConfigurationAndFormat(
			"AppChat.ChatConversation.Message.FtuxTooltip.Dismissed",
			function(p2)
				return { tooltipVariant = p2.tooltipVariant }
			end
		),
		DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
			return { tooltipVariant = p2.tooltipVariant }
		end)
	}
})

v5.GameCardThumbnailClicked = Telemetry.new({
	name = "gameCardThumbnailClicked",
	description = "",
	lastUpdated = { 2025, 11, 18 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Thumbnail.Clicked"),
		DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
			return { universeId = p2.universeId, placeId = p2.placeId }
		end)
	}
})

v5.GameCardPlayButtonClicked = Telemetry.new({
	name = "gameCardPlayButtonClicked",
	description = "",
	lastUpdated = { 2025, 11, 18 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Button.Play"),
		DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
			return { universeId = p2.universeId, placeId = p2.placeId }
		end)
	}
})

v5.GameCardMetadataClicked = Telemetry.new({
	name = "gameCardMetadataClicked",
	description = "",
	lastUpdated = { 2025, 11, 19 },
	backendsList = {
		namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Metadata.Clicked"),
		DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
			return { universeId = p2.universeId, placeId = p2.placeId }
		end)
	}
})

return v5
