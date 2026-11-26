local Telemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Telemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
local DefaultTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/DefaultTelemetryEvents")

local namedCounterConfigurationNoEmittedInfo = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local namedStatConfigurationAndFormat = DefaultTelemetryEvents.namedStatConfigurationAndFormat

local EVENT_INGEST_NO_EMITTED_INFO = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO

return {
	AppChatVisible = Telemetry.new({
		name = "appChatVisible",
		description = "",
		lastUpdated = { 2026, 10, 7 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.Navigation.Visible", function(data)
				return {
					isChatEnabled = data.isChatEnabled,
					isChatLoading = data.isChatLoading,
					isInConversation = data.isInConversation
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return {
					isChatEnabled = p2.isChatEnabled,
					isChatLoading = p2.isChatLoading
				}
			end)
		}
	}),
	AppChatClosed = Telemetry.new({
		name = "appChatClosed",
		description = "",
		lastUpdated = { 2026, 2, 9 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.Navigation.Closed", function(p2)
				return {
					isChatEnabled = p2.isChatEnabled,
					isChatLoading = p2.isChatLoading
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return {
					isChatEnabled = p2.isChatEnabled,
					isChatLoading = p2.isChatLoading
				}
			end)
		}
	}),
	ScreenRendered = Telemetry.new({
		name = "chatLandingScreenRendered",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Rendered", function(p2)
				return { isChatEnabled = p2.isChatEnabled }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { isChatEnabled = p2.isChatEnabled }
			end)
		}
	}),
	ChatEmptyStateScreenRendered = Telemetry.new({
		name = "chatEmptyStateScreenRendered",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.EmptyState.Rendered", function(p2)
				return { emptyStateType = p2.emptyStateType }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { emptyStateType = p2.emptyStateType }
			end)
		}
	}),
	ChatAddFriendsBtnClicked = Telemetry.new({
		name = "chatAddFriendsBtnClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.AddConnections"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingSearchBtnClicked = Telemetry.new({
		name = "chatLandingSearchBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Search"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingComposeBtnClicked = Telemetry.new({
		name = "chatLandingComposeBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Compose"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingNotifBtnClicked = Telemetry.new({
		name = "chatLandingNotifBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Notifications"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingSnoozeBtnClicked = Telemetry.new({
		name = "chatLandingSnoozeBtnClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Button.Snooze", function(p2)
				return { isChatNotificationsMuted = p2.isChatNotificationsMuted }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p2)
				return { isChatNotificationsMuted = p2.isChatNotificationsMuted }
			end)
		}
	}),
	ConversationCellRendered = Telemetry.new({
		name = "chatLandingConversationCellRendered",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat(
				"AppChat.ChatLanding.ConversationCell.Rendered",
				function(data)
					return {
						isFiltered = data.isFiltered,
						hasUnreadMessages = data.hasUnreadMessages,
						selectedConversationModerationType = data.selectedConversationModerationType,
						selectedConversationUserPendingStatus = data.selectedConversationUserPendingStatus,
						osaAcknowledgementStatus = data.osaAcknowledgementStatus
					}
				end
			),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(data)
				return {
					isFiltered = data.isFiltered,
					conversationListCount = data.conversationListCount,
					selectedConversationId = data.selectedConversationId,
					selectedIndex = data.selectedIndex,
					hasUnreadMessages = data.hasUnreadMessages,
					selectedConversationModerationType = data.selectedConversationModerationType,
					selectedConversationUserPendingStatus = data.selectedConversationUserPendingStatus,
					participantUserIds = data.participantUserIds,
					osaAcknowledgementStatus = data.osaAcknowledgementStatus
				}
			end)
		}
	}),
	ConversationCellRenderedIndexStat = Telemetry.new({
		name = "chatLandingConversationCellRenderedIndexStat",
		description = "",
		lastUpdated = { 2026, 1, 30 },
		backendsList = { namedStatConfigurationAndFormat(
				"chatLandingConversationCellRenderedIndexStat",
				function(p2)
					return {}
				end
			) }
	}),
	ConversationClicked = Telemetry.new({
		name = "chatLandingConversationClicked",
		description = "",
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Button.Conversation", function(data)
				return {
					isFiltered = data.isFiltered,
					hasUnreadMessages = data.hasUnreadMessages,
					selectedConversationModerationType = data.selectedConversationModerationType,
					selectedConversationUserPendingStatus = data.selectedConversationUserPendingStatus,
					osaAcknowledgementStatus = data.osaAcknowledgementStatus
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(data)
				return {
					isFiltered = data.isFiltered,
					conversationListCount = data.conversationListCount,
					selectedConversationId = data.selectedConversationId,
					selectedIndex = data.selectedIndex,
					hasUnreadMessages = data.hasUnreadMessages,
					selectedConversationModerationType = data.selectedConversationModerationType,
					selectedConversationUserPendingStatus = data.selectedConversationUserPendingStatus,
					participantUserIds = data.participantUserIds,
					osaAcknowledgementStatus = data.osaAcknowledgementStatus,
					osaImpressionId = data.osaImpressionId
				}
			end)
		}
	}),
	ConversationClickedIndexStat = Telemetry.new({
		name = "chatLandingConversationClickedIndexStat",
		description = "",
		lastUpdated = { 2026, 1, 30 },
		backendsList = { namedStatConfigurationAndFormat(
				"chatLandingConversationClickedIndexStat",
				function(p2)
					return {}
				end
			) }
	}),
	SearchStarted = Telemetry.new({
		name = "chatLandingSearchStarted",
		description = "A search session opened on the chat landing list. Once per session, on both the client-filter and backend-search paths.",
		lastUpdated = { 2026, 9, 21 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Search.Started"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	SearchResultsRendered = Telemetry.new({
		name = "chatLandingSearchResultsRendered",
		description = "A search query settled. Once per query, with the result count and outcome, which the cell events cannot express when zero cells render.",
		lastUpdated = { 2026, 9, 21 },
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Search.ResultsRendered", function(p2)
				return { searchResultType = p2.searchResultType }
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(data)
				return {
					searchResultCount = data.searchResultCount,
					searchResultType = data.searchResultType,
					searchLatencyMs = data.searchLatencyMs
				}
			end)
		}
	}),
	ChatLandingGroupsBtnClicked = Telemetry.new({
		name = "chatLandingGroupsBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Groups"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellRendered = Telemetry.new({
		name = "chatLandingPvUpsellRendered",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellDismissed = Telemetry.new({
		name = "chatLandingPvUpsellDismissed",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Dismissed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellContinueClicked = Telemetry.new({
		name = "chatLandingPvUpsellContinueClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Button.Continue"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellSucceeded = Telemetry.new({
		name = "chatLandingPvUpsellSucceeded",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Succeeded"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellFailed = Telemetry.new({
		name = "chatLandingPvUpsellFailed",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Failed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxRendered = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxRendered",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxDismissed = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxDismissed",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Dismissed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxLearnMoreClicked = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxLearnMoreClicked",
		description = "",
		lastUpdated = { 2025, 7, 31 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Button.LearnMore"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	})
}
