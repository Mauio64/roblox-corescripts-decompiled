local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local LAYOUT_ORDER = require(Settings.Integrations.Constants).GAMESETTINGS.LAYOUT_ORDER

local function UINavValue() -- line: 23
	-- upvalues: ValueChangedSignal (copy), GameSettings (copy)
	local v15 = ValueChangedSignal.new(GameSettings.UiNavigationKeyBindEnabled)

	v15:connect(function(p1) -- line: 26
		-- upvalues: GameSettings (copy)
		if p1 == GameSettings.UiNavigationKeyBindEnabled then
			return
		end

		GameSettings.UiNavigationKeyBindEnabled = p1
	end)

	return v15
end
local function UINavAvailability() -- line: 39
	-- upvalues: AvailabilitySignal (copy), UserInputService (copy)
	local v16 = AvailabilitySignal.new(UserInputService.KeyboardEnabled)

	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 42
		-- upvalues: v16 (copy), UserInputService (copy)
		v16:set(UserInputService.KeyboardEnabled)
	end)

	return v16
end

local t1 = {
	id = "ui-nav-toggle",
	label = "CoreScripts.InGameMenu.GameSettings.UINavToggle",
	description = "CoreScripts.InGameMenu.GameSettings.UINavToggleDescription",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle
}
local v13 = ValueChangedSignal.new(GameSettings.UiNavigationKeyBindEnabled)

v13:connect(function(p2) -- line: 26
	-- upvalues: GameSettings (copy)
	if p2 == GameSettings.UiNavigationKeyBindEnabled then
		return
	end

	GameSettings.UiNavigationKeyBindEnabled = p2
end)
t1.onChanged = v13

local v14 = AvailabilitySignal.new(UserInputService.KeyboardEnabled)

UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 42
	-- upvalues: v14 (copy), UserInputService (copy)
	v14:set(UserInputService.KeyboardEnabled)
end)
t1.availability = v14
t1.layoutOrder = LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame

return t1
