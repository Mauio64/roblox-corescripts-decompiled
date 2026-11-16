local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "SetConversationUniverse" }, function(callback, conversationId, universeId)
		return callback(CHAT_URL):path("v2"):path("set-conversation-universe"):body({
			conversationId = conversationId,
			universeId = universeId
		}):setStatusIds({ conversationId })
	end)
end
