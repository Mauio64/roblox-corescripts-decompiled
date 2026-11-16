local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)
local isFocusRequestFresh = require(FriendsChat.Focus.isFocusRequestFresh)

local function useConsumeFocusConversationListRequest(callback, callback2)
	React.useEffect(function()
		local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)
		return Signals.createEffect(function(p)
			local conversationListFocusRequestTime = friendsChatNavigationStore.getConversationListFocusRequestTime(p)

			if conversationListFocusRequestTime == nil then
				return
			end

			if not isFocusRequestFresh(conversationListFocusRequestTime, os.clock(), 5) then
				friendsChatNavigationStore.clearConversationListFocusRequest()
				return
			end

			local v = callback(p)

			if v == nil then
				return
			end

			callback2(v)
			friendsChatNavigationStore.clearConversationListFocusRequest()
		end)
	end, { callback, callback2 })
end

return useConsumeFocusConversationListRequest
