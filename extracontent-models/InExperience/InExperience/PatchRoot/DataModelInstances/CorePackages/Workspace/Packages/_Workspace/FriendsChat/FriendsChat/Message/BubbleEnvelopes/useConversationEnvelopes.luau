local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local GetConversationMessageListStore = require(parent.AppChat.GetConversationMessageListStore)

local FIntFriendsChatBubbleMaxMessages = require(script.Parent.Parent.Parent.Flags.FIntFriendsChatBubbleMaxMessages)
local createGetIsGroup = require(script.Parent.Parent.MessageDisplayStore.createGetIsGroup)
local useLocalize = require(script.Parent.Parent.Parent.Utils.useLocalize)
local createConversationEnvelopes = require(script.Parent.createConversationEnvelopes)

local function useConversationEnvelopes(p)
	local conversationId = p.conversationId
	local shouldReadMessages = p.shouldReadMessages
	local localize = useLocalize()

	return React.useMemo(function()
		local function getMessageIds(p2)
			if shouldReadMessages then
				return GetConversationMessageListStore(p2).getOrderedIds(conversationId, p2)
			end

			return {}
		end

		return createConversationEnvelopes.create(getMessageIds, {
			localize = localize,
			maxMessages = FIntFriendsChatBubbleMaxMessages,
			getIsGroup = createGetIsGroup(conversationId)
		})
	end, { conversationId, shouldReadMessages, localize })
end

return useConversationEnvelopes
