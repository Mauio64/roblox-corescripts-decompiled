local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Settings = script:FindFirstAncestor("Settings")

local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)
local Constants = require(Settings.Integrations.Constants)
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local SettingEnum = SettingsService.SettingEnum
local DevConsoleMaster = require(script.Parent.Parent.Parent.Parent.DevConsoleMaster)

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local function DeveloperConsoleValue()
	local v = ValueChangedSignal.new()

	v:connect(function()
		if DevConsoleMaster then
			DevConsoleMaster:SetVisibility(true)

			local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

			if SettingsHub then
				SettingsHub:SetVisibility(false)
			end
		end
	end)

	return v
end

local function DeveloperConsoleAvailability()
	local v = AvailabilitySignal.new(false)

	if RunService:IsStudio() then
		v:set(true)
		return v
	end

	spawn(function()
		v:set((PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer)))
	end)

	return v
end

local onActivated = ValueChangedSignal.new()

onActivated:connect(function()
	if DevConsoleMaster then
		DevConsoleMaster:SetVisibility(true)

		local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

		if SettingsHub then
			SettingsHub:SetVisibility(false)
		end
	end
end)

local availability = DeveloperConsoleAvailability()

return {
	field_type = SettingEnum.TextButton,
	id = "developer-console",
	onActivated = onActivated,
	label = "CoreScripts.InGameMenu.GameSettings.DeveloperConsole",
	text = "CoreScripts.InGameMenu.GameSettings.Open",
	layoutOrder = LAYOUT_ORDER.DeveloperConsoleButton,
	alreadyLocalized = false,
	availability = availability
}
