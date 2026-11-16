local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.GET(
		{ Name = "GetMessages" },
		function(callback, conversationId, pageSize, exclusiveStartMessageId)
			return callback(CHAT_URL):path("v2"):path("get-messages"):queryArgs({
				conversationId = conversationId,
				pageSize = pageSize,
				exclusiveStartMessageId = exclusiveStartMessageId
			}):setStatusIds({ conversationId })
		end
	)
end
