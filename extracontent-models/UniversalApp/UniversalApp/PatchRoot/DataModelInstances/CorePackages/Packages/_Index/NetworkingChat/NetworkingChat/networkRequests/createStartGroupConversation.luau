local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "StartGroupConversation" }, function(callback, participantUserIds, title)
		return callback(CHAT_URL):path("v2"):path("start-group-conversation"):body({
			participantUserIds = participantUserIds,
			title = title
		}):setStatusIds(participantUserIds)
	end)
end
