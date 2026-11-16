local CorePackages = game:GetService("CorePackages")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fyG")
local getFFlagEnableReadAloudInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableReadAloudInUA
local useDeviceType = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceType
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceType
local module2 = require("@luauforge/bundled/icZ")

local flag = false

local function SettingsSnapshotReceiver(): nil
	React.useEffect(function()
		if flag then
			return
		end

		flag = true

		local v5 = {
			ReducedMotion = UserGameSettings.ReducedMotion,
			PreferredTransparency = UserGameSettings.PreferredTransparency,
			PreferredTextSize = UserGameSettings.PreferredTextSize,
			UINavigationKeyBind = UserGameSettings.UiNavigationKeyBindEnabled,
			Haptics = UserGameSettings.HapticStrength,
			MasterVolume = UserGameSettings.MasterVolume
		}

		if getFFlagEnableReadAloudInUA() then
			v5.ReadAloud = UserGameSettings.ReadAloud
		end

		module.reportSettingsSnapshot(v5)
	end, {})

	return nil
end

local function SettingsSnapshotReceiverWithFullscreen(): nil
	local v5 = useDeviceType()
	local v6 = v5 == deviceType.Desktop or v5 == deviceType.Unknown

	React.useEffect(function()
		if flag then
			return
		end

		flag = true

		local v7 = {
			ReducedMotion = UserGameSettings.ReducedMotion,
			PreferredTransparency = UserGameSettings.PreferredTransparency,
			PreferredTextSize = UserGameSettings.PreferredTextSize,
			UINavigationKeyBind = UserGameSettings.UiNavigationKeyBindEnabled,
			Haptics = UserGameSettings.HapticStrength,
			MasterVolume = UserGameSettings.MasterVolume
		}

		if getFFlagEnableReadAloudInUA() then
			v7.ReadAloud = UserGameSettings.ReadAloud
		end

		if v6 then
			v7.Fullscreen = UserGameSettings:InFullScreen()
		end

		module.reportSettingsSnapshot(v7)
	end, { v6 })

	return nil
end

if not module2 then
	SettingsSnapshotReceiverWithFullscreen = SettingsSnapshotReceiver
end

return SettingsSnapshotReceiverWithFullscreen
