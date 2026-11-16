local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime
local generateStringId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib").GenerateStringId

local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")

local v5 = {
	mock = function(items)
		local result = MessageModel.new()

		result.id = generateStringId()
		result.senderTargetId = generateStringId()
		result.conversationId = generateStringId()
		result.senderType = MessageModel.SenderTypes.User
		result.content = "MESSAGE CONTENT"
		result.messageType = MessageModel.MessageTypes.PlainText

		result.read = false
		result.sent = dateTime.now()
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

setmetatable(v5, { __index = MessageModel })

return v5
