local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local ExpChatConversationListAdapter = require(script.Parent.Parent.ConversationList.ExpChatConversationListAdapter)

local function useNavigateBackOnConversationRemoval(p)
	local conversationId = p.conversationId
	local onBack = p.onBack

	local conversationStore = ExpChatConversationListAdapter.getConversationStore()
	local v = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return conversationStore.getConversation(conversationId, p2) ~= nil
		end)
	end, { conversationStore, conversationId })
	local v2 = SignalsReact.useSignalState(v)

	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = false
	end, { conversationId })
	React.useEffect(function()
		if v2 then
			ref.current = true
		elseif ref.current and onBack then
			ref.current = false
			onBack()
		end
	end, { v2, onBack })
end

return useNavigateBackOnConversationRemoval
