local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local AppChatNetworking = require(parent.AppChatNetworking)

require(AppChat.Models.ConversationChannels)

local parseNewConversationResponse = require(script.Parent.Parent.parseNewConversationResponse)

return function(p, p2, p3, p4: string?)
	return function(object)
		return object:dispatch(AppChatNetworking.rodux.CreateConversation.API(p, p2)):andThen(function(p5)
			return parseNewConversationResponse(
				p5.responseBody.conversations and p5.responseBody.conversations[1],
				p3,
				p4
			)
		end)
	end
end
