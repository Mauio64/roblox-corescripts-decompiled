local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local UIBlox = require(AppChatParent.UIBlox)
local Logger = require(script.Parent.Logger)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
local ModalBottomSheet = UIBlox.ModalBottomSheet
local t1 = {
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
	openViewProfile = function(_) -- line: 61
		-- upvalues: Logger (copy)
		Logger:warning("openViewProfile was not passed to ParticipantDialogDeprecated")
	end,
	openChat = function(...) -- line: 64
		-- upvalues: Logger (copy)
		Logger:warning("openChat was not passed to ParticipantDialogDeprecated")
	end,
	openReportUser = function(...) -- line: 67
		-- upvalues: Logger (copy)
		Logger:warning("openReportUser was not passed to ParticipantDialogDeprecated")
	end,
	openRemoveUserDialog = function(...) -- line: 70
		-- upvalues: Logger (copy)
		Logger:warning("openRemoveUserDialog was not passed to ParticipantDialogDeprecated")
	end,
	onDismiss = function(_) -- line: 73
		-- upvalues: Logger (copy)
		Logger:warning("onDismiss was not passed to ParticipantDialogDeprecated")
	end
}

function ParticipantDialogDeprecated(t2: {[any]: any}) -- line: 80
	-- upvalues: Cryo (copy), t1 (copy), useTelemetry (copy), ChatDialogTelemetryLayer (copy), Logger (copy), ChatDetailsTelemetryEvents (copy), React (copy), ModalBottomSheet (copy)
	local v16 = Cryo.Dictionary.join(t1, t2)
	local v17 = useTelemetry(ChatDialogTelemetryLayer.Context)
	local conversationId = v16.conversationId
	local participantId = v16.participantId
	local showRemoveUserButton = v16.showRemoveUserButton
	local v21 = v16.onDismiss or function() -- line: 86
	end
	local t3 = {}

	local function insertAction(s1: string?, p3: ((...any) -> ...any)?, b1: boolean?) -- line: 90
		-- upvalues: t3 (copy)
		table.insert(t3, {
			text = s1,
			stayOnActivated = not not b1 or nil,
			onActivated = if not b1 then p3 else nil
		})
	end

	if v16.showViewProfileButton then
		local viewProfileText = v16.viewProfileText

		table.insert(t3, {
			stayOnActivated = nil,
			text = viewProfileText,
			onActivated = function() -- line: 102
				-- upvalues: Logger (copy), participantId (copy), v16 (copy)
				Logger:info("User activated viewProfile | userId: {}", participantId)
				v16.openViewProfile(participantId)
			end
		})
	end

	if v16.showChatButton then
		local chatText = v16.chatText

		table.insert(t3, {
			stayOnActivated = nil,
			text = chatText,
			onActivated = function() -- line: 109
				-- upvalues: Logger (copy), participantId (copy), v17 (copy), ChatDetailsTelemetryEvents (copy), v16 (copy)
				Logger:info("User activated openChat | userId: {}", participantId)
				v17.emit(ChatDetailsTelemetryEvents.ParticipantDialogChatClicked, {})
				v16.openChat(participantId)
			end
		})
	end

	local reportUserText = v16.reportUserText

	table.insert(t3, {
		stayOnActivated = nil,
		text = reportUserText,
		onActivated = function() -- line: 116
			-- upvalues: Logger (copy), participantId (copy), conversationId (copy), v17 (copy), ChatDetailsTelemetryEvents (copy), v16 (copy)
			Logger:info("User activated reportUser | userId: {}, conversationId: {}", participantId, conversationId)
			v17.emit(ChatDetailsTelemetryEvents.ParticipantDialogReportUserClicked, {})
			v16.openReportUser(participantId, conversationId)
		end
	})

	if showRemoveUserButton then
		local removeFromGroupText = v16.removeFromGroupText

		table.insert(t3, {
			stayOnActivated = nil,
			text = removeFromGroupText,
			onActivated = function() -- line: 123
				-- upvalues: v16 (copy), participantId (copy), conversationId (copy)
				v16.openRemoveUserDialog(participantId, conversationId)
			end
		})
	end

	local cancelText = v16.cancelText

	table.insert(t3, {
		stayOnActivated = nil,
		text = cancelText,
		onActivated = v21
	})

	return React.createElement(ModalBottomSheet, {
		bottomGap = 10,
		screenWidth = 400,
		showImages = false,
		onDismiss = v21,
		buttonModels = t3
	})
end

return memo(ParticipantDialogDeprecated)
