local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local v6 = require(Parent.Analytics).Analytics.new(RbxAnalyticsService)
local Dash = require(Parent.Dash)
local default = require(Parent.LoggingProtocol).default
local isSpatial = require(Parent.AppCommonLib).isSpatial

local function getDefaultMetadata(t1: {[any]: any}) -- line: 18
	-- upvalues: UserInputService (copy), isSpatial (copy), RunService (copy), HttpService (copy), Dash (copy)
	local Platform = UserInputService:GetPlatform()

	if isSpatial() then
		Platform = "VR"
	end

	local t2 = {
		appVersion = RunService:GetRobloxVersion(),
		userAgent = HttpService:GetUserAgent(),
		coreScriptVersion = RunService:GetCoreScriptVersion(),
		platform = Platform
	}

	return (Dash.assign(t2, t1))
end
local function sendFPSStat(t3: {[any]: any}) -- line: 43
	-- upvalues: getDefaultMetadata (copy), default (copy), v6 (copy)
	local v16 = t3.excludeEventStream ~= false
	local v17 = getDefaultMetadata(t3.metaData)

	if not t3.excludeStat then
		local t4 = {
			description = "Stat to track FPS metrics.",
			links = "",
			eventName = t3.statName,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = {
				2025,
				4,
				28
			}
		}

		default:logRobloxTelemetryStat(t4, t3.interval, v17)
	end

	if not v16 and t3.eventStreamName then
		v6.EventStream:sendEventDeferred(t3.eventStreamName, "robloxFPSMetrics", v17)
	end
end

return sendFPSStat
