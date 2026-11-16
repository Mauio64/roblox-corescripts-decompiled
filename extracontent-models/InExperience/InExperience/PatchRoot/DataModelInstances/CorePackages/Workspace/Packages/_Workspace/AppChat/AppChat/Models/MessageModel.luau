local Players = game:GetService("Players")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Time = require(parent.Time)
local DateTime = Time.DateTime
local AppCommonLib = require(parent.AppCommonLib)
local GenerateStringId = AppCommonLib.GenerateStringId
local SharedFlags = require(parent.SharedFlags)
local Logger = require(script.Parent.Logger)

local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards

local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)

local MessageModel = {
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

function MessageModel.new(options)
	MessageModel.__index = MessageModel

	local selected = options or {}

	setmetatable(selected, MessageModel)

	return selected
end

function MessageModel.newSendingId()
	return "sending-message-" .. GenerateStringId()
end

function MessageModel.newSending(data)
	assert(data, "props argument is missing")
	assert(data.id, "props.id argument is missing")
	assert(data.messageType, "props.messageType argument is missing")
	assert(data.order, "props.order argument is missing")
	assert(data.conversationId, "props.conversationId argument is missing")
	assert(data.sent, "props.sent argument is missing")

	local sending = MessageModel.new(data)

	sending.senderTargetId = tostring(Players.LocalPlayer.UserId)
	sending.senderType = MessageModel.SenderTypes.User
	sending.moderated = false
	sending.failed = false

	sending.stableKey = sending.id

	return sending
end

function MessageModel.fromChannelsApi(data, p, previousMessageId, _)
	if not MessageModel.DoRequiredFieldsPresentFromChannelsApi(data) then
		return nil
	end

	local v = MessageModel.new()

	v.id = data.id
	v.read = true
	v.sent = DateTime.fromIsoDate(data.created_at)
	v.conversationId = tostring(p)
	v.previousMessageId = previousMessageId
	v.filteredForReceivers = false
	v.content = data.content
	v.previewContent = data.preview_content

	if data.type == MessageModel.SenderTypes.User then
		v:serializeForUserMessage(data)
	elseif data.type == MessageModel.SenderTypes.System then
		v:serializeForSystemMessage(data)
	end

	local cards

	if GetFFlagEnableSocialCards() then
		cards = data.cards
	end

	v.cards = cards

	if GetFFlagEnableSocialCards() then
		v.senderTargetId = tostring(data.sender_user_id)
	end

	v.stableKey = v.id

	v.isBadgeable = data.is_badgeable
	v.isPreviewable = data.is_previewable

	if FFlagAppChatEnableAutotranslation then
		v.contentToDisplay = data.content_to_display
	end

	return v
end

function MessageModel:serializeForUserMessage(data)
	self.senderTargetId = tostring(data.sender_user_id)
	self.senderType = MessageModel.SenderTypes.User
	self.moderationType = data.moderation_type
	self.repliesTo = MessageModel.fromChannelsApi(data.replies_to, nil, nil, true)

	if
		data.visibility
		and (data.visibility == MessageModel.VisibilityTypes.Visible or data.visibility == MessageModel.VisibilityTypes.Hidden)
	then
		self.visibility = data.visibility
	else
		self.visibility = MessageModel.VisibilityTypes.Invalid
		Logger:debug("Message visibility type is invalid for message id: " .. self.id)
	end

	self.messageType = MessageModel.MessageTypes.PlainText
end

function MessageModel:serializeForSystemMessage(_)
	self.senderType = MessageModel.SenderTypes.System
	self.messageType = MessageModel.MessageTypes.System
end

function MessageModel.DoRequiredFieldsPresentFromChannelsApi(data)
	if not data then
		return false
	end

	if data.type == MessageModel.SenderTypes.User then
		return data.id and data.sender_user_id and data.created_at
	end

	return data.type == MessageModel.SenderTypes.System and data.id and data.created_at
end

function MessageModel:parseContentFromChannelsApi(p)
	self.messageType = MessageModel.MessageTypes.PlainText
	self.content = p.content
end

function MessageModel.fromSentChannelsApi(p, p2, p3)
	if not MessageModel.DoRequiredFieldsPresentForSentFromChannelsApi(p) then
		return nil
	end

	local v = MessageModel.new()
	v.id = p.messages[1].id
	v.senderTargetId = tostring(p.messages[1].sender_user_id)
	v.senderType = MessageModel.SenderTypes.User
	v.read = true
	v.sent = DateTime.fromIsoDate(p.messages[1].created_at)
	v.conversationId = tostring(p2)
	v.previousMessageId = ""
	v.moderationType = p.messages[1].moderation_type

	v.stableKey = p3 or v.id
	v.isBadgeable = p.messages[1].is_badgeable
	v.isPreviewable = p.messages[1].is_previewable

	v.filteredForReceivers = false

	v.messageType = MessageModel.MessageTypes.PlainText
	v.content = p.messages[1].content
	v.repliesTo = MessageModel.fromChannelsApi(p.messages[1].replies_to, nil, nil, true)

	if
		p.visibility
		and (p.visibility == MessageModel.VisibilityTypes.Visible or p.visibility == MessageModel.VisibilityTypes.Hidden)
	then
		v.visibility = p.visibility
		return v
	end

	v.visibility = MessageModel.VisibilityTypes.Visible
	Logger:debug("Message visibility type is invalid for message id: " .. v.id)

	return v
end

function MessageModel.DoRequiredFieldsPresentForSentFromChannelsApi(p)
	local v = p and p.messages

	if v then
		if #p.messages > 0 then
			return p.messages[1].id and p.messages[1].created_at
		end

		return false
	end

	return v
end

return MessageModel
