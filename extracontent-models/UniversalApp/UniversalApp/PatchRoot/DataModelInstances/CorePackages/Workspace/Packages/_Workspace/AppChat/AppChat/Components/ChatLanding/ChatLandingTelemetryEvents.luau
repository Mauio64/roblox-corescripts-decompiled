local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Telemetry = require(AppChat.Telemetry.Telemetry)

require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
require(AppChatParent.SocialLuaAnalytics)

local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local namedCounterConfigurationNoEmittedInfo = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local namedStatConfigurationAndFormat = DefaultTelemetryEvents.namedStatConfigurationAndFormat
local EVENT_INGEST_NO_EMITTED_INFO = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO

return {
	AppChatVisible = Telemetry.new({
		name = "appChatVisible",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.Navigation.Visible", function(t1: {[any]: any}) -- line: 23
				return {
					isChatEnabled = t1.isChatEnabled,
					isChatLoading = t1.isChatLoading
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t2: {[any]: any}) -- line: 33
				return {
					isChatEnabled = t2.isChatEnabled,
					isChatLoading = t2.isChatLoading
				}
			end)
		}
	}),
	AppChatClosed = Telemetry.new({
		name = "appChatClosed",
		description = "",
		lastUpdated = {
			2026,
			2,
			9
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.Navigation.Closed", function(t3: {[any]: any}) -- line: 47
				return {
					isChatEnabled = t3.isChatEnabled,
					isChatLoading = t3.isChatLoading
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t4: {[any]: any}) -- line: 57
				return {
					isChatEnabled = t4.isChatEnabled,
					isChatLoading = t4.isChatLoading
				}
			end)
		}
	}),
	ScreenRendered = Telemetry.new({
		name = "chatLandingScreenRendered",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Rendered", function(t5: {[any]: any}) -- line: 71
				return {
					isChatEnabled = t5.isChatEnabled
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t6: {[any]: any}) -- line: 78
				return {
					isChatEnabled = t6.isChatEnabled
				}
			end)
		}
	}),
	ChatEmptyStateScreenRendered = Telemetry.new({
		name = "chatEmptyStateScreenRendered",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.EmptyState.Rendered", function(t7: {[any]: any}) -- line: 90
				return {
					emptyStateType = t7.emptyStateType
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t8: {[any]: any}) -- line: 97
				return {
					emptyStateType = t8.emptyStateType
				}
			end)
		}
	}),
	ChatAddFriendsBtnClicked = Telemetry.new({
		name = "chatAddFriendsBtnClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.AddConnections"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingSearchBtnClicked = Telemetry.new({
		name = "chatLandingSearchBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Search"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingComposeBtnClicked = Telemetry.new({
		name = "chatLandingComposeBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Compose"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingNotifBtnClicked = Telemetry.new({
		name = "chatLandingNotifBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Notifications"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingSnoozeBtnClicked = Telemetry.new({
		name = "chatLandingSnoozeBtnClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Button.Snooze", function(t9: {[any]: any}) -- line: 145
				return {
					isChatNotificationsMuted = t9.isChatNotificationsMuted
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t10: {[any]: any}) -- line: 153
				return {
					isChatNotificationsMuted = t10.isChatNotificationsMuted
				}
			end)
		}
	}),
	ConversationCellRendered = Telemetry.new({
		name = "chatLandingConversationCellRendered",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.ConversationCell.Rendered", function(t11: {[any]: any}) -- line: 166
				return {
					isFiltered = t11.isFiltered,
					hasUnreadMessages = t11.hasUnreadMessages,
					selectedConversationModerationType = t11.selectedConversationModerationType,
					selectedConversationUserPendingStatus = t11.selectedConversationUserPendingStatus,
					osaAcknowledgementStatus = t11.osaAcknowledgementStatus
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t12: {[any]: any}) -- line: 187
				return {
					isFiltered = t12.isFiltered,
					conversationListCount = t12.conversationListCount,
					selectedConversationId = t12.selectedConversationId,
					selectedIndex = t12.selectedIndex,
					hasUnreadMessages = t12.hasUnreadMessages,
					selectedConversationModerationType = t12.selectedConversationModerationType,
					selectedConversationUserPendingStatus = t12.selectedConversationUserPendingStatus,
					participantUserIds = t12.participantUserIds,
					osaAcknowledgementStatus = t12.osaAcknowledgementStatus
				}
			end)
		}
	}),
	ConversationCellRenderedIndexStat = Telemetry.new({
		name = "chatLandingConversationCellRenderedIndexStat",
		description = "",
		lastUpdated = {
			2026,
			1,
			30
		},
		backendsList = { namedStatConfigurationAndFormat("chatLandingConversationCellRenderedIndexStat", function(_: {[any]: any}) -- line: 217
			return {}
		end) }
	}),
	ConversationClicked = Telemetry.new({
		name = "chatLandingConversationClicked",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			namedCounterConfigurationAndFormat("AppChat.ChatLanding.Button.Conversation", function(t14: {[any]: any}) -- line: 229
				return {
					isFiltered = t14.isFiltered,
					hasUnreadMessages = t14.hasUnreadMessages,
					selectedConversationModerationType = t14.selectedConversationModerationType,
					selectedConversationUserPendingStatus = t14.selectedConversationUserPendingStatus,
					osaAcknowledgementStatus = t14.osaAcknowledgementStatus
				}
			end),
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t15: {[any]: any}) -- line: 249
				return {
					isFiltered = t15.isFiltered,
					conversationListCount = t15.conversationListCount,
					selectedConversationId = t15.selectedConversationId,
					selectedIndex = t15.selectedIndex,
					hasUnreadMessages = t15.hasUnreadMessages,
					selectedConversationModerationType = t15.selectedConversationModerationType,
					selectedConversationUserPendingStatus = t15.selectedConversationUserPendingStatus,
					participantUserIds = t15.participantUserIds,
					osaAcknowledgementStatus = t15.osaAcknowledgementStatus,
					osaImpressionId = t15.osaImpressionId
				}
			end)
		}
	}),
	ConversationClickedIndexStat = Telemetry.new({
		name = "chatLandingConversationClickedIndexStat",
		description = "",
		lastUpdated = {
			2026,
			1,
			30
		},
		backendsList = { namedStatConfigurationAndFormat("chatLandingConversationClickedIndexStat", function(_: {[any]: any}) -- line: 281
			return {}
		end) }
	}),
	ChatLandingGroupsBtnClicked = Telemetry.new({
		name = "chatLandingGroupsBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.Button.Groups"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellRendered = Telemetry.new({
		name = "chatLandingPvUpsellRendered",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellDismissed = Telemetry.new({
		name = "chatLandingPvUpsellDismissed",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Dismissed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellContinueClicked = Telemetry.new({
		name = "chatLandingPvUpsellContinueClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Button.Continue"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellSucceeded = Telemetry.new({
		name = "chatLandingPvUpsellSucceeded",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Succeeded"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingPvUpsellFailed = Telemetry.new({
		name = "chatLandingPvUpsellFailed",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.PvUpsell.Failed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxRendered = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxRendered",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxDismissed = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxDismissed",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Dismissed"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatLandingUnfilteredThreadsFtuxLearnMoreClicked = Telemetry.new({
		name = "chatLandingUnfilteredThreadsFtuxLearnMoreClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			31
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatLanding.UnfilteredThreadsFtux.Button.LearnMore"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	})
}
