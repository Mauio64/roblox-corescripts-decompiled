local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

require(AppChat.Models.ConversationChannels)

local parseNewConversationResponse = require(script.Parent.Parent.parseNewConversationResponse)

return function(p1, t1: {[any]: any}, p2, s1: string?) -- line: 16
	-- upvalues: AppChatNetworking (copy), parseNewConversationResponse (copy)
	return function(p3) -- line: 22
		-- upvalues: AppChatNetworking (copy), p1 (copy), t1 (copy), parseNewConversationResponse (copy), p2 (copy), s1 (copy)
		return p3:dispatch(AppChatNetworking.rodux.CreateConversation.API(p1, t1)):andThen(function(p4) -- line: 25
			-- upvalues: parseNewConversationResponse (copy), p2 (copy), s1 (copy)
			return parseNewConversationResponse(p4.responseBody.conversations and p4.responseBody.conversations[1], p2, s1)
		end)
	end
end
