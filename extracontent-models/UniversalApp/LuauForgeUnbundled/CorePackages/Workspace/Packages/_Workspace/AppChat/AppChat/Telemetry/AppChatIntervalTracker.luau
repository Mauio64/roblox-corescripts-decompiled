local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatPerf")
local intervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/IntervalPerformanceTracker").IntervalPerformanceTracker

local AppChatPerfEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEvent")
local AppChatPerfEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEventInfo")
local AppChatTTITracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatTTITracker")

local v6 = { "duration", "averageFPS", "longestFrameTime" }
local v7 = {
	"duration",
	"averageFPS",
	"framesCount",
	"longestFrameTime",
	"frameTimeAvgMs",
	"frameTimeStdDevMs",
	"frameTimeDistributionMs",
	"frameBuckets",
	"rawFrameTimesMs",
	"rawScrollPositionSamplesCsv"
}

local v8 = {}

local function canStartInterval(p2)
	local parentTTI = AppChatPerfEventInfo.getParentTTI(p2)
	local ttiPage = AppChatPerfEventInfo.getTTIPage(parentTTI)

	if not AppChatTTITracker.isInteractive(parentTTI) then
		return false, ttiPage .. "_not_interactive"
	end

	local interactiveTimestamp = AppChatTTITracker.getInteractiveTimestamp(parentTTI)

	if interactiveTimestamp and os.clock() - interactiveTimestamp < 0.5 then
		return false, ttiPage .. "_interactive_settling_delay"
	end

	return true, nil
end

local function getMetricsToTrack(p2)
	if p2 == AppChatPerfEvent.ScrollConversationList or p2 == AppChatPerfEvent.ScrollMessageList then
		return v7
	end

	return v6
end

local v9 = {
	start = function(p2, p3, p4): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p2)

		local v10, v11 = canStartInterval(p2)

		if not v10 then
			v5:debug("Perf start ignored: {} (reason={})", p2, v11 or "unknown")
			return false
		end

		v5:debug("Interval Start: {}", intervalName)
		local v14 = if p2 == AppChatPerfEvent.ScrollConversationList or p2 == AppChatPerfEvent.ScrollMessageList then v7 else v6

		intervalPerformanceTracker:startTracking(intervalName, nil, v14, true, true, nil, p4)

		v8[p2] = true
		return true
	end,
	finish = function(p2): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p2)

		if not v8[p2] then
			return false
		end

		v5:debug("Interval Stop: {}", intervalName)
		intervalPerformanceTracker:stopAndLogTracking(intervalName)
		v8[p2] = false
		return true
	end,
	cancel = function(p2): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p2)

		if not v8[p2] then
			return false
		end

		v5:debug("Interval Cancel: {}", intervalName)
		intervalPerformanceTracker:cancelTracking(intervalName)
		v8[p2] = false
		return true
	end,
	isActive = function(p2): boolean
		return v8[p2] == true
	end,
	cancelIntervalsForTTI = function(p2, p3)
		local intervalsForTTI = AppChatPerfEventInfo.getIntervalsForTTI(p2)

		for k, v10 in intervalsForTTI do
			if not v8[v10] then
				continue
			end

			local intervalName = AppChatPerfEventInfo.getIntervalName(v10)
			v5:debug("Canceling interval ({}): {}", p3, intervalName)
			intervalPerformanceTracker:cancelTracking(intervalName)
			v8[v10] = false
		end
	end
}

AppChatTTITracker.setOnConversationSwitch(function(p2)
	v9.cancelIntervalsForTTI(p2, "conversation_switch")
end)

return v9
