local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local parseNewConversationResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/parseNewConversationResponse")

return function(p2, p3, p4)
	return function(object)
		return object:dispatch(AppChatNetworking.rodux.ExpandToGroupConversation.API(p2, p3)):andThen(function(p5)
			return parseNewConversationResponse(p5.responseBody.new_conversation, p4, "userExpandedToGroupConversation")
		end)
	end
end
