local Parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(Parent.AppChatNetworking)
local parseNewConversationResponse = require(script.Parent.Parent.parseNewConversationResponse)

return function(s1: string, t1: {[any]: any}, p1) -- line: 7
	-- upvalues: AppChatNetworking (copy), parseNewConversationResponse (copy)
	return function(p2) -- line: 8
		-- upvalues: AppChatNetworking (copy), s1 (copy), t1 (copy), parseNewConversationResponse (copy), p1 (copy)
		return p2:dispatch(AppChatNetworking.rodux.ExpandToGroupConversation.API(s1, t1)):andThen(function(p3) -- line: 11
			-- upvalues: parseNewConversationResponse (copy), p1 (copy)
			return parseNewConversationResponse(p3.responseBody.new_conversation, p1, "userExpandedToGroupConversation")
		end)
	end
end
