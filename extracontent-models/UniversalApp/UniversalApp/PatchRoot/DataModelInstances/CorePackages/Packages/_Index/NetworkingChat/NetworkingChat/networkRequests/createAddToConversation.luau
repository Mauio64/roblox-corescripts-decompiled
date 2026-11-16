local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "AddToConversation" }, function(callback, participantUserIds, conversationId)
		return callback(CHAT_URL):path("v2"):path("add-to-conversation"):body({
			participantUserIds = participantUserIds,
			conversationId = conversationId
		}):setStatusIds({ conversationId })
	end)
end
