local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local Config = require(ExpChat.Config)
local llama2 = require(parent.llama)
local none = llama2.None

local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChatInputBarSettingsChanged = require(Actions.ChatInputBarSettingsChanged)

local v = {
	BackgroundTransparency = Config.ChatInputBarBackgroundTransparency,
	BackgroundColor3 = Config.ChatInputBarBackgroundColor,
	TextSize = Config.ChatInputBarTextSize,
	TextColor3 = Config.ChatInputBarTextColor3,
	SpatialPanelTextSize = Config.ChatInputBarSpatialPanelTextSize,
	TextStrokeColor3 = Config.ChatInputBarTextStrokeColor,
	TextStrokeTransparency = Config.ChatInputBarTextStrokeTransparency,
	FontFace = Config.ChatInputBarFontFace,
	PlaceholderColor3 = Config.ChatInputBarPlaceholderColor,
	KeyboardKeyCode = Config.ChatInputBarDefaultFocusKeyCode,
	AutocompleteEnabled = Config.ChatInputBarDefaultAutocompleteEnabled
}

return Rodux.createReducer(v, {
	[ConfigurationObjectsLoaded.name] = function(p, p2)
		return dictionary.join(p, p2.chatInputBarSettings)
	end,
	[ChatInputBarSettingsChanged.name] = function(p, p2)
		local _ = p2.value

		if p[p2.property] == nil and p2.property ~= "TextBox" then
			return p
		end

		local v2

		if p2.property == "TextBox" and p2.value == nil then
			v2 = none
		else
			v2 = p2.value
		end

		return dictionary.join(p, { [p2.property] = v2 })
	end
})
