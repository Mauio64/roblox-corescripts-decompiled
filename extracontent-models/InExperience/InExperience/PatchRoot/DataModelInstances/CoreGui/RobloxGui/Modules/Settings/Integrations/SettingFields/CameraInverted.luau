local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local LAYOUT_ORDER = require(Settings.Integrations.Constants).GAMESETTINGS.LAYOUT_ORDER

local function CameraInvertedValue() -- line: 22
	-- upvalues: ValueChangedSignal (copy), GameSettings (copy)
	local v14 = ValueChangedSignal.new(GameSettings.CameraYInverted)

	v14:connect(function(b1: boolean) -- line: 25
		-- upvalues: GameSettings (copy)
		if b1 == GameSettings.CameraYInverted then
			return
		end

		GameSettings.CameraYInverted = b1
	end, true)

	return v14
end
local function CameraInvertedAvailability() -- line: 36
	-- upvalues: AvailabilitySignal (copy), GameSettings (copy)
	local v15 = AvailabilitySignal.new(GameSettings.IsUsingCameraYInverted)

	GameSettings.Changed:Connect(function(property) -- line: 39
		-- upvalues: v15 (copy), GameSettings (copy)
		if property == "IsUsingCameraYInverted" then
			v15:set(GameSettings.IsUsingCameraYInverted)
		end
	end)

	return v15
end

local t1 = {
	id = "camera-inverted",
	label = "CoreScripts.InGameMenu.GameSettings.InvertedCamera",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle
}
local v12 = ValueChangedSignal.new(GameSettings.CameraYInverted)

v12:connect(function(b2: boolean) -- line: 25
	-- upvalues: GameSettings (copy)
	if b2 == GameSettings.CameraYInverted then
		return
	end

	GameSettings.CameraYInverted = b2
end, true)
t1.onChanged = v12

local v13 = AvailabilitySignal.new(GameSettings.IsUsingCameraYInverted)

GameSettings.Changed:Connect(function(property) -- line: 39
	-- upvalues: v13 (copy), GameSettings (copy)
	if property == "IsUsingCameraYInverted" then
		v13:set(GameSettings.IsUsingCameraYInverted)
	end
end)
t1.availability = v13
t1.layoutOrder = LAYOUT_ORDER.CameraInvertedFrame

return t1
