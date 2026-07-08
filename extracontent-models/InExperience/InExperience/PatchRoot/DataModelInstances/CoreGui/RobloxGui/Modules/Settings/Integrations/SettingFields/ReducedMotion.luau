local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local SettingEnum = SettingsService.SettingEnum
local LAYOUT_ORDER = require(Settings.Integrations.Constants).GAMESETTINGS.LAYOUT_ORDER

local function ReducedMotionValue() -- line: 21
	-- upvalues: GameSettings (copy), ValueChangedSignal (copy)
	local ReducedMotion = GameSettings.ReducedMotion
	local v13 = ValueChangedSignal.new(ReducedMotion)

	v13:connect(function(b1: boolean) -- line: 25
		-- upvalues: GameSettings (copy)
		if b1 == GameSettings.ReducedMotion then
			return
		end

		GameSettings.ReducedMotion = b1
	end)

	return v13
end

local t1 = {
	id = "reduced-motion",
	label = "CoreScripts.InGameMenu.GameSettings.ReduceMotionLabel",
	description = "CoreScripts.InGameMenu.GameSettings.ReduceMotionDescription",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle
}
local ReducedMotion = GameSettings.ReducedMotion
local v11 = ValueChangedSignal.new(ReducedMotion)

v11:connect(function(b2: boolean) -- line: 25
	-- upvalues: GameSettings (copy)
	if b2 == GameSettings.ReducedMotion then
		return
	end

	GameSettings.ReducedMotion = b2
end)
t1.onChanged = v11
t1.layoutOrder = LAYOUT_ORDER.ReducedMotionFrame

return t1
