local parent = script:FindFirstAncestor("FriendsChat").Parent

local Signals = require(parent.Signals)
local Conversation = require(parent.AppChat.Conversation)
local GetConversationStore = require(parent.AppChat.GetConversationStore)

local function createGetIsGroup(p: string?)
	return Signals.createComputed(function(p2): boolean
		if p == nil then
			return false
		end

		local conversation = GetConversationStore(p2).getConversation(p, p2)
		return conversation ~= nil and conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)
end

return createGetIsGroup
