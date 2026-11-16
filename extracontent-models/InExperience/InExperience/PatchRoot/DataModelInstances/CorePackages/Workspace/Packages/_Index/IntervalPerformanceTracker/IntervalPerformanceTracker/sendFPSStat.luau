local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local Analytics = require(parent.Analytics)
local analytics = Analytics.Analytics.new(RbxAnalyticsService)
local Dash = require(parent.Dash)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local AppCommonLib = require(parent.AppCommonLib)

local isSpatial = AppCommonLib.isSpatial

local function getDefaultMetadata(metaData)
	local platform = UserInputService:GetPlatform()
	local platform2 = isSpatial() and "VR" or platform

	local v = {
		appVersion = RunService:GetRobloxVersion(),
		userAgent = HttpService:GetUserAgent(),
		coreScriptVersion = RunService:GetCoreScriptVersion(),
		platform = platform2
	}

	return (Dash.assign(v, metaData))
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
