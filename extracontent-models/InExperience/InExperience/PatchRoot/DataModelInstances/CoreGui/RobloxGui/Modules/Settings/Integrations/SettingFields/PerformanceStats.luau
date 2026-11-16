local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function PerfStatsValue()
	local v = ValueChangedSignal.new(gameSettings.PerformanceStatsVisible)

	v:connect(function(performanceStatsVisible)
		if gameSettings.PerformanceStatsVisible == performanceStatsVisible then
			return
		end

		gameSettings.PerformanceStatsVisible = performanceStatsVisible
	end)

	gameSettings.PerformanceStatsVisibleChanged:Connect(function()
		v:set(gameSettings.PerformanceStatsVisible)
	end)

	return v
end

local availability = AvailabilitySignal.new(not CachedPolicyService:IsSubjectToChinaPolicies())

return {
	id = "perf-stats",
	field_type = SettingEnum.Toggle,
	alreadyLocalized = false,
	label = "CoreScripts.InGameMenu.GameSettings.ShowPerfStats",
	onChanged = PerfStatsValue(),
	availability = availability,
	layoutOrder = LAYOUT_ORDER.PerformanceStatsFrame
}
