local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Dash")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/LoggingProtocol").default

local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AnalyticsService")
local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AppCommonLib").isSpatial

local function getAXStatMetadata(items)
	local platform = UserInputService:GetPlatform()

	local v5 = isSpatial() and "VR" or platform

	local v6 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = v5
	}

	if items and next(items) ~= nil then
		v6 = Dash.assign({}, v6, items)
	end

	return v6
end

local function sendAXStat(data)
	if not data.excludeStat then
		local v5 = {
			eventName = data.statName,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = { 2024, 11, 19 },
			description = "Stat to track Avatar Experience latency.",
			links = ""
		}

		local v6 = getAXStatMetadata(data.metaData)
		default:logRobloxTelemetryStat(v5, data.deltaMs, v6)
	end

	if not data.excludeTelemetry then
		local v5 = { deltaMs = data.deltaMs, metricName = data.statName }

		if data.metaData then
			v5.coldStart = data.metaData.ColdStart
			v5.category = data.metaData.Category
			v5.subcategory = data.metaData.Subcategory
			v5.page = data.metaData.Page
			v5.opaquePage = data.metaData.OpaquePage
		end

		local v6 = getAXStatMetadata()
		v5.appVersion = v6.AppVersion
		v5.userAgent = v6.UserAgent
		v5.coreScriptVersion = v6.CoreScriptVersion
		v5.platform = v6.Platform

		local v7 = not data.customEventStreamSchemaName and "marketplacePerformanceMetric"
			or data.customEventStreamSchemaName

		AnalyticsService.EventStream:sendEventDeferred(data.statName, v7, v5)
	end
end

return sendAXStat
