local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent

local Dash = require(parent.Dash)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local AppCommonLib = require(parent.AppCommonLib)
local TelemetryService = require(parent.TelemetryService)
local eventStreamReporter = TelemetryService.EventStreamReporter.new(default)

local isSpatial = AppCommonLib.isSpatial
local ttiDebugLog = require(script.Parent.ttiDebugLog)
local Util = require(script.Parent.Util)
local FFlagTTITrackerMemoryTracking = require(script.Parent.FFlagTTITrackerMemoryTracking)
require(script.Parent.Parent.Stores.types)

local defineFastString = game:DefineFastString("TTIMetricsTableName", "marketplacePerformanceMetric")

local defineFastFlag = game:DefineFastFlag("AXTTIAddNumElementsRendered", false)

local defineFastFlag2 = game:DefineFastFlag("TTIEmitPointsEvent", false)

local v = {
	eventName = "ua_page_load_time",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	lastUpdated = { 2026, 9, 3 },
	description = "Raw per-page-load TTI event to Elasticsearch (Points) for exact-percentile PLT dashboards.",
	links = ""
}

game:DefineFastInt("TimeToInteractiveTrackerSampleRate", 0)

game:DefineFastInt("TTIPointsEventSampleRate", 0)

local function getDefaultMetadata(p)
	local platform = tostring(UserInputService:GetPlatform())
	local platform2 = isSpatial() and "VR" or platform

	local v2 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = platform2
	}

	return Dash.assign(v2, p)
end

local function sendTTIStat(data)
	local v2

	if data.samplingRateOverride == nil then
		v2 = game:GetFastInt("TimeToInteractiveTrackerSampleRate")
	else
		v2 = data.samplingRateOverride
	end

	if math.clamp(v2, 0, 1000) < math.random(1, 1000) and not RunService:IsStudio() then
		return
	end

	local v3 = {
		eventName = data.statName,
		backends = { "RobloxTelemetryStat" },
		lastUpdated = { 2026, 1, 14 },
		description = "Stat to track Time-To-Interactive (TTI) latency metrics.",
		links = ""
	}

	local defaultMetadata = getDefaultMetadata(data.metaData)

	local function logMemoryStats(p: string, totalMemoryMB: number?, luaHeapMB: number?)
		if totalMemoryMB then
			local clone = table.clone(v3)
			clone.eventName = p .. "_TotalMemoryMB"
			default:logRobloxTelemetryStat(clone, totalMemoryMB, defaultMetadata)
		end

		if luaHeapMB then
			local clone = table.clone(v3)
			clone.eventName = p .. "_LuaHeapMB"
			default:logRobloxTelemetryStat(clone, luaHeapMB, defaultMetadata)
		end
	end

	default:logRobloxTelemetryStat(v3, data.deltaMs, defaultMetadata)

	if data.milestones then
		local milestoneStats = Util.generateMilestoneStats(data.statName, data.milestones)

		for _, milestoneStat in milestoneStats do
			local clone = table.clone(v3)
			clone.eventName = milestoneStat.eventName
			default:logRobloxTelemetryStat(clone, milestoneStat.deltaMs, defaultMetadata)

			if FFlagTTITrackerMemoryTracking then
				logMemoryStats(milestoneStat.eventName, milestoneStat.totalMemoryMB, milestoneStat.luaHeapMB)
			end
		end
	end

	if FFlagTTITrackerMemoryTracking then
		logMemoryStats(data.statName, data.totalMemoryMB, data.luaHeapMB)
	end

	local v4 = { deltaMs = data.deltaMs, metricName = data.statName }

	if data.metaData then
		v4.coldStart = data.metaData.coldStart
		v4.category = data.metaData.category
		v4.subcategory = data.metaData.subcategory
		v4.page = data.metaData.page
		v4.opaquePage = data.metaData.opaquePage

		if defineFastFlag then
			v4.num_elements_rendered = data.metaData.numElementsRendered
		end
	end

	local defaultMetadata2 = getDefaultMetadata({})
	v4.appVersion = defaultMetadata2.AppVersion
	v4.userAgent = defaultMetadata2.UserAgent
	v4.coreScriptVersion = defaultMetadata2.CoreScriptVersion
	v4.platform = defaultMetadata2.Platform

	v4.total_memory_mb = data.totalMemoryMB
	v4.lua_heap_mb = data.luaHeapMB

	if data.milestones then
		local milestonesToProto = Util.milestonesToProto(data.milestones)
		local success, result = pcall(function()
			return HttpService:JSONEncode(milestonesToProto)
		end)

		if success then
			v4.milestones_json = result
		end
	end

	eventStreamReporter:sendTelemetryEvent(defineFastString, defineFastString, v4)

	if
		defineFastFlag2
		and (math.clamp(game:GetFastInt("TTIPointsEventSampleRate"), 0, 1000) >= math.random(1, 1000) or RunService:IsStudio())
	then
		local clone = table.clone(v4)
		clone.milestones_json = nil

		if data.milestones then
			for k, v5 in Util.milestonesToPointsFields(data.milestones) do
				clone[k] = v5
			end
		end

		default:logRobloxTelemetryEvent(v, nil, clone)
	end

	ttiDebugLog("sendTTIStat", data.statName, data.deltaMs, v4, data.milestones)
end

return sendTTIStat
