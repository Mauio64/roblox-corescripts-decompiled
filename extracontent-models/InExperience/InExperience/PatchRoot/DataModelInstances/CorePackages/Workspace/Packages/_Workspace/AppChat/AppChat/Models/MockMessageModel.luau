local parent = script:FindFirstAncestor("AppChat").Parent

local Time = require(parent.Time)
local DateTime = Time.DateTime
local AppCommonLib = require(parent.AppCommonLib)
local GenerateStringId = AppCommonLib.GenerateStringId

local MessageModel = require(script.Parent.MessageModel)

local MockMessageModel = {
	mock = function(items)
		local result = MessageModel.new()

		result.id = GenerateStringId()
		result.senderTargetId = GenerateStringId()
		result.conversationId = GenerateStringId()
		result.senderType = MessageModel.SenderTypes.User
		result.content = "MESSAGE CONTENT"
		result.messageType = MessageModel.MessageTypes.PlainText

		result.read = false
		result.sent = DateTime.now()
		result.previousMessageId = nil
		result.filteredForReceivers = false

		if items ~= nil then
			for k, item in pairs(items) do
				result[k] = item
			end
		end

		return result
	end
}

setmetatable(MockMessageModel, { __index = MessageModel })

return MockMessageModel
