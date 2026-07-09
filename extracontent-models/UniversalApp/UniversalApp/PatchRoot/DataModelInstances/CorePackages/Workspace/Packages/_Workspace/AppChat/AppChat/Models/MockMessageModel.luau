local Parent = script:FindFirstAncestor("AppChat").Parent
local DateTime = require(Parent.Time).DateTime
local GenerateStringId = require(Parent.AppCommonLib).GenerateStringId
local MessageModel = require(script.Parent.MessageModel)
local t1 = {
	mock = function(p1) -- line: 11
		-- upvalues: MessageModel (copy), GenerateStringId (copy), DateTime (copy)
		local v7 = MessageModel.new()

		v7.id = GenerateStringId()
		v7.senderTargetId = GenerateStringId()
		v7.conversationId = GenerateStringId()
		v7.senderType = MessageModel.SenderTypes.User
		v7.content = "MESSAGE CONTENT"
		v7.messageType = MessageModel.MessageTypes.PlainText
		v7.read = false
		v7.sent = DateTime.now()
		v7.previousMessageId = nil
		v7.filteredForReceivers = false

		if p1 ~= nil then
			for k, v in pairs(p1) do
				v7[k] = v
			end
		end

		return v7
	end
}

setmetatable(t1, {
	__index = MessageModel
})

return t1
