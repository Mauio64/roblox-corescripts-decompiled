local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ChatConversationTelemetryLayer = require(Parent.AppChat.ChatConversationTelemetryLayer)
local ExpChatConversationListAdapter = require(script.Parent.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function FriendsChatConversationTelemetryProviders(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), ExpChatConversationListAdapter (copy), ChatConversationTelemetryLayer (copy)
	local conversationId = t1.conversationId
	local v8 = React.useCallback(function() -- line: 30
		-- upvalues: conversationId (copy), ExpChatConversationListAdapter (copy)
		local moderationType = nil
		local userPendingStatus = nil

		if conversationId ~= nil and conversationId ~= "" then
			local v11 = ExpChatConversationListAdapter.getConversationStore().getConversation(conversationId, false)

			if v11 ~= nil then
				moderationType = v11.moderationType
				userPendingStatus = v11.userPendingStatus
			end
		end

		return {
			conversationId = conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		}
	end, { conversationId })

	return React.createElement(ChatConversationTelemetryLayer.Provider, {
		value = v8
	}, t1.children)
end

return FriendsChatConversationTelemetryProviders
