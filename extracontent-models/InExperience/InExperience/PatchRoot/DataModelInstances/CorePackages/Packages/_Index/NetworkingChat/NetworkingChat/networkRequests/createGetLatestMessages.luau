local parent = script.Parent.Parent
require(parent.networkingChatTypes)
local CHAT_URL = require(parent.CHAT_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetLatestMessages" }, function(callback, p2, pageSize)
		return callback(CHAT_URL):path("v2"):path("multi-get-latest-messages"):queryArgs({
			pageSize = pageSize
		}):expandedQueryArgsWithIds(
			"conversationIds",
			p2
		)
	end)
end
