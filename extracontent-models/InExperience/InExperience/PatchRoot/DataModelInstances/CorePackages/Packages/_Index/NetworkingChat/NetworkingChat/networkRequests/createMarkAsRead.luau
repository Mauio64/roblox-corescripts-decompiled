local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "MarkAsRead" }, function(callback, conversationId, endMessageId)
		return callback(CHAT_URL):path("v2"):path("mark-as-read"):body({
			conversationId = conversationId,
			endMessageId = endMessageId
		}):setStatusIds({ conversationId })
	end)
end
