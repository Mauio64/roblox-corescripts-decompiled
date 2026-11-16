local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Config = require(ExpChat.Config)

local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChatWindowSettingsChanged = require(Actions.ChatWindowSettingsChanged)

local v = {
	Font = Config.ChatWindowFont,
	TextColor3 = Config.ChatWindowTextColor3,
	TextSize = Config.ChatWindowTextSize,
	TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
	TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
	BackgroundColor3 = Config.ChatWindowBackgroundColor3,
	BackgroundTransparency = Config.ChatWindowBackgroundTransparency,
	HeightScale = 1,
	WidthScale = 1,
	SpatialPanelTextSize = Config.ChatWindowSpatialPanelTextSize
}

return Rodux.createReducer(v, {
	[ConfigurationObjectsLoaded.name] = function(p, p2)
		return dictionary.join(p, p2.chatWindowSettings)
	end,
	[ChatWindowSettingsChanged.name] = function(p, p2)
		if not p[p2.property] then
			return p
		end

		return dictionary.join(p, { [p2.property] = p2.value })
	end
})
