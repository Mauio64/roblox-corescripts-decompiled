local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local Dash = require(Parent.Dash)
local default = require(Parent.LoggingProtocol).default
local AnalyticsService = require(script.Parent.AnalyticsService)
local isSpatial = require(Parent.AppCommonLib).isSpatial

local function getAXStatMetadata(t1: {[any]: any}?) -- line: 16
	-- upvalues: UserInputService (copy), isSpatial (copy), RunService (copy), HttpService (copy), Dash (copy)
	local Platform = UserInputService:GetPlatform()

	if isSpatial() then
		Platform = "VR"
	end

	local t2 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = Platform
	}

	if t1 and next(t1) ~= nil then
		t2 = Dash.assign({}, t2, t1)
	end

	return t2
end
local function sendAXStat(t3: {[any]: any}) -- line: 46
	-- upvalues: getAXStatMetadata (copy), default (copy), AnalyticsService (copy)
	if not t3.excludeStat then
		local t4 = {
			description = "Stat to track Avatar Experience latency.",
			links = "",
			eventName = t3.statName,
			backends = { "RobloxTelemetryStat" },
			lastUpdated = {
				2024,
				11,
				19
			}
		}
		local v16 = getAXStatMetadata(t3.metaData)

		default:logRobloxTelemetryStat(t4, t3.deltaMs, v16)
	end

	if not t3.excludeTelemetry then
		local t5 = {
			deltaMs = t3.deltaMs,
			metricName = t3.statName
		}

		if t3.metaData then
			t5.coldStart = t3.metaData.ColdStart
			t5.category = t3.metaData.Category
			t5.subcategory = t3.metaData.Subcategory
			t5.page = t3.metaData.Page
			t5.opaquePage = t3.metaData.OpaquePage
		end

		local v18 = getAXStatMetadata()

		t5.appVersion = v18.AppVersion
		t5.userAgent = v18.UserAgent
		t5.coreScriptVersion = v18.CoreScriptVersion
		t5.platform = v18.Platform

		local v19 = not t3.customEventStreamSchemaName and "marketplacePerformanceMetric" or t3.customEventStreamSchemaName

		AnalyticsService.EventStream:sendEventDeferred(t3.statName, v19, t5)
	end
end

return sendAXStat
