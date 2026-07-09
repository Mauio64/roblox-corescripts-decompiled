local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Promise = require(AppChatParent.Promise)

require(AppChat.Models.ConversationChannels)

local ReloadedMessagesForConversations = require(AppChat.Conversations.Actions.ReloadedMessagesForConversations)
local multiGetConversationDetails = require(AppChat.Conversations.Thunks.multiGetConversationDetails)

local function reloadMessagesForConversations(t1: {[any]: any}) -- line: 10
	-- upvalues: Cryo (copy), Promise (copy), ReloadedMessagesForConversations (copy), multiGetConversationDetails (copy)
	return function(p1) -- line: 11
		-- upvalues: Cryo (copy), t1 (copy), Promise (copy), ReloadedMessagesForConversations (copy), multiGetConversationDetails (copy)
		local Conversations = p1:getState().ChatAppReducer.Conversations
		local v11 = Cryo.List.filter(t1, function(p2) -- line: 15
			-- upvalues: Conversations (copy)
			local v13 = Conversations[p2]

			if v13 and v13.source == "channels" then
				return true
			end

			return false
		end)

		if #v11 == 0 then
			return Promise.resolve()
		end

		p1:dispatch(ReloadedMessagesForConversations(v11))

		return p1:dispatch(multiGetConversationDetails(v11))
	end
end

return reloadMessagesForConversations
