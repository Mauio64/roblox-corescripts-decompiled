local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Dash = require(parent.Dash)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local AnalyticsService = require(script.Parent.AnalyticsService)
local AppCommonLib = require(parent.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local function getAXStatMetadata(items)
	local platform = UserInputService:GetPlatform()

	local platform2 = isSpatial() and "VR" or platform

	local v = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = platform2
	}

	if items and next(items) ~= nil then
		return (Dash.assign({}, v, items))
	end

	return v
end

local function sendAXStat(data)
	if not data.excludeStat then
		local v = {
			eventName = data.statName,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = { 2024, 11, 19 },
			description = "Stat to track Avatar Experience latency.",
			links = ""
		}

		local v2 = getAXStatMetadata(data.metaData)
		default:logRobloxTelemetryStat(v, data.deltaMs, v2)
	end

	if not data.excludeTelemetry then
		local v = { deltaMs = data.deltaMs, metricName = data.statName }

		if data.metaData then
			v.coldStart = data.metaData.ColdStart
			v.category = data.metaData.Category
			v.subcategory = data.metaData.Subcategory
			v.page = data.metaData.Page
			v.opaquePage = data.metaData.OpaquePage
		end

		local v2 = getAXStatMetadata()
		v.appVersion = v2.AppVersion
		v.userAgent = v2.UserAgent
		v.coreScriptVersion = v2.CoreScriptVersion
		v.platform = v2.Platform

		local v3 = not data.customEventStreamSchemaName and "marketplacePerformanceMetric"
			or data.customEventStreamSchemaName

		AnalyticsService.EventStream:sendEventDeferred(data.statName, v3, v)
	end
end

return sendAXStat
