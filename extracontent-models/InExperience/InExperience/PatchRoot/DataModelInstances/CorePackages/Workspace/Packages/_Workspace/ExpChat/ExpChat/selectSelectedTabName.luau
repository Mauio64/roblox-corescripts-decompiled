local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local FFlagExpChatUseChannelTabsStore = require(ExpChatParent.SharedFlags).FFlagExpChatUseChannelTabsStore
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)

return function(p1) -- line: 13
	-- upvalues: FFlagExpChatUseChannelTabsStore (copy), GetChannelTabsStore (copy), getFFlagExpChatEnableChannelTabsUI (copy)
	if FFlagExpChatUseChannelTabsStore then
		return GetChannelTabsStore(false).getSelectedTabName(false)
	end

	if getFFlagExpChatEnableChannelTabsUI() and p1 ~= nil then
		return p1.ChannelTabs.selectedTabName
	end

	return nil
end
