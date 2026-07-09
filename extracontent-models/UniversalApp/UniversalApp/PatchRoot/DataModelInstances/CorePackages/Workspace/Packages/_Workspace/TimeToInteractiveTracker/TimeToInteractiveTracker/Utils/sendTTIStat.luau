local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent
local Dash = require(Parent.Dash)
local default = require(Parent.LoggingProtocol).default
local AppCommonLib = require(Parent.AppCommonLib)
local v8 = require(Parent.TelemetryService).EventStreamReporter.new(default)
local isSpatial = AppCommonLib.isSpatial
local ttiDebugLog = require(script.Parent.ttiDebugLog)
local Util = require(script.Parent.Util)

require(script.Parent.Parent.Stores.types)

local v12 = game:DefineFastString("TTIMetricsTableName", "marketplacePerformanceMetric")
local v13 = game:DefineFastFlag("AXTTIAddNumElementsRendered", false)

game:DefineFastInt("TimeToInteractiveTrackerSampleRate", 0)

local function getDefaultMetadata(p1) -- line: 56
	-- upvalues: UserInputService (copy), isSpatial (copy), RunService (copy), HttpService (copy), Dash (copy)
	local str = tostring(UserInputService:GetPlatform())

	if isSpatial() then
		str = "VR"
	end

	local t1 = {
		AppVersion = RunService:GetRobloxVersion(),
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		Platform = str
	}

	return Dash.assign(t1, p1)
end
local function sendTTIStat(t2: {[any]: any}) -- line: 80
	-- upvalues: RunService (copy), getDefaultMetadata (copy), default (copy), Util (copy), v13 (copy), HttpService (copy), v8 (copy), v12 (copy), ttiDebugLog (copy)
	if math.clamp((if t2.samplingRateOverride == nil then game:GetFastInt("TimeToInteractiveTrackerSampleRate") else t2.samplingRateOverride), 0, 1000) < math.random(1, 1000) and not RunService:IsStudio() then
		return
	end

	local t3 = {
		description = "Stat to track Time-To-Interactive (TTI) latency metrics.",
		links = "",
		eventName = t2.statName,
		backends = { "RobloxTelemetryStat" },
		lastUpdated = {
			2026,
			1,
			14
		}
	}
	local v21 = getDefaultMetadata(t2.metaData)

	default:logRobloxTelemetryStat(t3, t2.deltaMs, v21)

	if t2.milestones then
		for _, v23 in (Util.generateMilestoneStats(t2.statName, t2.milestones)) do
			local v24 = table.clone(t3)

			v24.eventName = v23.eventName
			default:logRobloxTelemetryStat(v24, v23.deltaMs, v21)
		end
	end

	local t4 = {
		deltaMs = t2.deltaMs,
		metricName = t2.statName
	}

	if t2.metaData then
		t4.coldStart = t2.metaData.coldStart
		t4.category = t2.metaData.category
		t4.subcategory = t2.metaData.subcategory
		t4.page = t2.metaData.page
		t4.opaquePage = t2.metaData.opaquePage

		if v13 then
			t4.num_elements_rendered = t2.metaData.numElementsRendered
		end
	end

	local v26 = getDefaultMetadata({})

	t4.appVersion = v26.AppVersion
	t4.userAgent = v26.UserAgent
	t4.coreScriptVersion = v26.CoreScriptVersion
	t4.platform = v26.Platform
	t4.total_memory_mb = t2.totalMemoryMB
	t4.lua_heap_mb = t2.luaHeapMB

	if t2.milestones then
		local v27 = Util.milestonesToProto(t2.milestones)
		local ok, result = pcall(function() -- line: 165
			-- upvalues: HttpService (copy), v27 (copy)
			return HttpService:JSONEncode(v27)
		end)

		if ok then
			t4.milestones_json = result
		end
	end

	v8:sendTelemetryEvent(v12, v12, t4)
	ttiDebugLog("sendTTIStat", t2.statName, t2.deltaMs, t4, t2.milestones)
end

return sendTTIStat
