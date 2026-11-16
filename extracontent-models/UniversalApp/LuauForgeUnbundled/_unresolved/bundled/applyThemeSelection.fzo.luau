local TelemetryService = game:GetService("TelemetryService")

local deviceLevelThemeKey = require("@luauforge/bundled/fyB").DeviceLevelThemeKey

local module = require("@luauforge/bundled/fyV")
local systemThemeService = module.GetSystemThemeService()
local systemThemeEnum = module.GetSystemThemeEnum()

local module2 = require("@luauforge/bundled/fzp")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module3 = require("@luauforge/bundled/fyT")

local function applyThemeSelection(p2, options)
	local v5 = options or {}
	local systemThemeService2 = v5.systemThemeService or systemThemeService
	local systemThemeEnum2 = v5.systemThemeEnum or systemThemeEnum
	local telemetryService = v5.telemetryService or TelemetryService
	local deviceLevelThemeAnalyticsClass = v5.deviceLevelThemeAnalyticsClass or module2

	local v6 = nil

	if p2 == deviceLevelThemeKey.System then
		if systemThemeService2 then
			v6 = module3(systemThemeService2) or nil
		end
	elseif p2 == deviceLevelThemeKey.Light then
		v6 = systemThemeEnum2 and systemThemeEnum2.Light or nil
	elseif p2 == deviceLevelThemeKey.Dark then
		v6 = systemThemeEnum2 and systemThemeEnum2.Dark or nil
	end

	logger:info("The user selected theme: " .. p2 .. ". Setting theme to: " .. tostring(v6))

	if v6 then
		deviceLevelThemeAnalyticsClass.new(telemetryService):onThemeChanged(v6)
	end

	if systemThemeService2 and v6 then
		systemThemeService2:setTheme(v6)
	end
end

return applyThemeSelection
