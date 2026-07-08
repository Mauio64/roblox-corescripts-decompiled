local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local LAYOUT_ORDER = require(Settings.Integrations.Constants).GAMESETTINGS.LAYOUT_ORDER

local function PerfStatsValue() -- line: 23
	-- upvalues: ValueChangedSignal (copy), GameSettings (copy)
	local v12 = ValueChangedSignal.new(GameSettings.PerformanceStatsVisible)

	v12:connect(function(p1) -- line: 26
		-- upvalues: GameSettings (copy)
		if p1 == GameSettings.PerformanceStatsVisible then
			return
		end

		GameSettings.PerformanceStatsVisible = p1
	end)
	GameSettings.PerformanceStatsVisibleChanged:Connect(function() -- line: 36
		-- upvalues: v12 (copy), GameSettings (copy)
		v12:set(GameSettings.PerformanceStatsVisible)
	end)

	return v12
end

local v11 = AvailabilitySignal.new(not CachedPolicyService:IsSubjectToChinaPolicies())

return {
	id = "perf-stats",
	alreadyLocalized = false,
	label = "CoreScripts.InGameMenu.GameSettings.ShowPerfStats",
	field_type = SettingEnum.Toggle,
	onChanged = PerfStatsValue(),
	availability = v11,
	layoutOrder = LAYOUT_ORDER.PerformanceStatsFrame
}
