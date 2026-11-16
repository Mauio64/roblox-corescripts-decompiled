local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Config = require(ExpChat.Config)

local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChannelTabsSettingsChanged = require(Actions.ChannelTabsSettingsChanged)

local v = {
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

return Rodux.createReducer(v, {
	[ConfigurationObjectsLoaded.name] = function(p, p2)
		return dictionary.join(p, p2.channelTabsSettings)
	end,
	[ChannelTabsSettingsChanged.name] = function(p, p2)
		if not p[p2.property] then
			return p
		end

		return dictionary.join(p, { [p2.property] = p2.value })
	end
})
