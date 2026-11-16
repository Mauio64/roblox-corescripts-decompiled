local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local gameSettings = UserSettings().GameSettings
local Players = game:GetService("Players")

local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local VisibilitySignal = SettingsService.VisibilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)
local LocalPlayer = Players.LocalPlayer

local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER

local v = { [Enum.ControlMode.MouseLockSwitch] = true, [Enum.ControlMode.Classic] = false }

local function ShiftLockValue()
	local v2 = v[gameSettings.ControlMode]
	local v3 = ValueChangedSignal.new(v2)
	v3:connect(function(flag: boolean)
		if v[gameSettings.ControlMode] == flag then
			return
		end

		local controlMode

		if flag then
			controlMode = Enum.ControlMode.MouseLockSwitch
		else
			controlMode = Enum.ControlMode.Classic
		end

		gameSettings.ControlMode = controlMode
	end)
	return v3
end

local function ShiftLockAvailability(_, object)
	local function available() -- 3 equivalent calls inferred from this helper
		local v2 = not LocalPlayer or LocalPlayer.DevEnableMouseLock
		return UserInputService.MouseEnabled and UserInputService.KeyboardEnabled and v2
	end

	local v2 = AvailabilitySignal.new(available()) -- inferred equivalent call

	v2:connect(function(flag: boolean)
		if flag then
			object:set(flag)
		end
	end, true)

	if LocalPlayer then
		LocalPlayer.Changed:Connect(function(p)
			if p == "DevEnableMouseLock" then
				v2:set(available()) -- inferred equivalent call
			end
		end)
	end

	UserInputService.Changed:Connect(function(p)
		if p == "MouseEnabled" or p == "KeyboardEnabled" then
			v2:set(available()) -- inferred equivalent call
		end
	end)

	return v2
end

local v2 = v[gameSettings.ControlMode]
local onChanged = ValueChangedSignal.new(v2)
onChanged:connect(function(flag: boolean)
	if v[gameSettings.ControlMode] == flag then
		return
	end

	local controlMode

	if flag then
		controlMode = Enum.ControlMode.MouseLockSwitch
	else
		controlMode = Enum.ControlMode.Classic
	end

	gameSettings.ControlMode = controlMode
end)

local visibility = VisibilitySignal.new(true)
local availability = ShiftLockAvailability(onChanged, visibility)

return {
	id = "shift-lock",
	field_type = SettingEnum.Toggle,
	label = "CoreScripts.InGameMenu.GameSettings.ShiftLock",
	alreadyLocalized = false,
	onChanged = onChanged,
	availability = availability,
	visibility = visibility,
	layoutOrder = LAYOUT_ORDER.ShiftLockFrame
}
