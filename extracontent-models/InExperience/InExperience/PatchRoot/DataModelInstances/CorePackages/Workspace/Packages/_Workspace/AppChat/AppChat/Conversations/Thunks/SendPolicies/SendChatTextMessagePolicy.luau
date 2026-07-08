local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local v4 = require(AppChat.Logger):new(script.Name)
local MessageModel = require(AppChat.Models.MessageModel)
local SendChatMessagePolicy = require(script.Parent.SendChatMessagePolicy)
local self = setmetatable({}, SendChatMessagePolicy)

self.__index = self

function self.new(p1, p2, p3, p4, p5) -- line: 13
	-- upvalues: v4 (copy), SendChatMessagePolicy (copy)
	v4:info("New policy constructed for conversationId: {} messageText: {}, replyingToId: {}", p2, p3, if not p4 then nil else p4.id)

	local v13 = SendChatMessagePolicy:new(p2, p4)

	setmetatable(v13, p1)
	v13.messageText = p3
	v13.decorators = p5

	return v13
end
function self.sendMessage(p6, _) -- line: 31
	-- upvalues: v4 (copy), AppChatNetworking (copy)
	v4:info("sendMessage - conversationId: {} messageText: {}, replyingToId: {}", p6.conversationId, p6.messageText, if not p6.replyingToMessage then nil else p6.replyingToMessage.id)

	return AppChatNetworking.http.SendChatTextMessage(nil, p6.conversationId, p6.messageText, if not p6.replyingToMessage then nil else p6.replyingToMessage.id)
end
function self.sendingMessagePayload(p8) -- line: 47
	-- upvalues: MessageModel (copy)
	return {
		messageType = MessageModel.MessageTypes.PlainText,
		content = p8.messageText
	}
end

return self
