local parent = script.Parent.Parent
local parent2 = parent.Parent

local MockableProxyServices = require(parent2.MockableProxyServices)
local TelemetryService = MockableProxyServices.TelemetryService
require(parent.Enum.Placement)
local Devices = require(parent2.Devices)
local DeviceTier = Devices.DeviceTier

local defineFastFlag = game:DefineFastFlag("AppNavDeviceTier", false)
local SharedFlags = require(parent2.SharedFlags)
local FFlagAppNavTelemetryLogger = SharedFlags.FFlagAppNavTelemetryLogger
local v

if FFlagAppNavTelemetryLogger then
	local Loggers = require(parent2.Loggers)
	v = Loggers.Logger:new("AppNavTelemetry")
else
	v = nil
end

local standardizedFields = { "addOSInfo", "addSessionId", "addSessionInfo" }
local v2

if defineFastFlag then
	v2 = DeviceTier.GetDeviceMemoryTier()
else
	v2 = nil
end

local v3 = {
	eventName = "AppNav_SwitchTab",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 3, 12 },
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v4 = {
	eventName = "AppNav_SwitchTab",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 3, 12 },
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v5 = {
	eventName = "AppNav_IsVisibleChanged",
	backends = { "RobloxTelemetryStat" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v6 = {
	eventName = "AppNav_IsVisibleChanged",
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v7 = {
	eventName = "AppNav_PlacementChanged",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 26, 3, 17 },
	description = "App Nav placement prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE"
}

local v8 = nil

local function logSwitchTabStart(previousPage: string, nextPage: string)
	v8 = { previousPage = previousPage, nextPage = nextPage, startTime = os.clock() }
end

local function reportSwitchTab(previousPage: string, current_page: string, duration: number)
	local device_tier

	if defineFastFlag then
		device_tier = v2
	end

	TelemetryService:LogStat(v3, {
		customFields = {
			previous_page = previousPage,
			current_page = current_page,
			device_tier = device_tier
		}
	}, duration)

	TelemetryService:LogEvent(v4, {
		customFields = {
			previous_page = previousPage,
			current_page = current_page,
			duration = duration
		},
		standardizedFields = standardizedFields
	})

	if FFlagAppNavTelemetryLogger then
		v:info(
			"AppNav switch_tab previous={} current={} duration_ms={} device_tier={}",
			tostring(previousPage),
			tostring(current_page),
			string.format("%.2f", duration),
			(tostring(v2))
		)
	end
end

local function logSwitchTabEnd(current_page: string)
	if not v8 then
		return
	end

	if current_page ~= v8.nextPage then
		v8 = nil
		return
	end

	local previousPage = v8.previousPage
	local duration = (os.clock() - v8.startTime) * 1000
	v8 = nil
	reportSwitchTab(previousPage, current_page, duration)
end

local v9 = nil

local function logVisibilityStart(nextValue: boolean)
	v9 = { nextValue = nextValue, startTime = os.clock() }
end

local function reportVisibility(is_visible: boolean, duration: number)
	local device_tier

	if defineFastFlag then
		device_tier = v2
	end

	TelemetryService:LogStat(v5, {
		customFields = { is_visible = is_visible, device_tier = device_tier }
	}, duration)

	TelemetryService:LogEvent(v6, {
		customFields = { is_visible = is_visible, duration = duration },
		standardizedFields = standardizedFields
	})

	if FFlagAppNavTelemetryLogger then
		v:info(
			"AppNav is_visible_changed is_visible={} duration_ms={} device_tier={}",
			tostring(is_visible),
			string.format("%.2f", duration),
			(tostring(v2))
		)
	end
end

local function logVisibilityEnd(is_visible: boolean)
	if not v9 then
		return
	end

	if is_visible ~= v9.nextValue then
		v9 = nil
		return
	end

	local duration = (os.clock() - v9.startTime) * 1000
	v9 = nil
	reportVisibility(is_visible, duration)
end

local previous_placement = nil

local function logPlacement(current_placement)
	if current_placement == previous_placement then
		return
	end

	TelemetryService:LogCounter(v7, {
		customFields = {
			previous_placement = previous_placement,
			current_placement = current_placement
		}
	})

	if FFlagAppNavTelemetryLogger then
		v:info(
			"AppNav placement_changed previous={} current={}",
			tostring(previous_placement),
			(tostring(current_placement))
		)
	end

	previous_placement = current_placement
end

local function reset()
	v8 = nil
	v9 = nil
	previous_placement = nil
end

return {
	logSwitchTabStart = logSwitchTabStart,
	logSwitchTabEnd = logSwitchTabEnd,
	logVisibilityStart = logVisibilityStart,
	logVisibilityEnd = logVisibilityEnd,
	logPlacement = logPlacement,
	reset = reset
}
