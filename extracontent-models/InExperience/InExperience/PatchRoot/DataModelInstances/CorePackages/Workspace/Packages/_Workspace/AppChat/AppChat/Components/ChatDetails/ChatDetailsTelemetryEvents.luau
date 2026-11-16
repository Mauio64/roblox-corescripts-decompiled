local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Telemetry = require(AppChat.Telemetry.Telemetry)
require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
require(parent.SocialLuaAnalytics)
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
		lastUpdated = { 2026, 1, 27 },
		backendsList = {
			DefaultTelemetryEvents.eventIngestWithFormatFunction(function(p)
				return { isGroupConversation = p.isGroupConversation }
			end),
			namedCounterConfigurationAndFormat("AppChat.ChatDetails.Rendered", function(p)
				return { isGroupConversation = p.isGroupConversation }
			end)
		}
	}),
	ChatDetailsLeaveGroupBtnClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.LeaveGroup"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsCreateUnfilteredChatCellClicked = Telemetry.new({
		name = "chatDetailsCreateUnfilteredChatCellClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.CreateUnfilteredChat"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsCreateUnfilteredChatCellRendered = Telemetry.new({
		name = "chatDetailsCreateUnfilteredChatCellRendered",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.CreateUnfilteredChatCell.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	ChatDetailsAddFriendsBtnClicked = Telemetry.new({
		name = "chatDetailsAddFriendsBtnClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo("AppChat.ChatDetails.Button.AddFriends"),
			EVENT_INGEST_NO_EMITTED_INFO
		}
	}),
	LeaveGroupDialogRendered = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogRendered",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Rendered"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	LeaveGroupDialogLeaveClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogLeaveClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Button.Leave"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	LeaveGroupDialogStayClicked = Telemetry.new({
		name = "chatDetailsLeaveGroupDialogStayClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.LeaveGroup.Button.Stay"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogReportUserClicked = Telemetry.new({
		name = "chatDetailsReportUserClicked",
		description = "",
		lastUpdated = { 2025, 7, 14 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.ReportUser"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	}),
	ParticipantDialogChatClicked = Telemetry.new({
		name = "chatDetailsParticipantDialogChatClicked",
		description = "",
		lastUpdated = { 2026, 4, 2 },
		backendsList = {
			namedCounterConfigurationNoEmittedInfo2("AppChat.Dialog.ParticipantDetails.Button.Chat"),
			EVENT_INGEST_NO_EMITTED_INFO2
		}
	})
}
