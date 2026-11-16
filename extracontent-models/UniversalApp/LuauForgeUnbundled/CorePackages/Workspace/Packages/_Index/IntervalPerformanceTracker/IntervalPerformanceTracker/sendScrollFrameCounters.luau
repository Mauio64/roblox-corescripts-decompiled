local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/LoggingProtocol")
local default = LoggingProtocol.default
local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/AppCommonLib").isSpatial
local deviceTier = require("@game/CorePackages/Workspace/Packages/_Workspace/IntervalPerformanceTracker/Devices").DeviceTier

local JANKY_FRAME_BANDS = require("@game/CorePackages/Workspace/Packages/_Index/IntervalPerformanceTracker/IntervalPerformanceTracker/ScrollFrameBands").JANKY_FRAME_BANDS

local v5 = {
	eventName = "luaScrollFrameBucket",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 9, 1 },
	description = "Per-frame-time-band frame counts for scroll perf; one increment per band per scroll session.",
	links = ""
}

local v6 = {
	eventName = "luaScrollSession",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 9, 1 },
	description = "Completed scroll-session count for scroll perf; one increment per session. Carries a jank_band label (per-session % of frames >= 18 ms, bucketed) so sum by jank_band is the session count and the per-band split reproduces the rollup's sessions_jank_* histogram.",
	links = ""
}

local v7 = {
	2,
	4,
	6,
	8,
	10,
	15,
	20,
	25,
	30,
	40,
	50,
	60,
	80
}
local v8 = {
	"0_2",
	"2_4",
	"4_6",
	"6_8",
	"8_10",
	"10_15",
	"15_20",
	"20_25",
	"25_30",
	"30_40",
	"40_50",
	"50_60",
	"60_80",
	"80_100"
}

local function jankBandForRate(p2)
	for k, v9 in v7 do
		if p2 < v9 then
			return v8[k]
		end
	end

	return v8[#v8]
end

local v9 = nil
local function getMemTier()
	if v9 == nil then
		v9 = deviceTier.GetDeviceMemoryTier()
	end

	return v9 or "unknown"
end

local function getPlatform()
	if isSpatial() then
		return "VR"
	end

	local success, result = pcall(function()
		return UserInputService:GetPlatform()
	end)

	if success and result then
		return result.Name
	end

	return nil
end

local function sendScrollFrameCounters(data)
	local success, result = pcall(function()
		return HttpService:JSONDecode(data.frameBucketsJson)
	end)

	if not success or typeof(result) ~= "table" then
		return
	end

	local v10 = { intervalName = data.intervalName, mem_tier = 0 }

	if v9 == nil then
		v9 = deviceTier.GetDeviceMemoryTier()
	end

	v10.mem_tier = v9 or "unknown"
	local v11

	if isSpatial() then
		v11 = "VR"
	else
		local success2, result2 = pcall(function()
			return UserInputService:GetPlatform()
		end)

		if success2 and result2 then
			v11 = result2.Name
		end
	end

	if v11 then
		v10.platform = v11
	end

	if data.scrollType then
		v10.scroll_type = data.scrollType
	end

	local total = 0
	local total2 = 0

	for k, v12 in result do
		if not (typeof(v12) == "number" and v12 > 0) then
			continue
		end

		total += v12

		if JANKY_FRAME_BANDS[k] then
			total2 += v12
		end

		local clone = table.clone(v10)
		clone.bucket = k
		default:logRobloxTelemetryCounter(v5, v12, clone)
	end

	if total == 0 then
		return
	end

	local v12 = total2 / total * 100
	local clone = table.clone(v10)
	local flag = true
	local v13

	for k, v14 in v7 do
		if v12 < v14 then
			v13 = v8[k]
			flag = false
			break
		end
	end

	if flag then
		v13 = v8[#v8]
	end

	clone.jank_band = v13
	default:logRobloxTelemetryCounter(v6, 1, clone)
end

return sendScrollFrameCounters
