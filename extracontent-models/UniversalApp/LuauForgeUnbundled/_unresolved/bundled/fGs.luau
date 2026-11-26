local CorePackages = game:GetService("CorePackages")

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local nextOrder = ReactUtils.createNextOrder()

local module = require("@luauforge/bundled/fGt")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagSystemTrayEnabled = SharedFlags.GetFFlagSystemTrayEnabled
local getFFlagHideLaunchAtStartupMac = SharedFlags.GetFFlagHideLaunchAtStartupMac
local getFFlagLuaAppCustomizableEntryPoint = SharedFlags.GetFFlagLuaAppCustomizableEntryPoint
local fFlagUIScaleEngineOptions = SharedFlags.FFlagUIScaleEngineOptions

local v5 = {}

v5[module.SettingDescription] = nextOrder()
v5[module.MasterVolume] = nextOrder()
v5[module.PartyVoiceVolumeDivider] = nextOrder()
v5[module.PartyVoiceVolume] = nextOrder()
v5[module.DeviceLevelThemeDivider] = nextOrder()
v5[module.DeviceLevelTheme] = nextOrder()

if getFFlagLuaAppCustomizableEntryPoint() then
	v5[module.LaunchDestinationDivider] = nextOrder()
	v5[module.LaunchDestination] = nextOrder()
end

v5[module.RobloxPlusTheme] = nextOrder()
v5[module.AppIcon] = nextOrder()

if fFlagUIScaleEngineOptions then
	v5[module.UIScaleModeDivider] = nextOrder()
	v5[module.UIScaleMode] = nextOrder()
	v5[module.UIScale] = nextOrder()
	v5[module.PreferredTextSizeDivider] = nextOrder()
	v5[module.PreferredTextSize] = nextOrder()
end

v5[module.PreferredTransparencyDivider] = nextOrder()
v5[module.PreferredTransparency] = nextOrder()
v5[module.HapticsDivider] = nextOrder()
v5[module.Haptics] = nextOrder()
v5[module.ReducedMotionDivider] = nextOrder()
v5[module.ReducedMotion] = nextOrder()

if not fFlagUIScaleEngineOptions then
	v5[module.PreferredTextSizeDivider] = nextOrder()
	v5[module.PreferredTextSize] = nextOrder()
end

v5[module.UINavigationKeyBindDivider] = nextOrder()
v5[module.UINavigationKeyBind] = nextOrder()
v5[module.ReadAloudDivider] = nextOrder()
v5[module.ReadAloud] = nextOrder()
v5[module.VREnvironmentSettingDivider] = nextOrder()
v5[module.VREnvironmentSetting] = nextOrder()
v5[module.SkyStyleDivider] = nextOrder()
v5[module.SkyStyle] = nextOrder()

if getFFlagSystemTrayEnabled() and not getFFlagHideLaunchAtStartupMac() then
	v5[module.LaunchAtStartupDivider] = nextOrder()
	v5[module.LaunchAtStartup] = nextOrder()
end

if getFFlagSystemTrayEnabled() then
	v5[module.MinimizeToTrayDivider] = nextOrder()
	v5[module.MinimizeToTray] = nextOrder()
end

return {
	LAYOUT_ORDER = v5,
	DeviceLevelThemeKey = { Dark = "dark", Light = "light", System = "system" },
	CONTEXTUAL_SLIDER_BASE_WIDTH = 310
}
