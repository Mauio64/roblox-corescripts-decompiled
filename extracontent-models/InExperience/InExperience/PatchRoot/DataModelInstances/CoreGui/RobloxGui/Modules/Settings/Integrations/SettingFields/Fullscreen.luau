local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings
local GuiService = game:GetService("GuiService")

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)
local Utils = require(Settings.Integrations.Utils)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function FullScreenValue()
	local v = ValueChangedSignal.new(gameSettings:InFullScreen())

	v:connect(function(p)
		if p == gameSettings:InFullScreen() then
			return
		end

		GuiService:ToggleFullscreen()
	end, true)

	gameSettings.FullscreenChanged:Connect(function(p)
		v:set(p)
	end)

	return v
end

local onChanged = FullScreenValue()

local function initAvailability(): boolean -- 1 equivalent call inferred from this helper
	return Utils.getDeviceType() == Utils.DeviceTypes.Desktop or Utils.getDeviceType() == Utils.DeviceTypes.Unknown
end

local availability = AvailabilitySignal.new(initAvailability()) -- inferred equivalent call

return {
	id = "fullscreen",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.FullScreen",
	layoutOrder = LAYOUT_ORDER.FullScreenFrame,
	onChanged = onChanged,
	alreadyLocalized = false,
	availability = availability
}
