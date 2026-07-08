local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Config = require(ExpChat.Config)
local None = require(ExpChatParent.llama).None
local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChatInputBarSettingsChanged = require(Actions.ChatInputBarSettingsChanged)
local t1 = {
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

return Rodux.createReducer(t1, {
	[ConfigurationObjectsLoaded.name] = function(p1, p2) -- line: 28
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, p2.chatInputBarSettings)
	end,
	[ChatInputBarSettingsChanged.name] = function(p3, p4) -- line: 32
		-- upvalues: None (copy), Dictionary (copy)
		local _ = p4.value

		if p3[p4.property] == nil and p4.property ~= "TextBox" then
			return p3
		end

		local v16 = if p4.property ~= "TextBox" or p4.value ~= nil then p4.value else None

		return Dictionary.join(p3, {
			[p4.property] = v16
		})
	end
})
