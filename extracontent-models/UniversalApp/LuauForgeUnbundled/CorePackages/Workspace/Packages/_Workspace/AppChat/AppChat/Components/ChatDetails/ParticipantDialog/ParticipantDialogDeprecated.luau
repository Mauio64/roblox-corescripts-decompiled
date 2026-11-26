require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/Logger")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")

local modalBottomSheet = UIBlox.ModalBottomSheet

local v5 = {
	conversationId = nil,
	participantId = nil,
	showRemoveUserButton = false,
	showViewProfileButton = true,
	showChatButton = false,
	viewProfileText = "localizedText.ViewProfile",
	chatText = "localizedText.Chat",
	reportUserText = "localizedText.ReportUser",
	removeFromGroupText = "localizedText.RemoveFromGroup",
	cancelText = "localizedText.Cancel",
	openViewProfile = function(p2)
		Logger:warning("openViewProfile was not passed to ParticipantDialogDeprecated")
	end,
	openChat = function(...)
		Logger:warning("openChat was not passed to ParticipantDialogDeprecated")
	end,
	openReportUser = function(...)
		Logger:warning("openReportUser was not passed to ParticipantDialogDeprecated")
	end,
	openRemoveUserDialog = function(...)
		Logger:warning("openRemoveUserDialog was not passed to ParticipantDialogDeprecated")
	end,
	onDismiss = function(p2)
		Logger:warning("onDismiss was not passed to ParticipantDialogDeprecated")
	end
}

function LUAUFORGE_MODULE_GLOBALS_hoX_ParticipantDialogDeprecated(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local conversationId = joined.conversationId
	local participantId = joined.participantId
	local showRemoveUserButton = joined.showRemoveUserButton
	local onDismiss = joined.onDismiss or function() end

	local v7 = {}

	local function insertAction(p3, onActivated, p4)
		local v9 = {
			text = p3,
			stayOnActivated = p4 and true or nil,
			onActivated = nil
		}

		if p4 then
			onActivated = nil
		end

		v9.onActivated = onActivated
		table.insert(v7, v9)
	end

	if joined.showViewProfileButton then
		table.insert(v7, {
			text = joined.viewProfileText,
			stayOnActivated = nil,
			onActivated = function()
				Logger:info("User activated viewProfile | userId: {}", participantId)
				joined.openViewProfile(participantId)
			end
		})
	end

	if joined.showChatButton then
		table.insert(v7, {
			text = joined.chatText,
			stayOnActivated = nil,
			onActivated = function()
				Logger:info("User activated openChat | userId: {}", participantId)
				v6.emit(ChatDetailsTelemetryEvents.ParticipantDialogChatClicked, {})
				joined.openChat(participantId)
			end
		})
	end

	table.insert(v7, {
		text = joined.reportUserText,
		stayOnActivated = nil,
		onActivated = function()
			Logger:info(
				"User activated reportUser | userId: {}, conversationId: {}",
				participantId,
				conversationId
			)
			v6.emit(ChatDetailsTelemetryEvents.ParticipantDialogReportUserClicked, {})
			joined.openReportUser(participantId, conversationId)
		end
	})

	if showRemoveUserButton then
		table.insert(v7, {
			text = joined.removeFromGroupText,
			stayOnActivated = nil,
			onActivated = function()
				joined.openRemoveUserDialog(participantId, conversationId)
			end
		})
	end

	table.insert(v7, {
		text = joined.cancelText,
		stayOnActivated = nil,
		onActivated = onDismiss
	})

	return React.createElement(modalBottomSheet, {
		bottomGap = 10,
		onDismiss = onDismiss,
		buttonModels = v7,
		screenWidth = 400,
		showImages = false
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hoX_ParticipantDialogDeprecated)
