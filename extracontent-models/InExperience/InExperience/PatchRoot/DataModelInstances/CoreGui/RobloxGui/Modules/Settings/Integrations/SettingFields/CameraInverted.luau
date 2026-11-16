local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function CameraInvertedValue()
	local v = ValueChangedSignal.new(gameSettings.CameraYInverted)

	v:connect(function(cameraYInverted: boolean)
		if gameSettings.CameraYInverted == cameraYInverted then
			return
		end

		gameSettings.CameraYInverted = cameraYInverted
	end, true)

	return v
end

local function CameraInvertedAvailability() -- 1 equivalent call inferred from this helper
	local v = AvailabilitySignal.new(gameSettings.IsUsingCameraYInverted)

	gameSettings.Changed:Connect(function(p)
		if p == "IsUsingCameraYInverted" then
			v:set(gameSettings.IsUsingCameraYInverted)
		end
	end)

	return v
end

local CameraInverted = {
	id = "camera-inverted",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.InvertedCamera",
	alreadyLocalized = false,
	onChanged = 0,
	availability = 0,
	layoutOrder = 0
}
local onChanged = ValueChangedSignal.new(gameSettings.CameraYInverted)

onChanged:connect(function(cameraYInverted: boolean)
	if gameSettings.CameraYInverted == cameraYInverted then
		return
	end

	gameSettings.CameraYInverted = cameraYInverted
end, true)

CameraInverted.onChanged = onChanged
CameraInverted.availability = CameraInvertedAvailability() -- inferred equivalent call
CameraInverted.layoutOrder = LAYOUT_ORDER.CameraInvertedFrame

return CameraInverted
