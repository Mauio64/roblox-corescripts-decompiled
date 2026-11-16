local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/Analytics").Analytics.new(RbxAnalyticsService)
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/Dash")
local default = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/LoggingProtocol").default
local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/AppCommonLib").isSpatial

local function getDefaultMetadata(metaData)
	local platform = UserInputService:GetPlatform()
	local v5 = isSpatial() and "VR" or platform

	local v6 = {
		appVersion = RunService:GetRobloxVersion(),
		userAgent = HttpService:GetUserAgent(),
		coreScriptVersion = RunService:GetCoreScriptVersion(),
		platform = v5
	}

	return (Dash.assign(v6, metaData))
end

local function sendFPSStat(data)
	local excludeEventStream = data.excludeEventStream ~= false
	local defaultMetadata = getDefaultMetadata(data.metaData)

	if not data.excludeStat then
		default:logRobloxTelemetryStat({
			eventName = data.statName,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = { 2025, 4, 28 },
			description = "Stat to track FPS metrics.",
			links = ""
		}, data.interval, defaultMetadata)
	end

	if not excludeEventStream and data.eventStreamName then
		analytics.EventStream:sendEventDeferred(data.eventStreamName, "robloxFPSMetrics", defaultMetadata)
	end
end

return sendFPSStat
