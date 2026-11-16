local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetUserConversations" }, function(callback, pageNumber, pageSize)
		return callback(CHAT_URL):path("v2"):path("get-user-conversations"):queryArgs({
			pageNumber = pageNumber,
			pageSize = pageSize
		}):setStatusIds({ pageNumber })
	end)
end
