local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

return function(object): boolean
	if FFlagExpChatUseChannelTabsStore then
		return GetChannelTabsStore(false).getChannelTabsState(false).hasUserSelectedTab == true
	end

	local channelTabs = object:getState().ChannelTabs
	return channelTabs ~= nil and channelTabs.hasUserSelectedTab == true
end
