local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "RenameGroupConversation" }, function(callback, conversationId, newTitle)
		return callback(CHAT_URL):path("v2"):path("rename-group-conversation"):body({
			conversationId = conversationId,
			newTitle = newTitle
		}):setStatusIds({ conversationId })
	end)
end
