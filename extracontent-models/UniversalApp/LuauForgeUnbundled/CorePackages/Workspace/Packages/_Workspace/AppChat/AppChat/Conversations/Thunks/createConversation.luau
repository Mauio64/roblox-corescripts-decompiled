local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local parseNewConversationResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/parseNewConversationResponse")

return function(p2, p3, p4, p5)
	return function(object)
		return object:dispatch(AppChatNetworking.rodux.CreateConversation.API(p2, p3)):andThen(function(p6)
			return parseNewConversationResponse(p6.responseBody.conversations and p6.responseBody.conversations[1], p4, p5)
		end)
	end
end
