local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local gameSettings = UserSettings().GameSettings

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function UINavValue()
	local v = ValueChangedSignal.new(gameSettings.UiNavigationKeyBindEnabled)

	v:connect(function(uiNavigationKeyBindEnabled)
		if gameSettings.UiNavigationKeyBindEnabled == uiNavigationKeyBindEnabled then
			return
		end

		gameSettings.UiNavigationKeyBindEnabled = uiNavigationKeyBindEnabled
	end)

	return v
end

local function UINavAvailability() -- 1 equivalent call inferred from this helper
	local v = AvailabilitySignal.new(UserInputService.KeyboardEnabled)

	UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
		v:set(UserInputService.KeyboardEnabled)
	end)

	return v
end

local UINavToggle = {
	id = "ui-nav-toggle",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.UINavToggle",
	description = "CoreScripts.InGameMenu.GameSettings.UINavToggleDescription",
	alreadyLocalized = false,
	onChanged = 0,
	availability = 0,
	layoutOrder = 0
}
local onChanged = ValueChangedSignal.new(gameSettings.UiNavigationKeyBindEnabled)

onChanged:connect(function(uiNavigationKeyBindEnabled)
	if gameSettings.UiNavigationKeyBindEnabled == uiNavigationKeyBindEnabled then
		return
	end

	gameSettings.UiNavigationKeyBindEnabled = uiNavigationKeyBindEnabled
end)

UINavToggle.onChanged = onChanged
UINavToggle.availability = UINavAvailability() -- inferred equivalent call
UINavToggle.layoutOrder = LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame

return UINavToggle
