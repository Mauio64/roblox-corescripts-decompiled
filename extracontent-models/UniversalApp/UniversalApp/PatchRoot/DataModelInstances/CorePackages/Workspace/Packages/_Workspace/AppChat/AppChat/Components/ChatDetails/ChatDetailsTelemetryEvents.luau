local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Telemetry = require(AppChat.Telemetry.Telemetry)

require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
require(AppChatParent.SocialLuaAnalytics)

local DefaultTelemetryEvents = require(AppChat.Telemetry.DefaultTelemetryEvents)
local namedCounterConfigurationNoEmittedInfo = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local namedCounterConfigurationAndFormat = DefaultTelemetryEvents.namedCounterConfigurationAndFormat
local EVENT_INGEST_NO_EMITTED_INFO = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO
local namedCounterConfigurationNoEmittedInfo2 = DefaultTelemetryEvents.namedCounterConfigurationNoEmittedInfo
local EVENT_INGEST_NO_EMITTED_INFO2 = DefaultTelemetryEvents.EVENT_INGEST_NO_EMITTED_INFO

return {
	ScreenRendered = Telemetry.new({
		name = "chatDetailsRendered",
		description = "",
		lastUpdated = {
			2026,
			1,
			27
		},
		backendsList = {
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t1: {[any]: any}) -- line: 28
				return {
					isGroupConversation = t1.isGroupConversation
				}
			end),
			namedCounterConfigurationAndFormat("AppChat.ChatDetails.Rendered", function(t2: {[any]: any}) -- line: 34
				return {
					isGroupConversation = t2.isGroupConversation
				}
			end)
		}
	}),
	ChatDetailsLeaveGroupBtnClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.LeaveGroup"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsCreateUnfilteredChatCellClicked = Telemetry.new({
		name = "chatDetailsCreateUnfilteredChatCellClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.CreateUnfilteredChat"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsCreateUnfilteredChatCellRendered = Telemetry.new({
		name = "chatDetailsCreateUnfilteredChatCellRendered",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.CreateUnfilteredChatCell.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsAddFriendsBtnClicked = Telemetry.new({
		name = "chatDetailsAddFriendsBtnClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.AddFriends"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	LeaveGroupDialogRendered = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogRendered",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	LeaveGroupDialogLeaveClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogLeaveClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Button.Leave"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	LeaveGroupDialogStayClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogStayClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Button.Stay"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogReportUserClicked = Telemetry.new({
		name = "chatDetailsReportUserClicked",
		description = "",
		lastUpdated = {
			2025,
			7,
			14
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.ReportUser"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogChatClicked = Telemetry.new({
		name = "chatDetailsParticipantDialogChatClicked",
		description = "",
		lastUpdated = {
			2026,
			4,
			2
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.Chat"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogAddTrustedConnectionClicked = Telemetry.new({
		name = "chatDetailsParticipantDialogAddTrustedConnectionClicked",
		description = "",
		lastUpdated = {
			2026,
			4,
			30
		},
		backendsList = {
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(t3: {[any]: any}) -- line: 130
				return {
					modalVariantOverride = t3.modalVariantOverride
				}
			end),
			namedCounterConfigurationAndFormat("AppChat.Dialog.ParticipantDetails.Button.AddTrustedConnection", function(t4: {[any]: any}) -- line: 138
				return {
					modalVariantOverride = t4.modalVariantOverride
				}
			end)
		}
	}),
	ParticipantDialogAddIncomingTrustedConnectionClicked = Telemetry.new({
		name = "chatDetailsParticipantDialogAddIncomingTrustedConnectionClicked",
		description = "",
		lastUpdated = {
			2026,
			4,
			30
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.AddIncomingTrustedConnection"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogRemoveTrustedConnectionClicked = Telemetry.new({
		name = "chatDetailsParticipantDialogRemoveTrustedConnectionClicked",
		description = "",
		lastUpdated = {
			2026,
			4,
			30
		},
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.RemoveTrustedConnection"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	})
}
