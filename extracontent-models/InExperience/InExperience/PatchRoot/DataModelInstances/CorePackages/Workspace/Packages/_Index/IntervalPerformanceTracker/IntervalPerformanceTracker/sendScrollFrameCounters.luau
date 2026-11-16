local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("IntervalPerformanceTracker").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local AppCommonLib = require(parent.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local Devices = require(parent.Devices)
local DeviceTier = Devices.DeviceTier

local ScrollFrameBands = require(script.Parent.ScrollFrameBands)
local JANKY_FRAME_BANDS = ScrollFrameBands.JANKY_FRAME_BANDS

local v = {
	eventName = "luaScrollFrameBucket",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 9, 1 },
	description = "Per-frame-time-band frame counts for scroll perf; one increment per band per scroll session.",
	links = ""
}

local v2 = {
	eventName = "luaScrollSession",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 2026, 9, 1 },
	description = "Completed scroll-session count for scroll perf; one increment per session. Carries a jank_band label (per-session % of frames >= 18 ms, bucketed) so sum by jank_band is the session count and the per-band split reproduces the rollup's sessions_jank_* histogram.",
	links = ""
}

local v3 = {
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
local v4 = {
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

local function jankBandForRate(p: number) -- 1 equivalent call inferred from this helper
	for k, v5 in v3 do
		if p < v5 then
			return v4[k]
		end
	end

	return v4[#v4]
end

local v5 = nil
local function getMemTier() -- 1 equivalent call inferred from this helper
	if v5 == nil then
		v5 = DeviceTier.GetDeviceMemoryTier()
	end

	return v5 or "unknown"
end

local function getPlatform()
	if isSpatial() then
		return "VR"
	end

	local success, result = pcall(function()
		return UserInputService:GetPlatform()
	end)

	return if success and result then result.Name else nil
end

local function sendScrollFrameCounters(data)
	local success, result = pcall(function()
		return HttpService:JSONDecode(data.frameBucketsJson)
	end)

	if not success or typeof(result) ~= "table" then
		return
	end

	local v6 = { intervalName = data.intervalName, mem_tier = getMemTier() } -- inferred equivalent call
	local platform

	if isSpatial() then
		platform = "VR"
	else
		local success2, result2 = pcall(function()
			return UserInputService:GetPlatform()
		end)

		if success2 and result2 then
			platform = result2.Name
		end
	end

	if platform then
		v6.platform = platform
	end

	if data.scrollType then
		v6.scroll_type = data.scrollType
	end

	local total = 0
	local total2 = 0

	for k, v7 in result do
		if not (typeof(v7) == "number" and v7 > 0) then
			continue
		end

		total += v7

		if JANKY_FRAME_BANDS[k] then
			total2 += v7
		end

		local clone = table.clone(v6)
		clone.bucket = k
		default:logRobloxTelemetryCounter(v, v7, clone)
	end

	if total == 0 then
		return
	end

	local v7 = total2 / total * 100
	local clone = table.clone(v6)
	clone.jank_band = jankBandForRate(v7) -- inferred equivalent call
	default:logRobloxTelemetryCounter(v2, 1, clone)
end

return sendScrollFrameCounters
