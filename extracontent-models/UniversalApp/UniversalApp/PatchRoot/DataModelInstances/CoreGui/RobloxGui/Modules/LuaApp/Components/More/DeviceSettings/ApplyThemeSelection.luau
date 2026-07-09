local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local TelemetryService = game:GetService("TelemetryService")
local scriptParent = script.Parent
local DeviceLevelThemeKey = require(scriptParent.DeviceSettingsPageContentConstants).DeviceLevelThemeKey
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local v7 = SystemThemeFeature.GetSystemThemeService()
local v8 = SystemThemeFeature.GetSystemThemeEnum()
local DeviceLevelThemeAnalytics = require(Modules.LuaApp.Components.EventReceivers.Analytics.DeviceLevelThemeAnalytics)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local GetSystemTheme = require(Modules.LuaApp.Components.EventReceivers.GetSystemTheme)

local function applyThemeSelection(s1: string, t1: {[any]: any}?) -- line: 26
	-- upvalues: v7 (copy), v8 (copy), TelemetryService (copy), DeviceLevelThemeAnalytics (copy), DeviceLevelThemeKey (copy), GetSystemTheme (copy), Logger (copy)
	local v15 = t1 or {}
	local v16 = v15.systemThemeService or v7
	local v17 = v15.systemThemeEnum or v8
	local v18 = v15.telemetryService or TelemetryService
	local v19 = v15.deviceLevelThemeAnalyticsClass or DeviceLevelThemeAnalytics
	local v20 = nil

	if s1 == DeviceLevelThemeKey.System then
		v20 = v16 and GetSystemTheme(v16) or nil
	elseif s1 == DeviceLevelThemeKey.Light then
		v20 = v17 and v17.Light or nil
	elseif s1 == DeviceLevelThemeKey.Dark then
		v20 = v17 and v17.Dark or nil
	end

	Logger:info("The user selected theme: " .. s1 .. ". Setting theme to: " .. tostring(v20))

	if v20 then
		v19.new(v18):onThemeChanged(v20)
	end

	if v16 and v20 then
		v16:setTheme(v20)
	end
end

return applyThemeSelection
