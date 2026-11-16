local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER
local v = { ON = true, OFF = false }

local v2 = { MAX = 1, MIN = 0 }

local function HapticValue()
	local new = ValueChangedSignal.new
	local v3

	if gameSettings.HapticStrength == v2.MIN then
		v3 = v.OFF
	else
		v3 = v.ON
	end

	local v4 = new(v3)
	v4:connect(function(flag: boolean)
		local v5

		if gameSettings.HapticStrength == v2.MIN then
			v5 = v.OFF
		else
			v5 = v.ON
		end

		if v5 == flag then
			return
		end

		gameSettings.HapticStrength = flag == true and 1 or 0
	end)

	return v4
end

return {
	id = "haptics",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.Haptics",
	layoutOrder = LAYOUT_ORDER.HapticsFrame,
	onChanged = HapticValue(),
	alreadyLocalized = false
}
