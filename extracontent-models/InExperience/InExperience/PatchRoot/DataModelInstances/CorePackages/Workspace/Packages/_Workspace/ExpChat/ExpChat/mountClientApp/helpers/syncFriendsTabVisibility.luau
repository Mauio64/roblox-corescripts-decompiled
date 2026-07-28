local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Signals = require(ExpChatParent.Signals)
local SharedFlags = require(ExpChatParent.SharedFlags)
local FriendsChatChannelAdded = require(ExpChat.Actions.FriendsChatChannelAdded)
local FriendsChatChannelRemoved = require(ExpChat.Actions.FriendsChatChannelRemoved)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetFriendsTabVisibilityStore = require(ExpChatParent.FriendsChat.GetFriendsTabVisibilityStore)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function syncFriendsTabVisibility(p1) -- line: 16
	-- upvalues: GetFriendsTabVisibilityStore (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), Signals (copy), FriendsChatChannelAdded (copy), FriendsChatChannelRemoved (copy)
	local v12 = GetFriendsTabVisibilityStore(false)
	local v13 = if not FFlagExpChatUseChannelTabsStore then nil else GetChannelTabsStore(false)

	return Signals.createEffect(function(p2) -- line: 20
		-- upvalues: v12 (copy), p1 (copy), FriendsChatChannelAdded (copy), v13 (copy), FriendsChatChannelRemoved (copy)
		if v12.getIsFriendsTabVisible(p2) then
			p1:dispatch(FriendsChatChannelAdded("FriendsChat"))

			if v13 then
				v13.addChannelTab({
					type = "FriendsChat",
					name = "FriendsChat"
				}, nil)

				return
			end
		else
			p1:dispatch(FriendsChatChannelRemoved("FriendsChat"))

			if v13 then
				v13.handleChannelRemoved("FriendsChat")
			end
		end
	end)
end

return syncFriendsTabVisibility
