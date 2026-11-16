local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GetConversationListStore = require(AppChat.Stores.GetConversationListStore)

local v = { oldestConversationIsFetched = false, isFetchingConversations = false }

local function useConversationList(flag: boolean?)
	local conversationListStore = GetConversationListStore(false)
	local v2 = flag ~= false
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v2 then
				return conversationListStore.getConversations(p)
			end

			return {}
		end)
	end, { conversationListStore, v2 })

	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if v2 then
				return conversationListStore.getListStatus(p)
			end

			return v
		end)
	end, { conversationListStore, v2 })

	return {
		items = SignalsReact.useSignalState(v3),
		listStatus = SignalsReact.useSignalState(v4)
	}
end

return useConversationList
