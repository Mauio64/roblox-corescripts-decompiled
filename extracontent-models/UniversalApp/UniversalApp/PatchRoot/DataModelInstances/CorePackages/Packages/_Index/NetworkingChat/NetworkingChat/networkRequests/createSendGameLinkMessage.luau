local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST(
		{ Name = "SendGameLinkMessage" },
		function(callback, universeId, conversationId, decorators)
			return callback(CHAT_URL):path("v2"):path("send-game-link-message"):body({
				universeId = universeId,
				conversationId = conversationId,
				decorators = decorators
			}):setStatusIds({ conversationId })
		end
	)
end
