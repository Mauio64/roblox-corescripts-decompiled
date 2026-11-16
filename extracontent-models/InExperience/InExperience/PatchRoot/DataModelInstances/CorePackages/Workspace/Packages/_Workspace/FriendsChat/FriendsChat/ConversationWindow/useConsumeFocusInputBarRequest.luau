local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)
local isFocusRequestFresh = require(FriendsChat.Focus.isFocusRequestFresh)

local function useConsumeFocusInputBarRequest(callback)
	React.useEffect(function()
		local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)
		return Signals.createEffect(function(p)
			local focusInputBarRequestTime = friendsChatNavigationStore.getFocusInputBarRequestTime(p)

			if focusInputBarRequestTime == nil then
				return
			end

			if isFocusRequestFresh(focusInputBarRequestTime, os.clock(), 5) then
				callback()
			end

			friendsChatNavigationStore.clearFocusInputBarRequest()
		end)
	end, { callback })
end

return useConsumeFocusInputBarRequest
