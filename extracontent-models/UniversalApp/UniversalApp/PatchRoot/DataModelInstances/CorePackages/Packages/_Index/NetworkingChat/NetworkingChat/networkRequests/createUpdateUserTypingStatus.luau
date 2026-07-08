local ParentParent = script.Parent.Parent

require(ParentParent.networkingChatTypes)

local CHAT_URL = require(ParentParent.CHAT_URL)

return function(p1) -- line: 6
	-- upvalues: CHAT_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "UpdateUserTypingStatus"
	}, function(p2, p3, p4) -- line: 9
		-- upvalues: CHAT_URL (copy)
		return p2(CHAT_URL):path("v2"):path("update-user-typing-status"):body({
			conversationId = p3,
			isTyping = p4
		}):setStatusIds({ p3 })
	end)
end
