local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local ExpChatShared = require(parent.ExpChatShared)
local SharedFlags = require(parent.SharedFlags)

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function requestSelectTab(p: string): boolean
	local store = ExpChatShared.context.store

	if store == nil then
		return false
	end

	if not FFlagExpChatUseChannelTabsStore then
		local channelTabs = store:getState().ChannelTabs
		return channelTabs ~= nil and channelTabs.allChannelTabs[p] ~= nil
	end

	local channelTabsStore = GetChannelTabsStore(false)

	if channelTabsStore.getChannelTabsState(false).allChannelTabs[p] == nil then
		return false
	end

	channelTabsStore.setTargetChannel(p, false)
	return true
end

return requestSelectTab
