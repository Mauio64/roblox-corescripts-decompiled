local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)

local FriendsChatChannelAdded = require(ExpChat.Actions.FriendsChatChannelAdded)
local FriendsChatChannelRemoved = require(ExpChat.Actions.FriendsChatChannelRemoved)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetFriendsTabVisibilityStore = require(parent.FriendsChat.GetFriendsTabVisibilityStore)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)

local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function syncFriendsTabVisibility(object)
	local friendsTabVisibilityStore = GetFriendsTabVisibilityStore(false)
	local v

	if FFlagExpChatUseChannelTabsStore then
		v = GetChannelTabsStore(false)
	else
		v = nil
	end

	return Signals.createEffect(function(p)
		if friendsTabVisibilityStore.getIsFriendsTabVisible(p) then
			if v then
				v.addChannelTab({ type = "FriendsChat", name = FriendsChatTabName }, nil)
			else
				object:dispatch(FriendsChatChannelAdded(FriendsChatTabName))
			end
		elseif v then
			v.handleChannelRemoved(FriendsChatTabName)
		else
			object:dispatch(FriendsChatChannelRemoved(FriendsChatTabName))
		end
	end)
end

return syncFriendsTabVisibility
