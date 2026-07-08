local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Config = require(ExpChat.Config)
local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChannelTabsSettingsChanged = require(Actions.ChannelTabsSettingsChanged)
local t1 = {
	BackgroundTransparency = Config.ChannelTabsSettings.BackgroundTransparency,
	BackgroundColor3 = Config.ChannelTabsSettings.BackgroundColor3,
	HoverBackgroundColor3 = Config.ChannelTabsSettings.HoverBackgroundColor3,
	FontFace = Config.ChannelTabsSettings.FontFace,
	TextSize = Config.ChannelTabsSettings.TextSize,
	TextColor3 = Config.ChannelTabsSettings.TextColor3,
	SelectedTabTextColor3 = Config.ChannelTabsSettings.SelectedTabTextColor3,
	TextStrokeColor3 = Config.ChannelTabsSettings.TextStrokeColor3,
	TextStrokeTransparency = Config.ChannelTabsSettings.TextStrokeTransparency
}

return Rodux.createReducer(t1, {
	[ConfigurationObjectsLoaded.name] = function(p1, p2) -- line: 25
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, p2.channelTabsSettings)
	end,
	[ChannelTabsSettingsChanged.name] = function(p3, p4) -- line: 29
		-- upvalues: Dictionary (copy)
		if not p3[p4.property] then
			return p3
		end

		return Dictionary.join(p3, {
			[p4.property] = p4.value
		})
	end
})
