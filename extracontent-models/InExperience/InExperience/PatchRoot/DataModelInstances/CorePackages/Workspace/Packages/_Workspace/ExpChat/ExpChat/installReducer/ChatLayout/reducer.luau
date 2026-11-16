local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.combineReducers({
	Alignment = require(script.Parent.alignment),
	ChatWindowSettings = require(script.Parent.windowSettings),
	ChatInputBarSettings = require(script.Parent.inputBarSettings),
	ChannelTabsSettings = require(script.Parent.channelTabsSettings)
})
