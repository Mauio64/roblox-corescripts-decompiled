local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("SendChatTextMessagePolicy")

local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")
local SendChatMessagePolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/SendPolicies/SendChatMessagePolicy")

local object = setmetatable({}, SendChatMessagePolicy)
object.__index = object

function object.new(p2, p3, messageText, p4, decorators)
	local v8 = if p4 then p4.id else nil
	v5:info(
		"New policy constructed for conversationId: {} messageText: {}, replyingToId: {}",
		p3,
		messageText,
		v8
	)

	local v9 = SendChatMessagePolicy:new(p3, p4)
	setmetatable(v9, p2)

	v9.messageText = messageText
	v9.decorators = decorators

	return v9
end

function object.sendMessage(data, p2)
	local conversationId = data.conversationId
	local messageText = data.messageText
	local v8 = if data.replyingToMessage then data.replyingToMessage.id else nil
	v5:info(
		"sendMessage - conversationId: {} messageText: {}, replyingToId: {}",
		conversationId,
		messageText,
		v8
	)

	local sendChatTextMessage = AppChatNetworking.http.SendChatTextMessage

	local conversationId2 = data.conversationId
	local messageText2 = data.messageText
	local v10 = if data.replyingToMessage then data.replyingToMessage.id else nil
	return sendChatTextMessage(nil, conversationId2, messageText2, v10)
end

function object:sendingMessagePayload()
	return { messageType = MessageModel.MessageTypes.PlainText, content = self.messageText }
end

return object
