local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local ChatConversationTelemetryLayer = require(parent.AppChat.ChatConversationTelemetryLayer)

local ExpChatConversationListAdapter = require(script.Parent.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function FriendsChatConversationTelemetryProviders(p)
	local conversationId = p.conversationId

	local v = React.useCallback(function()
		local moderationType = nil
		local userPendingStatus = nil

		if conversationId ~= nil and conversationId ~= "" then
			local conversation = ExpChatConversationListAdapter.getConversationStore().getConversation(
				conversationId,
				false
			)

			if conversation ~= nil then
				moderationType = conversation.moderationType
				userPendingStatus = conversation.userPendingStatus
			end
		end

		return {
			conversationId = conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		}
	end, { conversationId })

	return React.createElement(ChatConversationTelemetryLayer.Provider, { value = v }, p.children)
end

return FriendsChatConversationTelemetryProviders
