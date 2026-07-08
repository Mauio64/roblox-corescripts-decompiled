local ParentParent = script.Parent.Parent

require(ParentParent.networkingChatTypes)

local CHAT_URL = require(ParentParent.CHAT_URL)

return function(p1) -- line: 6
	-- upvalues: CHAT_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetConversations"
	}, function(p2, p3) -- line: 9
		-- upvalues: CHAT_URL (copy)
		return p2(CHAT_URL):path("v2"):path("get-conversations"):expandedQueryArgsWithIds("conversationIds", p3)
	end)
end
