local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local UIBlox = require(parent.UIBlox)
local Logger = require(script.Parent.Logger)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)

local ModalBottomSheet = UIBlox.ModalBottomSheet

local v = {
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
	openViewProfile = function(_)
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
	onDismiss = function(_)
		Logger:warning("onDismiss was not passed to ParticipantDialogDeprecated")
	end
}

function ParticipantDialogDeprecated(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTelemetry(ChatDialogTelemetryLayer.Context)
	local conversationId = joined.conversationId
	local participantId = joined.participantId
	local showRemoveUserButton = joined.showRemoveUserButton
	local onDismiss = joined.onDismiss or function() end

	local buttonModels = {}

	local function insertAction(text: string?, onActivated, flag: boolean?)
		local v3 = {
			text = text,
			stayOnActivated = flag and true or nil,
			onActivated = nil
		}

		if flag then
			onActivated = nil
		end

		v3.onActivated = onActivated
		table.insert(buttonModels, v3)
	end

	if joined.showViewProfileButton then
		local function onActivated()
			Logger:info("User activated viewProfile | userId: {}", participantId)
			joined.openViewProfile(participantId)
		end

		table.insert(buttonModels, {
			text = joined.viewProfileText,
			stayOnActivated = nil,
			onActivated = onActivated
		})
	end

	if joined.showChatButton then
		local function onActivated()
			Logger:info("User activated openChat | userId: {}", participantId)
			v2.emit(ChatDetailsTelemetryEvents.ParticipantDialogChatClicked, {})
			joined.openChat(participantId)
		end

		table.insert(buttonModels, {
			text = joined.chatText,
			stayOnActivated = nil,
			onActivated = onActivated
		})
	end

	local function onActivated()
		Logger:info("User activated reportUser | userId: {}, conversationId: {}", participantId, conversationId)
		v2.emit(ChatDetailsTelemetryEvents.ParticipantDialogReportUserClicked, {})
		joined.openReportUser(participantId, conversationId)
	end

	table.insert(buttonModels, {
		text = joined.reportUserText,
		stayOnActivated = nil,
		onActivated = onActivated
	})

	if showRemoveUserButton then
		table.insert(buttonModels, {
			text = joined.removeFromGroupText,
			stayOnActivated = nil,
			onActivated = function()
				joined.openRemoveUserDialog(participantId, conversationId)
			end
		})
	end

	table.insert(buttonModels, {
		text = joined.cancelText,
		stayOnActivated = nil,
		onActivated = onDismiss
	})

	return React.createElement(ModalBottomSheet, {
		bottomGap = 10,
		onDismiss = onDismiss,
		buttonModels = buttonModels,
		screenWidth = 400,
		showImages = false
	})
end

return memo(ParticipantDialogDeprecated)
