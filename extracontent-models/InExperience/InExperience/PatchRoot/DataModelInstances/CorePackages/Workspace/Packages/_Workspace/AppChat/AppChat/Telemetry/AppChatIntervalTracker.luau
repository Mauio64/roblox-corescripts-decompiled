local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Logger = require(AppChat.Logger)
local v = Logger:new("AppChatPerf")
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker

local AppChatPerfEvent = require(AppChat.Telemetry.AppChatPerfEvent)
local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)
local AppChatTTITracker = require(AppChat.Telemetry.AppChatTTITracker)

local v2 = { "duration", "averageFPS", "longestFrameTime" }
local v3 = {
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

local v4 = {}

local function canStartInterval(p)
	local parentTTI = AppChatPerfEventInfo.getParentTTI(p)
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

local function getMetricsToTrack(p) -- 1 equivalent call inferred from this helper
	if p == AppChatPerfEvent.ScrollConversationList or p == AppChatPerfEvent.ScrollMessageList then
		return v3
	end

	return v2
end

local AppChatIntervalTracker = {
	start = function(p, _, p2): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p)

		local v5, v6 = canStartInterval(p)

		if not v5 then
			v:debug("Perf start ignored: {} (reason={})", p, v6 or "unknown")
			return false
		end

		v:debug("Interval Start: {}", intervalName)
		intervalPerformanceTracker:startTracking(intervalName, nil, getMetricsToTrack(p), true, true, nil, p2) -- inferred equivalent call

		v4[p] = true
		return true
	end,
	finish = function(p): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p)

		if not v4[p] then
			return false
		end

		v:debug("Interval Stop: {}", intervalName)
		intervalPerformanceTracker:stopAndLogTracking(intervalName)
		v4[p] = false
		return true
	end,
	cancel = function(p): boolean
		local intervalName = AppChatPerfEventInfo.getIntervalName(p)

		if not v4[p] then
			return false
		end

		v:debug("Interval Cancel: {}", intervalName)
		intervalPerformanceTracker:cancelTracking(intervalName)
		v4[p] = false
		return true
	end,
	isActive = function(p): boolean
		return v4[p] == true
	end,
	cancelIntervalsForTTI = function(p, p2: string)
		local intervalsForTTI = AppChatPerfEventInfo.getIntervalsForTTI(p)

		for _, v5 in intervalsForTTI do
			if not v4[v5] then
				continue
			end

			local intervalName = AppChatPerfEventInfo.getIntervalName(v5)
			v:debug("Canceling interval ({}): {}", p2, intervalName)
			intervalPerformanceTracker:cancelTracking(intervalName)
			v4[v5] = false
		end
	end
}

AppChatTTITracker.setOnConversationSwitch(function(p)
	AppChatIntervalTracker.cancelIntervalsForTTI(p, "conversation_switch")
end)

return AppChatIntervalTracker
