local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local SettingEnum = SettingsService.SettingEnum
local LAYOUT_ORDER = require(Settings.Integrations.Constants).GAMESETTINGS.LAYOUT_ORDER
local t1 = {
	ON = true,
	OFF = false
}
local t2 = {
	MAX = 1,
	MIN = 0
}

local function HapticValue() -- line: 29
	-- upvalues: GameSettings (copy), ValueChangedSignal (copy), t2 (copy), t1 (copy)
	local v11 = ValueChangedSignal.new(if GameSettings.HapticStrength ~= t2.MIN then t1.ON else t1.OFF)

	v11:connect(function(b1: boolean) -- line: 35
		-- upvalues: GameSettings (copy), t2 (copy), t1 (copy)
		if b1 == if GameSettings.HapticStrength ~= t2.MIN then t1.ON else t1.OFF then
			return
		end

		GameSettings.HapticStrength = b1 ~= true and 0 or 1
	end)

	return v11
end

return {
	id = "haptics",
	label = "CoreScripts.InGameMenu.GameSettings.Haptics",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle,
	layoutOrder = LAYOUT_ORDER.HapticsFrame,
	onChanged = HapticValue()
}
