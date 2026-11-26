local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fGw")
local getFFlagEnableReadAloudInUA = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableReadAloudInUA
local useDeviceType = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useDeviceType
local deviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceType
local module2 = require("@luauforge/bundled/ilt")
local module3 = require("@luauforge/bundled/ilu")
local fFlagUIScaleEngineOptions = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUIScaleEngineOptions
local uiScaleOptions = require("@game/CorePackages/Workspace/Packages/Responsive").UIScaleOptions

local flag = false

local function addUIScale(p2)
	local v5 = uiScaleOptions.get(GuiService)

	if v5 then
		p2.UIScaleMode = v5.savedHundredths ~= 0
		p2.UIScale = v5.savedHundredths
	end
end

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

		local v6 = module3 and fFlagUIScaleEngineOptions and uiScaleOptions.get(GuiService)

		if v6 then
			v5.UIScaleMode = v6.savedHundredths ~= 0
			v5.UIScale = v6.savedHundredths
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

		local v8 = module3 and fFlagUIScaleEngineOptions and uiScaleOptions.get(GuiService)

		if v8 then
			v7.UIScaleMode = v8.savedHundredths ~= 0
			v7.UIScale = v8.savedHundredths
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
