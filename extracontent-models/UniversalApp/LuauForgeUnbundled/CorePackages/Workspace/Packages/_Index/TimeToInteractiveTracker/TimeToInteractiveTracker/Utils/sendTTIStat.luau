local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/Dash")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/LoggingProtocol")
local default = LoggingProtocol.default
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/AppCommonLib")
local eventStreamReporter = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/TelemetryService").EventStreamReporter.new(default)

local isSpatial = AppCommonLib.isSpatial
local ttiDebugLog = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/ttiDebugLog")
local Util = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/Util")
local FFlagTTITrackerMemoryTracking = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerMemoryTracking")
require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local defineFastString = game:DefineFastString("TTIMetricsTableName", "marketplacePerformanceMetric")

local defineFastFlag = game:DefineFastFlag("AXTTIAddNumElementsRendered", false)

local defineFastFlag2 = game:DefineFastFlag("TTIEmitPointsEvent", false)

local v5 = {
	eventName = "ua_page_load_time",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	lastUpdated = { 2026, 9, 3 },
	description = "Raw per-page-load TTI event to Elasticsearch (Points) for exact-percentile PLT dashboards.",
	links = ""
}

game:DefineFastInt("TimeToInteractiveTrackerSampleRate", 0)

game:DefineFastInt("TTIPointsEventSampleRate", 0)

local function getDefaultMetadata(p2)
	local platform = tostring(UserInputService:GetPlatform())
	local v6 = isSpatial() and "VR" or platform

	local v7 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = v6
	}

	return Dash.assign(v7, p2)
end

local function sendTTIStat(data)
	local v6

	if data.samplingRateOverride == nil then
		v6 = game:GetFastInt("TimeToInteractiveTrackerSampleRate")
	else
		v6 = data.samplingRateOverride
	end

	if math.clamp(v6, 0, 1000) < math.random(1, 1000) and not RunService:IsStudio() then
		return
	end

	local v7 = {
		eventName = data.statName,
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2026, 1, 14 },
		description = "Stat to track Time-To-Interactive (TTI) latency metrics.",
		links = ""
	}

	local defaultMetadata = getDefaultMetadata(data.metaData)

	local function logMemoryStats(p2, totalMemoryMB, luaHeapMB)
		if totalMemoryMB then
			local clone = table.clone(v7)
			clone.eventName = p2 .. "_TotalMemoryMB"
			default:logRobloxTelemetryStat(clone, totalMemoryMB, defaultMetadata)
		end

		if luaHeapMB then
			local clone = table.clone(v7)
			clone.eventName = p2 .. "_LuaHeapMB"
			default:logRobloxTelemetryStat(clone, luaHeapMB, defaultMetadata)
		end
	end

	default:logRobloxTelemetryStat(v7, data.deltaMs, defaultMetadata)

	if data.milestones then
		local milestoneStats = Util.generateMilestoneStats(data.statName, data.milestones)

		for k, milestoneStat in milestoneStats do
			local clone = table.clone(v7)
			clone.eventName = milestoneStat.eventName
			default:logRobloxTelemetryStat(clone, milestoneStat.deltaMs, defaultMetadata)

			if FFlagTTITrackerMemoryTracking then
				logMemoryStats(
					milestoneStat.eventName,
					milestoneStat.totalMemoryMB,
					milestoneStat.luaHeapMB
				)
			end
		end
	end

	if FFlagTTITrackerMemoryTracking then
		logMemoryStats(data.statName, data.totalMemoryMB, data.luaHeapMB)
	end

	local v8 = { deltaMs = data.deltaMs, metricName = data.statName }

	if data.metaData then
		v8.coldStart = data.metaData.coldStart
		v8.category = data.metaData.category
		v8.subcategory = data.metaData.subcategory
		v8.page = data.metaData.page
		v8.opaquePage = data.metaData.opaquePage

		if defineFastFlag then
			v8.num_elements_rendered = data.metaData.numElementsRendered
		end
	end

	local defaultMetadata2 = getDefaultMetadata({})
	v8.appVersion = defaultMetadata2.AppVersion
	v8.userAgent = defaultMetadata2.UserAgent
	v8.coreScriptVersion = defaultMetadata2.CoreScriptVersion
	v8.platform = defaultMetadata2.Platform

	v8.total_memory_mb = data.totalMemoryMB
	v8.lua_heap_mb = data.luaHeapMB

	if data.milestones then
		local milestonesToProto = Util.milestonesToProto(data.milestones)
		local success, result = pcall(function()
			return HttpService:JSONEncode(milestonesToProto)
		end)

		if success then
			v8.milestones_json = result
		end
	end

	eventStreamReporter:sendTelemetryEvent(defineFastString, defineFastString, v8)

	if
		defineFastFlag2
		and (math.clamp(game:GetFastInt("TTIPointsEventSampleRate"), 0, 1000) >= math.random(1, 1000) or RunService:IsStudio())
	then
		local clone = table.clone(v8)
		clone.milestones_json = nil

		if data.milestones then
			for k, v9 in Util.milestonesToPointsFields(data.milestones) do
				clone[k] = v9
			end
		end

		default:logRobloxTelemetryEvent(v5, nil, clone)
	end

	ttiDebugLog("sendTTIStat", data.statName, data.deltaMs, v8, data.milestones)
end

return sendTTIStat
