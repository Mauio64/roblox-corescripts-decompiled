local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

return function(p)
	if FFlagExpChatUseChannelTabsStore then
		return GetChannelTabsStore(false).getSelectedTabName(false)
	end

	return if p ~= nil then p.ChannelTabs.selectedTabName else nil
end
