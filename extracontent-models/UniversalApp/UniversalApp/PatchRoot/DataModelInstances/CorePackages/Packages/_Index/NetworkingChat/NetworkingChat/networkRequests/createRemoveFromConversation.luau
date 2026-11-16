local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST(
		{ Name = "RemoveFromConversation" },
		function(callback, participantUserId, conversationId)
			return callback(CHAT_URL):path("v2"):path("remove-from-conversation"):body({
				participantUserId = participantUserId,
				conversationId = conversationId
			}):setStatusIds({ conversationId })
		end
	)
end
