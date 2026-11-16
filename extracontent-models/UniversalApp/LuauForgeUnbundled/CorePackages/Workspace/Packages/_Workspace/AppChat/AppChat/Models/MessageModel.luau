local Players = game:GetService("Players")

local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local generateStringId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").GenerateStringId
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Logger")

local getFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")

local v5 = {
	SenderTypes = { User = "user", System = "system", UnknownType = "unknown_type" },
	MessageTypes = { PlainText = "PlainText", Link = "Link", System = "System" },
	LinkTypes = { Game = "Game" },
	ModerationTypes = {
		TrustedComms = "trusted_comms",
		Moderated = "moderated",
		Invalid = "invalid",
		UnknownType = "unknown_type"
	},
	VisibilityTypes = { Visible = "visible", Hidden = "hidden", Invalid = "invalid" }
}

function v5.new(options)
	v5.__index = v5

	local v6 = options or {}

	setmetatable(v6, v5)

	return v6
end

function v5.newSendingId()
	return "sending-message-" .. generateStringId()
end

function v5.newSending(data)
	assert(data, "props argument is missing")
	assert(data.id, "props.id argument is missing")
	assert(data.messageType, "props.messageType argument is missing")
	assert(data.order, "props.order argument is missing")
	assert(data.conversationId, "props.conversationId argument is missing")
	assert(data.sent, "props.sent argument is missing")

	local sending = v5.new(data)

	sending.senderTargetId = tostring(Players.LocalPlayer.UserId)
	sending.senderType = v5.SenderTypes.User
	sending.moderated = false
	sending.failed = false

	sending.stableKey = sending.id

	return sending
end

function v5.fromChannelsApi(data, p2, previousMessageId, p3)
	if not v5.DoRequiredFieldsPresentFromChannelsApi(data) then
		return nil
	end

	local v6 = v5.new()

	v6.id = data.id
	v6.read = true
	v6.sent = dateTime.fromIsoDate(data.created_at)
	v6.conversationId = tostring(p2)
	v6.previousMessageId = previousMessageId
	v6.filteredForReceivers = false
	v6.content = data.content
	v6.previewContent = data.preview_content

	if data.type == v5.SenderTypes.User then
		v6:serializeForUserMessage(data)
	elseif data.type == v5.SenderTypes.System then
		v6:serializeForSystemMessage(data)
	end

	local v7 = if getFFlagEnableSocialCards() then data.cards else nil
	v6.cards = v7

	if getFFlagEnableSocialCards() then
		v6.senderTargetId = tostring(data.sender_user_id)
	end

	v6.stableKey = v6.id

	v6.isBadgeable = data.is_badgeable
	v6.isPreviewable = data.is_previewable

	if FFlagAppChatEnableAutotranslation then
		v6.contentToDisplay = data.content_to_display
	end

	return v6
end

function v5:serializeForUserMessage(data)
	self.senderTargetId = tostring(data.sender_user_id)
	self.senderType = v5.SenderTypes.User
	self.moderationType = data.moderation_type
	self.repliesTo = v5.fromChannelsApi(data.replies_to, nil, nil, true)

	if
		data.visibility
		and (data.visibility == v5.VisibilityTypes.Visible or data.visibility == v5.VisibilityTypes.Hidden)
	then
		self.visibility = data.visibility
	else
		self.visibility = v5.VisibilityTypes.Invalid
		Logger:debug("Message visibility type is invalid for message id: " .. self.id)
	end

	self.messageType = v5.MessageTypes.PlainText
end

function v5:serializeForSystemMessage(p3)
	self.senderType = v5.SenderTypes.System
	self.messageType = v5.MessageTypes.System
end

function v5.DoRequiredFieldsPresentFromChannelsApi(data)
	if not data then
		return false
	end

	if data.type == v5.SenderTypes.User then
		return data.id and data.sender_user_id and data.created_at
	end

	if data.type == v5.SenderTypes.System then
		return data.id and data.created_at
	end

	return false
end

function v5:parseContentFromChannelsApi(p3)
	self.messageType = v5.MessageTypes.PlainText
	self.content = p3.content
end

function v5.fromSentChannelsApi(p2, p3, p4)
	if not v5.DoRequiredFieldsPresentForSentFromChannelsApi(p2) then
		return nil
	end

	local v6 = v5.new()
	v6.id = p2.messages[1].id
	v6.senderTargetId = tostring(p2.messages[1].sender_user_id)
	v6.senderType = v5.SenderTypes.User
	v6.read = true
	v6.sent = dateTime.fromIsoDate(p2.messages[1].created_at)
	v6.conversationId = tostring(p3)
	v6.previousMessageId = ""
	v6.moderationType = p2.messages[1].moderation_type

	v6.stableKey = p4 or v6.id
	v6.isBadgeable = p2.messages[1].is_badgeable
	v6.isPreviewable = p2.messages[1].is_previewable

	v6.filteredForReceivers = false

	v6.messageType = v5.MessageTypes.PlainText
	v6.content = p2.messages[1].content
	v6.repliesTo = v5.fromChannelsApi(p2.messages[1].replies_to, nil, nil, true)

	if
		p2.visibility
		and (p2.visibility == v5.VisibilityTypes.Visible or p2.visibility == v5.VisibilityTypes.Hidden)
	then
		v6.visibility = p2.visibility
		return v6
	end

	v6.visibility = v5.VisibilityTypes.Visible
	Logger:debug("Message visibility type is invalid for message id: " .. v6.id)

	return v6
end

function v5.DoRequiredFieldsPresentForSentFromChannelsApi(p2)
	local v6 = p2 and p2.messages

	if v6 then
		v6 = #p2.messages > 0 and (p2.messages[1].id and p2.messages[1].created_at)
	end

	return v6
end

return v5
