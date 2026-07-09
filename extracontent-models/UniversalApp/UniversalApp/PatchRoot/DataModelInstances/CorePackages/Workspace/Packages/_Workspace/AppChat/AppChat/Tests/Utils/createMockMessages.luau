local AppChat = script:FindFirstAncestor("AppChat")
local EnumMessageTypes = require(AppChat.Components.ChatConversation.EnumMessageTypes)
local MessageModel = require(AppChat.Models.MessageModel)

return function(t1: {[any]: any}, p1) -- line: 22
	-- upvalues: EnumMessageTypes (copy), MessageModel (copy)
	local t2 = {}

	for i = 1, p1 do
		local v8 = t1.messageIdPrefix .. tostring(i)

		table.insert(t2, {
			messageId = v8,
			content = t1.content or "Message " .. v8,
			isIncoming = t1.isIncoming or false,
			messageType = t1.type or EnumMessageTypes.PlainText,
			sender = i == p1 and t1.sender or {},
			gameLink = t1.gameLink or nil,
			sent = t1.sent or nil,
			read = t1.read or nil,
			senderType = t1.senderType or MessageModel.SenderTypes.User
		})
	end

	return t2
end
