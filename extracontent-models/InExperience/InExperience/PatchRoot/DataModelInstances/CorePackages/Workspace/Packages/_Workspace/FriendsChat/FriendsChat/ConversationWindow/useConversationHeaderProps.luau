local parent = script:FindFirstAncestor("FriendsChat").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)
local getFriendsChatHeaderProps = require(script.Parent.Parent.HeaderBar.getFriendsChatHeaderProps)

local function areSelectedHeaderFieldsEqual(data, data2)
	if data == data2 then
		return true
	end

	if data == nil or data2 == nil then
		return false
	end

	return data.title == data2.title
		and data.titleForViewer == data2.titleForViewer
		and Cryo.List.equals(data.participants or {}, data2.participants or {})
end

local function useConversationHeaderProps(data)
	local conversationId = data.conversationId
	local hasConversationId = data.hasConversationId
	local localUserId = data.localUserId

	local conversationStore = ExpChatConversationListAdapter.getConversationStore()
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			if not hasConversationId then
				return nil
			end

			local conversation = conversationStore.getConversation(conversationId, p)

			if conversation == nil then
				return nil
			end

			return {
				title = conversation.title,
				titleForViewer = conversation.titleForViewer,
				participants = conversation.participants
			}
		end, areSelectedHeaderFieldsEqual)
	end, { conversationStore, conversationId, hasConversationId })
	local v2 = SignalsReact.useSignalState(v)

	return React.useMemo(function()
		if v2 == nil then
			return nil
		end

		return getFriendsChatHeaderProps(v2, localUserId)
	end, { v2, localUserId })
end

return useConversationHeaderProps
