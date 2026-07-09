local Players = game:GetService("Players")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local DateTime = require(AppChatParent.Time).DateTime
local GenerateStringId = require(AppChatParent.AppCommonLib).GenerateStringId
local SharedFlags = require(AppChatParent.SharedFlags)
local Logger = require(script.Parent.Logger)
local GetFFlagEnableSocialCards = SharedFlags.GetFFlagEnableSocialCards
local FFlagAppChatEnableAutotranslation = require(AppChat.Flags.FFlagAppChatEnableAutotranslation)
local t1 = {
	new = function(p1) -- line: 18
		return {
			universeId = tostring(p1)
		}
	end
}
local t2 = {
	SenderTypes = {
		User = "user",
		System = "system",
		UnknownType = "unknown_type"
	},
	MessageTypes = {
		PlainText = "PlainText",
		Link = "Link",
		System = "System"
	},
	LinkTypes = {
		Game = "Game"
	},
	ModerationTypes = {
		TrustedComms = "trusted_comms",
		Moderated = "moderated",
		Invalid = "invalid",
		UnknownType = "unknown_type"
	},
	VisibilityTypes = {
		Visible = "visible",
		Hidden = "hidden",
		Invalid = "invalid"
	}
}

function t2.new(p2) -- line: 51
	-- upvalues: t2 (copy)
	t2.__index = t2

	local v14 = p2 or {}

	setmetatable(v14, t2)

	return v14
end
function t2.fromWeb(p3, p4, p5) -- line: 61
	-- upvalues: t2 (copy), DateTime (copy)
	if not t2.DoRequiredFieldsPresent(p3) then
		return nil
	end

	local v18 = t2.new()

	v18.id = p3.id
	v18.senderTargetId = tostring(p3.senderTargetId)
	v18.senderType = p3.senderType
	v18.read = p3.read
	v18.sent = DateTime.fromIsoDate(p3.sent)
	v18.conversationId = tostring(p4)
	v18.previousMessageId = p5
	v18.filteredForReceivers = false
	v18:parseContentWeb(p3)

	return v18
end
function t2.fromSentWeb(p6, p7) -- line: 81
	-- upvalues: t2 (copy), Players (copy), DateTime (copy)
	if not t2.DoRequiredFieldsPresentForSent(p6) then
		return nil
	end

	local v21 = t2.new()

	v21.id = p6.messageId
	v21.senderTargetId = tostring(Players.LocalPlayer.UserId)
	v21.senderType = "User"
	v21.read = true
	v21.sent = DateTime.fromIsoDate(p6.sent)
	v21.conversationId = tostring(p7)
	v21.previousMessageId = ""
	v21.filteredForReceivers = p6.filteredForReceivers
	v21:parseContentSentWeb(p6)

	return v21
end
function t2.newSendingId() -- line: 102
	-- upvalues: GenerateStringId (copy)
	return "sending-message-" .. GenerateStringId()
end
function t2.newSending(p8) -- line: 106
	-- upvalues: t2 (copy), Players (copy)
	assert(p8, "props argument is missing")
	assert(p8.id, "props.id argument is missing")
	assert(p8.messageType, "props.messageType argument is missing")
	assert(p8.order, "props.order argument is missing")
	assert(p8.conversationId, "props.conversationId argument is missing")
	assert(p8.sent, "props.sent argument is missing")

	local v23 = t2.new(p8)

	v23.senderTargetId = tostring(Players.LocalPlayer.UserId)
	v23.senderType = t2.SenderTypes.User
	v23.moderated = false
	v23.failed = false
	v23.stableKey = v23.id

	return v23
end
function t2.DoRequiredFieldsPresent(p9) -- line: 126
	return p9 and (p9.id and (p9.messageType and (p9.senderTargetId and p9.sent)))
end
function t2.DoRequiredFieldsPresentForSent(p10) -- line: 129
	return p10 and (p10.messageId and (p10.messageType and p10.sent))
end
function t2.parseContentWeb(p11, p12) -- line: 133
	-- upvalues: t2 (copy), t1 (copy)
	p11:parseContent(p12)

	if p12.messageType == t2.MessageTypes.Link and (p12.link and p12.link.type == t2.LinkTypes.Game and p12.link.game) then
		p11.gameLink = t1.new(p12.link.game.universeId)
	end
end
function t2.parseContentSentWeb(p13, p14) -- line: 142
	-- upvalues: t2 (copy), t1 (copy)
	p13:parseContent(p14)

	if p14.messageType == t2.MessageTypes.Link and p14.chatMessageLinkType == t2.LinkTypes.Game then
		p13.gameLink = t1.new(p14.universeId)
	end
end
function t2.parseContent(p15, p16) -- line: 151
	-- upvalues: t2 (copy)
	p15.messageType = p16.messageType

	if p16.messageType == t2.MessageTypes.PlainText then
		p15.content = p16.content

		return
	end

	p15.content = nil
