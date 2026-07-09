local CorePackages = game:GetService("CorePackages")
local scriptParent = script.Parent
local v3 = require(CorePackages.Packages.ReactUtils).createNextOrder()
local DeviceSettingsEnum = require(scriptParent.DeviceSettingsEnum)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagSystemTrayEnabled = SharedFlags.GetFFlagSystemTrayEnabled
local GetFFlagHideLaunchAtStartupMac = SharedFlags.GetFFlagHideLaunchAtStartupMac
local FFlagEnableRobloxPlusThemeSetting = SharedFlags.FFlagEnableRobloxPlusThemeSetting
local t1 = {
	[DeviceSettingsEnum.SettingDescription] = v3(),
	[DeviceSettingsEnum.MasterVolume] = v3(),
	[DeviceSettingsEnum.PartyVoiceVolumeDivider] = v3(),
	[DeviceSettingsEnum.PartyVoiceVolume] = v3(),
	[DeviceSettingsEnum.DeviceLevelThemeDivider] = v3(),
	[DeviceSettingsEnum.DeviceLevelTheme] = v3()
}

if FFlagEnableRobloxPlusThemeSetting then
	t1[DeviceSettingsEnum.RobloxPlusThemeDivider] = v3()
	t1[DeviceSettingsEnum.RobloxPlusTheme] = v3()
end

t1[DeviceSettingsEnum.PreferredTransparencyDivider] = v3()
t1[DeviceSettingsEnum.PreferredTransparency] = v3()
t1[DeviceSettingsEnum.HapticsDivider] = v3()
t1[DeviceSettingsEnum.Haptics] = v3()
t1[DeviceSettingsEnum.ReducedMotionDivider] = v3()
t1[DeviceSettingsEnum.ReducedMotion] = v3()
t1[DeviceSettingsEnum.PreferredTextSizeDivider] = v3()
t1[DeviceSettingsEnum.PreferredTextSize] = v3()
t1[DeviceSettingsEnum.UINavigationKeyBindDivider] = v3()
t1[DeviceSettingsEnum.UINavigationKeyBind] = v3()
t1[DeviceSettingsEnum.ReadAloudDivider] = v3()
t1[DeviceSettingsEnum.ReadAloud] = v3()
t1[DeviceSettingsEnum.VREnvironmentSettingDivider] = v3()
t1[DeviceSettingsEnum.VREnvironmentSetting] = v3()
t1[DeviceSettingsEnum.SkyStyleDivider] = v3()
t1[DeviceSettingsEnum.SkyStyle] = v3()

if GetFFlagSystemTrayEnabled() and not GetFFlagHideLaunchAtStartupMac() then
	t1[DeviceSettingsEnum.LaunchAtStartupDivider] = v3()
	t1[DeviceSettingsEnum.LaunchAtStartup] = v3()
end

if GetFFlagSystemTrayEnabled() then
	t1[DeviceSettingsEnum.MinimizeToTrayDivider] = v3()
	t1[DeviceSettingsEnum.MinimizeToTray] = v3()
end

local t2 = {
	Dark = "dark",
	Light = "light",
	System = "system"
}

return {
	CONTEXTUAL_SLIDER_BASE_WIDTH = 310,
	LAYOUT_ORDER = t1,
	DeviceLevelThemeKey = t2
}
