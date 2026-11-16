local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)
require(AppChat.Models.ConversationChannels)
local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)

local function reloadMessagesForConversations(p)
	return function(object)
		local conversations = object:getState().ChatAppReducer.Conversations
		local filtered = Cryo.List.filter(p, function(p2): boolean
			local conversation = conversations[p2]

			if conversation and conversation.source == "channels" then
				return true
			end

			return false
		end)

		if #filtered == 0 then
			return Promise.resolve()
		end

		object:dispatch(ReloadedMessagesForConversations(filtered))
		return object:dispatch(multiGetConversationDetails(filtered))
	end
end

return reloadMessagesForConversations
