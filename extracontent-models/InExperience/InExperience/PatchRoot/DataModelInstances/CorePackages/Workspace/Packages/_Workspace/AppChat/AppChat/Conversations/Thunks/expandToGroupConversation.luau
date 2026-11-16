local parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(parent.AppChatNetworking)

local parseNewConversationResponse = require(script.Parent.Parent.parseNewConversationResponse)

return function(p: string, p2, p3)
	return function(object)
		return object:dispatch(AppChatNetworking.rodux.ExpandToGroupConversation.API(p, p2)):andThen(function(p4)
			return parseNewConversationResponse(p4.responseBody.new_conversation, p3, "userExpandedToGroupConversation")
		end)
	end
end
