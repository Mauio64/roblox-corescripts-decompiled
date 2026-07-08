local Settings = script:FindFirstAncestor("Settings")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local GameSettings = UserSettings().GameSettings
local Players = game:GetService("Players")
local SettingsService = require(CorePackages.Workspace.Packages.SettingsService)
local ValueChangedSignal = SettingsService.ValueChangedSignal
local AvailabilitySignal = SettingsService.AvailabilitySignal
local VisibilitySignal = SettingsService.VisibilitySignal
local SettingEnum = SettingsService.SettingEnum
local Constants = require(Settings.Integrations.Constants)
local LocalPlayer = Players.LocalPlayer
local LAYOUT_ORDER = Constants.GAMESETTINGS.LAYOUT_ORDER
local t1 = {
	[Enum.ControlMode.MouseLockSwitch] = true,
	[Enum.ControlMode.Classic] = false
}

local function ShiftLockValue() -- line: 31
	-- upvalues: t1 (copy), GameSettings (copy), ValueChangedSignal (copy)
	local v21 = t1[GameSettings.ControlMode]
	local v22 = ValueChangedSignal.new(v21)

	v22:connect(function(b1: boolean) -- line: 34
		-- upvalues: t1 (copy), GameSettings (copy)
		if b1 == t1[GameSettings.ControlMode] then
			return
		end

		GameSettings.ControlMode = if not b1 then Enum.ControlMode.Classic else Enum.ControlMode.MouseLockSwitch
	end)

	return v22
end
local function ShiftLockAvailability(_, p2) -- line: 45
	-- upvalues: LocalPlayer (copy), UserInputService (copy), AvailabilitySignal (copy)
	local function available() -- line: 46
		-- upvalues: LocalPlayer (copy), UserInputService (copy)
		local v31 = not LocalPlayer or LocalPlayer.DevEnableMouseLock

		return UserInputService.MouseEnabled and (UserInputService.KeyboardEnabled and v31)
	end

	local new = AvailabilitySignal.new
	local v27 = not LocalPlayer or LocalPlayer.DevEnableMouseLock
	local v28 = new(UserInputService.MouseEnabled and (UserInputService.KeyboardEnabled and v27))

	v28:connect(function(b2: boolean) -- line: 52
		-- upvalues: p2 (copy)
		if b2 then
			p2:set(b2)
		end
	end, true)

	if LocalPlayer then
		LocalPlayer.Changed:Connect(function(property) -- line: 59
			-- upvalues: v28 (copy), LocalPlayer (copy), UserInputService (copy)
			if property == "DevEnableMouseLock" then
				local v34 = v28
				local v35 = not LocalPlayer or LocalPlayer.DevEnableMouseLock

				v34:set(UserInputService.MouseEnabled and (UserInputService.KeyboardEnabled and v35))
			end
		end)
	end

	UserInputService.Changed:Connect(function(property) -- line: 66
		-- upvalues: v28 (copy), LocalPlayer (copy), UserInputService (copy)
		if property == "MouseEnabled" or property == "KeyboardEnabled" then
			local v37 = v28
			local v38 = not LocalPlayer or LocalPlayer.DevEnableMouseLock

			v37:set(UserInputService.MouseEnabled and (UserInputService.KeyboardEnabled and v38))
		end
	end)

	return v28
end

local v17 = t1[GameSettings.ControlMode]
local v18 = ValueChangedSignal.new(v17)

v18:connect(function(b3: boolean) -- line: 34
	-- upvalues: t1 (copy), GameSettings (copy)
	if b3 == t1[GameSettings.ControlMode] then
		return
	end

	GameSettings.ControlMode = if not b3 then Enum.ControlMode.Classic else Enum.ControlMode.MouseLockSwitch
end)

local v19 = VisibilitySignal.new(true)
local v20 = ShiftLockAvailability(v18, v19)

return {
	id = "shift-lock",
	label = "CoreScripts.InGameMenu.GameSettings.ShiftLock",
	alreadyLocalized = false,
	field_type = SettingEnum.Toggle,
	onChanged = v18,
	availability = v20,
	visibility = v19,
	layoutOrder = LAYOUT_ORDER.ShiftLockFrame
}
