local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "ResetConversationUniverse" }, function(callback, conversationId)
		return callback(CHAT_URL):path("v2"):path("reset-conversation-universe"):body({
			conversationId = conversationId
		}):setStatusIds({ conversationId })
	end)
end
