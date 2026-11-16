local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "SendMessage" }, function(callback, message, conversationId, decorators)
		return callback(CHAT_URL):path("v2"):path("send-message"):body({
			message = message,
			conversationId = conversationId,
			decorators = decorators
		}):setStatusIds({ conversationId })
	end)
end
