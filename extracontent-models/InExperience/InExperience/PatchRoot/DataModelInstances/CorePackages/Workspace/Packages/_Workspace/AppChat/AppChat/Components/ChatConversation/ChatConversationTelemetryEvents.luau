local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Telemetry = require(AppChat.Telemetry.Telemetry)

require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
require(AppChat.Analytics.Enums.ConversationActionType)
require(AppChatParent.SocialLuaAnalytics)

local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local FFlagAppChatEnableMessageContextMenu = require(AppChat.Flags.FFlagAppChatEnableMessageContextMenu)
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)
local namedCounterConfigurationNoEmittedInfo = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local EVENT_INGEST_NO_EMITTED_INFO = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO

local function targetMessageFormatFunction() -- line: 23
	-- upvalues: DefaultTelemetryEvents (copy)
	return DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t1: {[any]: any}) -- line: 24
		return {
			targetMessageId = t1.targetMessageId,
			targetMessageSenderId = t1.targetMessageSenderId,
			targetMessageSentAt = t1.targetMessageSentAt,
			targetMessageLength = t1.targetMessageLength,
			targetMessageVisibility = t1.targetMessageVisibility
		}
	end)
end

return {
	ScreenRendered = Telemetry.new({
		name = "conversationScreenRendered",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Rendered"),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t2: {[any]: any}) -- line: 48
				return {
					loadedMessageCount = t2.loadedMessageCount
				}
			end)
		}
	}),
	ScreenExit = Telemetry.new({
		name = "conversationScreenExit",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Exit", function(t3: {[any]: any}) -- line: 60
				return {
					conversationExitType = t3.conversationExitType
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t4: {[any]: any}) -- line: 68
				return {
					conversationExitType = t4.conversationExitType
				}
			end)
		}
	}),
	ConversationInfoBtnClicked = Telemetry.new({
		name = "conversationInfoBtnClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Button.Info"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ConversationMessageSent = Telemetry.new({
		name = "conversationMessageSent",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Message.Sent", function(t5: {[any]: any}) -- line: 90
				return {
					messageSentResult = t5.messageSentResult
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t6: {[any]: any}) -- line: 103
				return {
					messageSentResult = t6.messageSentResult,
					messageId = t6.messageId,
					recipientIds = t6.recipientIds,
					targetMessageId = t6.targetMessageId,
					targetMessageSenderId = t6.targetMessageSenderId,
					targetMessageSentAt = t6.targetMessageSentAt,
					targetMessageLength = t6.targetMessageLength
				}
			end)
		}
	}),
	ConversationMoreMenuBtnClicked = Telemetry.new({
		name = "conversationMoreMenuBtnClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Button.MoreMenu", function(t7: {[any]: any}) -- line: 129
				return {
					action = t7.action
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t8: {[any]: any}) -- line: 137
				return {
					action = t8.action
				}
			end)
		}
	}),
	ConversationSendBtnClicked = Telemetry.new({
		name = "conversationSendBtnClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Button.Send", function(t9: {[any]: any}) -- line: 150
				return {
					sendBtnClickResult = t9.sendBtnClickResult
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t10: {[any]: any}) -- line: 157
				return {
					sendBtnClickResult = t10.sendBtnClickResult
				}
			end)
		}
	}),
	ConversationMessagePressed = Telemetry.new({
		name = "chatMessagePressed",
		description = "",
		lastUpdated = {
			2025,
			9,
			9
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.Pressed"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageLongPressed = Telemetry.new({
		name = "chatMessageLongPressed",
		description = "",
		lastUpdated = {
			2025,
			9,
			9
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.LongPressed"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageSwiped = if not FFlagAppChatUseSwipeForReplies then nil else Telemetry.new({
		name = "chatMessageSwiped",
		description = "",
		lastUpdated = {
			2025,
			11,
			25
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.Swiped"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageReplyIconImpression = Telemetry.new({
		name = "chatMessageReplyIconImpression",
		description = "",
		lastUpdated = {
			2025,
			9,
			9
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.ReplyIcon.Impression"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageReplyIconClicked = Telemetry.new({
		name = "chatMessageReplyIconClicked",
		description = "",
		lastUpdated = {
			2025,
			9,
			9
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.ReplyIcon.Clicked"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageOpenMenuIconClicked = if not FFlagAppChatEnableMessageContextMenu then nil else Telemetry.new({
		name = "chatMessageOpenMenuIconClicked",
		description = "",
		lastUpdated = {
			2025,
			9,
			9
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.Message.OpenMenuIcon.Clicked"),
			targetMessageFormatFunction()
		}
	}),
	ConversationInputBarReplyComposeRendered = Telemetry.new({
		name = "chatInputBarReplyComposeRendered",
		description = "",
		lastUpdated = {
			2025,
			9,
			17
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.ReplyComposeBar.Rendered"),
			targetMessageFormatFunction()
		}
	}),
	ConversationInputBarReplyComposeCancelBtnActivated = Telemetry.new({
		name = "chatInputBarReplyComposeCancelBtnActivated",
		description = "",
		lastUpdated = {
			2025,
			9,
			17
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.ReplyComposeBar.Button.Cancel"),
			targetMessageFormatFunction()
		}
	}),
	ConversationMessageFtuxTooltipImpression = Telemetry.new({
		name = "chatMessageFtuxTooltipImpression",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Message.FtuxTooltip.Impression", function(t11: {[any]: any}) -- line: 247
				return {
					tooltipVariant = t11.tooltipVariant
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t12: {[any]: any}) -- line: 255
				return {
					tooltipVariant = t12.tooltipVariant
				}
			end)
		}
	}),
	ConversationMessageFtuxTooltipDismissed = Telemetry.new({
		name = "chatMessageFtuxTooltipDismissed",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatConversation.Message.FtuxTooltip.Dismissed", function(t13: {[any]: any}) -- line: 271
				return {
					tooltipVariant = t13.tooltipVariant
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t14: {[any]: any}) -- line: 279
				return {
					tooltipVariant = t14.tooltipVariant
				}
			end)
		}
	}),
	GameCardThumbnailClicked = Telemetry.new({
		name = "gameCardThumbnailClicked",
		description = "",
		lastUpdated = {
			2025,
			11,
			18
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Thumbnail.Clicked"),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t15: {[any]: any}) -- line: 294
				return {
					universeId = t15.universeId,
					placeId = t15.placeId
				}
			end)
		}
	}),
	GameCardPlayButtonClicked = Telemetry.new({
		name = "gameCardPlayButtonClicked",
		description = "",
		lastUpdated = {
			2025,
			11,
			18
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Button.Play"),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t16: {[any]: any}) -- line: 311
				return {
					universeId = t16.universeId,
					placeId = t16.placeId
				}
			end)
		}
	}),
	GameCardMetadataClicked = Telemetry.new({
		name = "gameCardMetadataClicked",
		description = "",
		lastUpdated = {
			2025,
			11,
			19
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatConversation.GameCard.Metadata.Clicked"),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t17: {[any]: any}) -- line: 328
				return {
					universeId = t17.universeId,
					placeId = t17.placeId
				}
			end)
		}
	})
}
