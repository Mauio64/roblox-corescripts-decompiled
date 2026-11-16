local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local ReloadedMessagesForConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReloadedMessagesForConversations")
local multiGetConversationDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/multiGetConversationDetails")

local function reloadMessagesForConversations(p2)
	return function(object)
		local conversations = object:getState().ChatAppReducer.Conversations
		local filtered = Cryo.List.filter(p2, function(p3): boolean
			local conversation = conversations[p3]

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
