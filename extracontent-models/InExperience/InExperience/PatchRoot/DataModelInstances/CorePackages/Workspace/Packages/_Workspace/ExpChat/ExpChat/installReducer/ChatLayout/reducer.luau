local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local getFFlagExpChatEnableChannelTabsUI = require(ExpChat.Flags.getFFlagExpChatEnableChannelTabsUI)

return Rodux.combineReducers({
	Alignment = require(script.Parent.alignment),
	ChatWindowSettings = require(script.Parent.windowSettings),
	ChatInputBarSettings = require(script.Parent.inputBarSettings),
	ChannelTabsSettings = getFFlagExpChatEnableChannelTabsUI() and require(script.Parent.channelTabsSettings) or nil
})
