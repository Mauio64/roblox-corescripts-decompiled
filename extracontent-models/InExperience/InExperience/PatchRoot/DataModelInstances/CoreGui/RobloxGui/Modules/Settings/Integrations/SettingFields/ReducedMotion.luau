local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function ReducedMotionValue()
	local reducedMotion = gameSettings.ReducedMotion
	local v = ValueChangedSignal.new(reducedMotion)

	v:connect(function(reducedMotion2: boolean)
		if gameSettings.ReducedMotion == reducedMotion2 then
			return
		end

		gameSettings.ReducedMotion = reducedMotion2
	end)

	return v
end

local ReducedMotion = {
	id = "reduced-motion",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.ReduceMotionLabel",
	description = "CoreScripts.InGameMenu.GameSettings.ReduceMotionDescription",
	alreadyLocalized = false,
	onChanged = 0,
	layoutOrder = 0
}
local reducedMotion = gameSettings.ReducedMotion
local onChanged = ValueChangedSignal.new(reducedMotion)

onChanged:connect(function(reducedMotion2: boolean)
	if gameSettings.ReducedMotion == reducedMotion2 then
		return
	end

	gameSettings.ReducedMotion = reducedMotion2
end)

ReducedMotion.onChanged = onChanged
ReducedMotion.layoutOrder = LAYOUT_ORDER.ReducedMotionFrame

return ReducedMotion
