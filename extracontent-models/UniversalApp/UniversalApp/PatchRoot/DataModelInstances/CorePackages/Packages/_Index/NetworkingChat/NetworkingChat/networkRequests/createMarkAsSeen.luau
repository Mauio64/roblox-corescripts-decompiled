local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.POST({ Name = "MarkAsSeen" }, function(callback, conversationsToMarkSeen)
		return callback(CHAT_URL):path("v2"):path("mark-as-seen"):body({
			conversationsToMarkSeen = conversationsToMarkSeen
		}):setStatusIds(conversationsToMarkSeen)
	end)
end
