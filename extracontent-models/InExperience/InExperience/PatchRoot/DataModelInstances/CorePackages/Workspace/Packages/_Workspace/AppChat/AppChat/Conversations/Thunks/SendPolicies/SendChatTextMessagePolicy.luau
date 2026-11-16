local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local MessageModel = require(AppChat.Models.MessageModel)
local SendChatMessagePolicy = require(script.Parent.SendChatMessagePolicy)

local object = setmetatable({}, SendChatMessagePolicy)
object.__index = object

function object:new(p, messageText, p2, decorators)
	local v2

	if p2 then
		v2 = p2.id
	end

	v:info("New policy constructed for conversationId: {} messageText: {}, replyingToId: {}", p, messageText, v2)

	local v3 = SendChatMessagePolicy:new(p, p2)
	setmetatable(v3, self)

	v3.messageText = messageText
	v3.decorators = decorators

	return v3
end

function object.sendMessage(data, _)
	local conversationId = data.conversationId
	local messageText = data.messageText
	local v2

	if data.replyingToMessage then
		v2 = data.replyingToMessage.id
	end

	v:info("sendMessage - conversationId: {} messageText: {}, replyingToId: {}", conversationId, messageText, v2)

	local sendChatTextMessage = AppChatNetworking.http.SendChatTextMessage

	local conversationId2 = data.conversationId
	local messageText2 = data.messageText
	local v3

	if data.replyingToMessage then
		v3 = data.replyingToMessage.id
	end

	return sendChatTextMessage(nil, conversationId2, messageText2, v3)
end

function object.sendingMessagePayload(p)
	return { messageType = MessageModel.MessageTypes.PlainText, content = p.messageText }
end

return object
