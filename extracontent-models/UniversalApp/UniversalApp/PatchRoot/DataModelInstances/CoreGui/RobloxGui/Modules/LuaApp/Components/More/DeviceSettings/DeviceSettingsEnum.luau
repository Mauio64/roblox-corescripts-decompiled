local CorePackages = game:GetService("CorePackages")
local GetFFlagSystemTrayEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSystemTrayEnabled

return {
	SettingDescription = "SettingDescription",
	MasterVolume = "MasterVolume",
	PartyVoiceVolumeDivider = "PartyVoiceVolumeDivider",
	PartyVoiceVolume = "PartyVoiceVolume",
	DeviceLevelThemeDivider = "DeviceLevelThemeDivider",
	DeviceLevelTheme = "DeviceLevelTheme",
	PreferredTransparencyDivider = "PreferredTransparencyDivider",
	PreferredTransparency = "PreferredTransparency",
	HapticsDivider = "HapticsDivider",
	Haptics = "Haptics",
	ReducedMotionDivider = "ReducedMotionDivider",
	ReducedMotion = "ReducedMotion",
	PreferredTextSizeDivider = "PreferredTextSizeDivider",
	PreferredTextSize = "PreferredTextSize",
	UINavigationKeyBindDivider = "UINavigationKeyBindDivider",
	UINavigationKeyBind = "UINavigationKeyBind",
	ReadAloudDivider = "ReadAloudDivider",
	ReadAloud = "ReadAloud",
	VREnvironmentSettingDivider = "VREnvironmentSettingDivider",
	VREnvironmentSetting = "VREnvironmentSetting",
	RobloxPlusThemeDivider = "RobloxPlusThemeDivider",
	RobloxPlusTheme = "RobloxPlusTheme",
	SkyStyleDivider = "SkyStyleDivider",
	SkyStyle = "SkyStyle",
	LaunchAtStartupDivider = if not GetFFlagSystemTrayEnabled() then nil else "LaunchAtStartupDivider",
	LaunchAtStartup = if not GetFFlagSystemTrayEnabled() then nil else "LaunchAtStartup",
	MinimizeToTrayDivider = if not GetFFlagSystemTrayEnabled() then nil else "MinimizeToTrayDivider",
	MinimizeToTray = if not GetFFlagSystemTrayEnabled() then nil else "MinimizeToTray"
}
