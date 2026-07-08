local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local Config = require(ExpChat.Config)
local Actions = ExpChat.Actions
local ConfigurationObjectsLoaded = require(Actions.ConfigurationObjectsLoaded)
local ChatWindowSettingsChanged = require(Actions.ChatWindowSettingsChanged)
local t1 = {
	HeightScale = 1,
	WidthScale = 1,
	Font = Config.ChatWindowFont,
	TextColor3 = Config.ChatWindowTextColor3,
	TextSize = Config.ChatWindowTextSize,
	TextStrokeColor3 = Config.ChatWindowTextStrokeColor,
	TextStrokeTransparency = Config.ChatWindowTextStrokeTransparency,
	BackgroundColor3 = Config.ChatWindowBackgroundColor3,
	BackgroundTransparency = Config.ChatWindowBackgroundTransparency,
	SpatialPanelTextSize = Config.ChatWindowSpatialPanelTextSize
}

return Rodux.createReducer(t1, {
	[ConfigurationObjectsLoaded.name] = function(p1, p2) -- line: 26
		-- upvalues: Dictionary (copy)
		return Dictionary.join(p1, p2.chatWindowSettings)
	end,
	[ChatWindowSettingsChanged.name] = function(p3, p4) -- line: 30
		-- upvalues: Dictionary (copy)
		if not p3[p4.property] then
			return p3
		end

		return Dictionary.join(p3, {
			[p4.property] = p4.value
		})
	end
})
