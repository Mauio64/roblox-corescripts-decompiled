local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local GetConversationListStore = require(AppChat.Stores.GetConversationListStore)
local t1 = {
	oldestConversationIsFetched = false,
	isFetchingConversations = false
}

local function useConversationList(b1: boolean?) -- line: 21
	-- upvalues: GetConversationListStore (copy), React (copy), Signals (copy), t1 (copy), SignalsReact (copy)
	local v10 = GetConversationListStore(false)
	local v11 = b1 ~= false
	local v12 = React.useMemo(function() -- line: 25
		-- upvalues: Signals (copy), v11 (copy), v10 (copy)
		return Signals.createComputed(function(p1) -- line: 26
			-- upvalues: v11 (copy), v10 (copy)
			if not v11 then
				return {}
			end

			return v10.getConversations(p1)
		end)
	end, {
		v10,
		v11
	})
	local v13 = React.useMemo(function() -- line: 35
		-- upvalues: Signals (copy), v11 (copy), t1 (copy), v10 (copy)
		return Signals.createComputed(function(p2) -- line: 36
			-- upvalues: v11 (copy), t1 (copy), v10 (copy)
			if not v11 then
				return t1
			end

			return v10.getListStatus(p2)
		end)
	end, {
		v10,
		v11
	})
	local v14 = SignalsReact.useSignalState(v12)
	local v15 = SignalsReact.useSignalState(v13)

	return {
		items = v14,
		listStatus = v15
	}
end

return useConversationList
