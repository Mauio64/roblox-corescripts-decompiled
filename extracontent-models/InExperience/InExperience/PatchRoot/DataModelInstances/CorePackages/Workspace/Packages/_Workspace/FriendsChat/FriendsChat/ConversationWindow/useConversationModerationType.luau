local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ConversationChannels = require(parent.AppChat.ConversationChannels)
local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function toConversationModerationType(moderationType: string?) -- 1 equivalent call inferred from this helper
	if
		moderationType == ConversationChannels.ModerationType.TrustedComms
		or moderationType == ConversationChannels.ModerationType.Moderated
		or moderationType == ConversationChannels.ModerationType.Invalid
		or moderationType == ConversationChannels.ModerationType.UnknownType
	then
		return moderationType
	end

	return nil
end

local function useConversationModerationType(p)
	local conversationId = p.conversationId
	local hasConversationId = p.hasConversationId

	local conversationStore = ExpChatConversationListAdapter.getConversationStore()
	local v = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if not hasConversationId then
				return nil
			end

			local conversation = conversationStore.getConversation(conversationId, p2)

			if conversation == nil then
				return nil
			end

			return toConversationModerationType(conversation.moderationType) -- inferred equivalent call
		end)
	end, { conversationStore, conversationId, hasConversationId })

	return (SignalsReact.useSignalState(v))
end

return useConversationModerationType
