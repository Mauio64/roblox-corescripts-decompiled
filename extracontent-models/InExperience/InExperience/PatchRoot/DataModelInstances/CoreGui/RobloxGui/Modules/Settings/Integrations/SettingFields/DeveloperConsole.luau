local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
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

local function DeveloperConsoleValue() -- line: 22
	-- upvalues: ValueChangedSignal (copy), DevConsoleMaster (copy)
	local v18 = ValueChangedSignal.new()

	v18:connect(function() -- line: 25
		-- upvalues: DevConsoleMaster (copy)
		if DevConsoleMaster then
			DevConsoleMaster:SetVisibility(true)

			local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

			if SettingsHub then
				SettingsHub:SetVisibility(false)
			end
		end
	end)

	return v18
end
local function DeveloperConsoleAvailability() -- line: 40
	-- upvalues: AvailabilitySignal (copy), RunService (copy), PlayerPermissionsModule (copy), Players (copy)
	local v19 = AvailabilitySignal.new(false)

	if RunService:IsStudio() then
		v19:set(true)

		return v19
	end

	spawn(function() -- line: 46
		-- upvalues: PlayerPermissionsModule (copy), Players (copy), v19 (copy)
		local v22 = PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer)

		v19:set(v22)
	end)

	return v19
end

local v16 = ValueChangedSignal.new()

v16:connect(function() -- line: 25
	-- upvalues: DevConsoleMaster (copy)
	if DevConsoleMaster then
		DevConsoleMaster:SetVisibility(true)

		local SettingsHub = require(script.Parent.Parent.Parent.SettingsHub)

		if SettingsHub then
			SettingsHub:SetVisibility(false)
		end
	end
end)

local v17 = DeveloperConsoleAvailability()

return {
	id = "developer-console",
	label = "CoreScripts.InGameMenu.GameSettings.DeveloperConsole",
	text = "CoreScripts.InGameMenu.GameSettings.Open",
	alreadyLocalized = false,
	field_type = SettingEnum.TextButton,
	onActivated = v16,
	layoutOrder = LAYOUT_ORDER.DeveloperConsoleButton,
	availability = v17
}
