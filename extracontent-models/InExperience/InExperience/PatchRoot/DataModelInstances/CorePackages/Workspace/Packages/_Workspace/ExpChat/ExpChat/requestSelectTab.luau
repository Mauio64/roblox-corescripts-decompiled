local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local FriendsChatChannelSelected = ExpChatShared.Actions.FriendsChatChannelSelected
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function requestSelectTab(s1: string) -- line: 13
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), ExpChatShared (copy), FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), FriendsChatChannelSelected (copy)
	if not FFlagExpChatEnableFriendsTab then
		return false
	end

	local store = ExpChatShared.context.store

	if store == nil then
		return false
	end

	local ChannelTabs = store:getState().ChannelTabs

	if ChannelTabs == nil or ChannelTabs.allChannelTabs[s1] == nil then
		return false
	end

	local v13 = if not FFlagExpChatUseChannelTabsStore then nil else GetChannelTabsStore(false)

	if v13 and v13.getChannelTabsState(false).allChannelTabs[s1] == nil then
		return false
	end

	store:dispatch(FriendsChatChannelSelected(s1))

	if v13 then
		v13.setTargetChannel(s1, false)
	end

	return true
end

return requestSelectTab
