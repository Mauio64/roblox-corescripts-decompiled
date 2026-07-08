local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local GuiService = game:GetService("GuiService")
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)
local Utils = require(Settings.Integrations.Utils)
local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function FullScreenValue() -- line: 24
	-- upvalues: ValueChangedSignal (copy), GameSettings (copy), GuiService (copy)
	local v16 = ValueChangedSignal.new(GameSettings:InFullScreen())

	v16:connect(function(p1) -- line: 27
		-- upvalues: GameSettings (copy), GuiService (copy)
		if p1 == GameSettings:InFullScreen() then
			return
		end

		GuiService:ToggleFullscreen()
	end, true)
	GameSettings.FullscreenChanged:Connect(function(p2) -- line: 35
		-- upvalues: v16 (copy)
		v16:set(p2)
	end)

	return v16
end

local v13 = FullScreenValue()

local function initAvailability() -- line: 45
	-- upvalues: Utils (copy)
	return Utils.getDeviceType() == Utils.DeviceTypes.Desktop or Utils.getDeviceType() == Utils.DeviceTypes.Unknown
end

local v15 = AvailabilitySignal.new(Utils.getDeviceType() == Utils.DeviceTypes.Desktop or Utils.getDeviceType() == Utils.DeviceTypes.Unknown)

return {
	id = "fullscreen",
	label = "CoreScripts.InGameMenu.GameSettings.FullScreen",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle,
	layoutOrder = LAYOUT_ORDER.FullScreenFrame,
	onChanged = v13,
	availability = v15
}