end
function t2.fromChannelsApi(p17, p18, p19, _) -- line: 164
	-- upvalues: t2 (copy), DateTime (copy), GetFFlagEnableSocialCards (copy), FFlagAppChatEnableAutotranslation (copy)
	if not t2.DoRequiredFieldsPresentFromChannelsApi(p17) then
		return nil
	end

	local v36 = t2.new()

	v36.id = p17.id
	v36.read = true
	v36.sent = DateTime.fromIsoDate(p17.created_at)
	v36.conversationId = tostring(p18)
	v36.previousMessageId = p19
	v36.filteredForReceivers = false
	v36.content = p17.content
	v36.previewContent = p17.preview_content

	if p17.type == t2.SenderTypes.User then
		v36:serializeForUserMessage(p17)
	elseif p17.type == t2.SenderTypes.System then
		v36:serializeForSystemMessage(p17)
	end

	v36.cards = if not GetFFlagEnableSocialCards() then nil else p17.cards

	if GetFFlagEnableSocialCards() then
		v36.senderTargetId = tostring(p17.sender_user_id)
	end

	v36.stableKey = v36.id
	v36.isBadgeable = p17.is_badgeable
	v36.isPreviewable = p17.is_previewable

	if FFlagAppChatEnableAutotranslation then
		v36.contentToDisplay = p17.content_to_display
	end

	return v36
end
function t2.serializeForUserMessage(p21, p22) -- line: 201
	-- upvalues: t2 (copy), Logger (copy)
	p21.senderTargetId = tostring(p22.sender_user_id)
	p21.senderType = t2.SenderTypes.User
	p21.moderationType = p22.moderation_type
	p21.repliesTo = t2.fromChannelsApi(p22.replies_to, nil, nil, true)

	if p22.visibility and (p22.visibility == t2.VisibilityTypes.Visible or p22.visibility == t2.VisibilityTypes.Hidden) then
		p21.visibility = p22.visibility
	else
		p21.visibility = t2.VisibilityTypes.Invalid
		Logger:debug("Message visibility type is invalid for message id: " .. p21.id)
	end

	p21.messageType = t2.MessageTypes.PlainText
end
function t2.serializeForSystemMessage(p23, _) -- line: 219
	-- upvalues: t2 (copy)
	p23.senderType = t2.SenderTypes.System
	p23.messageType = t2.MessageTypes.System
end
function t2.DoRequiredFieldsPresentFromChannelsApi(p25) -- line: 225
	-- upvalues: t2 (copy)
	if not p25 then
		return false
	end

	if p25.type == t2.SenderTypes.User then
		return p25.id and (p25.sender_user_id and p25.created_at)
	end

	if p25.type == t2.SenderTypes.System then
		return p25.id and p25.created_at
	end

	return false
end
function t2.parseContentFromChannelsApi(p26, p27) -- line: 239
	-- upvalues: t2 (copy)
	p26.messageType = t2.MessageTypes.PlainText
	p26.content = p27.content
end
function t2.fromSentChannelsApi(p28, p29, p30) -- line: 245
	-- upvalues: t2 (copy), DateTime (copy), Logger (copy)
	if not t2.DoRequiredFieldsPresentForSentFromChannelsApi(p28) then
		return nil
	end

	local v47 = t2.new()

	v47.id = p28.messages[1].id
	v47.senderTargetId = tostring(p28.messages[1].sender_user_id)
	v47.senderType = t2.SenderTypes.User
	v47.read = true
	v47.sent = DateTime.fromIsoDate(p28.messages[1].created_at)
	v47.conversationId = tostring(p29)
	v47.previousMessageId = ""
	v47.moderationType = p28.messages[1].moderation_type
	v47.stableKey = p30 or v47.id
	v47.isBadgeable = p28.messages[1].is_badgeable
	v47.isPreviewable = p28.messages[1].is_previewable
	v47.filteredForReceivers = false
	v47.messageType = t2.MessageTypes.PlainText
	v47.content = p28.messages[1].content
	v47.repliesTo = t2.fromChannelsApi(p28.messages[1].replies_to, nil, nil, true)

	if p28.visibility and (p28.visibility == t2.VisibilityTypes.Visible or p28.visibility == t2.VisibilityTypes.Hidden) then
		v47.visibility = p28.visibility

		return v47
	end

	v47.visibility = t2.VisibilityTypes.Visible
	Logger:debug("Message visibility type is invalid for message id: " .. v47.id)

	return v47
end
function t2.DoRequiredFieldsPresentForSentFromChannelsApi(p31) -- line: 283
	return p31 and (p31.messages and (#p31.messages > 0 and (p31.messages[1].id and p31.messages[1].created_at)))
end

return t2
