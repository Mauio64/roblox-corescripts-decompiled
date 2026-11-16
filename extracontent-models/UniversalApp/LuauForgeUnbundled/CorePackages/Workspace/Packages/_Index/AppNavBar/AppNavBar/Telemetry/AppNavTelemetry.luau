local telemetryService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/MockableProxyServices").TelemetryService
require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Enum/Placement")
local deviceTier = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Devices").DeviceTier

local defineFastFlag = game:DefineFastFlag("AppNavDeviceTier", false)
local fFlagAppNavTelemetryLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/SharedFlags").FFlagAppNavTelemetryLogger
local v5

if fFlagAppNavTelemetryLogger then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Loggers").Logger:new("AppNavTelemetry")
else
	v5 = nil
end

local v6 = { "addOSInfo", "addSessionId", "addSessionInfo" }

local v7 = if defineFastFlag then deviceTier.GetDeviceMemoryTier() else nil

local v8 = {
	eventName = "AppNav_SwitchTab",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 3, 12 },
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v9 = {
	eventName = "AppNav_SwitchTab",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 3, 12 },
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v10 = {
	eventName = "AppNav_IsVisibleChanged",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v11 = {
	eventName = "AppNav_IsVisibleChanged",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v12 = {
	eventName = "AppNav_PlacementChanged",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav placement prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v13 = nil

local function logSwitchTabStart(p2, p3)
	v13 = { previousPage = p2, nextPage = p3, startTime = os.clock() }
end

local function reportSwitchTab(previousPage, p2, p3)
	telemetryService:LogStat(v8, {
		customFields = {
			previous_page = previousPage,
			current_page = p2,
			device_tier = if defineFastFlag then v7 else nil
		}
	}, p3)

	telemetryService:LogEvent(v9, {
		customFields = {
			previous_page = previousPage,
			current_page = p2,
			duration = p3
		},
		standardizedFields = v6
	})

	if fFlagAppNavTelemetryLogger then
		v5:info(
			"AppNav switch_tab previous={} current={} duration_ms={} device_tier={}",
			tostring(previousPage),
			tostring(p2),
			string.format("%.2f", p3),
			(tostring(v7))
		)
	end
end

local function logSwitchTabEnd(p2)
	if not v13 then
		return
	end

	if p2 ~= v13.nextPage then
		v13 = nil
		return
	end

	local previousPage = v13.previousPage
	local v14 = (os.clock() - v13.startTime) * 1000
	v13 = nil
	reportSwitchTab(previousPage, p2, v14)
end

local v14 = nil

local function logVisibilityStart(p2)
	v14 = { nextValue = p2, startTime = os.clock() }
end

local function reportVisibility(p2, p3)
	telemetryService:LogStat(v10, {
		customFields = {
			is_visible = p2,
			device_tier = if defineFastFlag then v7 else nil
		}
	}, p3)

	telemetryService:LogEvent(v11, {
		customFields = { is_visible = p2, duration = p3 },
		standardizedFields = v6
	})

	if fFlagAppNavTelemetryLogger then
		v5:info(
			"AppNav is_visible_changed is_visible={} duration_ms={} device_tier={}",
			tostring(p2),
			string.format("%.2f", p3),
			(tostring(v7))
		)
	end
end

local function logVisibilityEnd(p2)
	if not v14 then
		return
	end

	if p2 ~= v14.nextValue then
		v14 = nil
		return
	end

	local v15 = (os.clock() - v14.startTime) * 1000
	v14 = nil
	reportVisibility(p2, v15)
end

local v15 = nil

local function logPlacement(p2)
	if p2 == v15 then
		return
	end

	telemetryService:LogCounter(v12, {
		customFields = { previous_placement = v15, current_placement = p2 }
	})

	if fFlagAppNavTelemetryLogger then
		v5:info("AppNav placement_changed previous={} current={}", tostring(v15), (tostring(p2)))
	end

	v15 = p2
end

local function reset()
	v13 = nil
	v14 = nil
	v15 = nil
end

return {
	logSwitchTabStart = logSwitchTabStart,
	logSwitchTabEnd = logSwitchTabEnd,
	logVisibilityStart = logVisibilityStart,
	logVisibilityEnd = logVisibilityEnd,
	logPlacement = logPlacement,
	reset = reset
}
