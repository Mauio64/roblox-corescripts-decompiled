local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "UpdateUserTypingStatus" }, function(callback, conversationId, isTyping)
		return callback(CHAT_URL):path("v2"):path("update-user-typing-status"):body({
			conversationId = conversationId,
			isTyping = isTyping
		}):setStatusIds({ conversationId })
	end)
end
