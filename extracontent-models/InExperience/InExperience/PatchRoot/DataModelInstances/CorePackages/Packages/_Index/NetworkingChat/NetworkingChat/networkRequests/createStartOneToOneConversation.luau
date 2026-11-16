local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "StartOneToOneConversation" }, function(callback, participantUserId)
		return callback(CHAT_URL):path("v2"):path("start-one-to-one-conversation"):body({
			participantUserId = participantUserId
		}):setStatusIds({ participantUserId })
	end)
end
