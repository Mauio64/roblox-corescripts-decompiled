local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local v3 = require(AppChat.Logger):new("AppChatPerf")
local IntervalPerformanceTracker = require(AppChatParent.IntervalPerformanceTracker).IntervalPerformanceTracker
local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)
local AppChatTTITracker = require(AppChat.Telemetry.AppChatTTITracker)
local t1 = {
	"duration",
	"averageFPS",
	"longestFrameTime"
}
local t2 = {}

local function canStartInterval(p1) -- line: 40
	-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy)
	local v12 = AppChatPerfEventInfo.getParentTTI(p1)
	local v13 = AppChatPerfEventInfo.getTTIPage(v12)

	if not AppChatTTITracker.isInteractive(v12) then
		return false, v13 .. "_not_interactive"
	end

	local v14 = AppChatTTITracker.getInteractiveTimestamp(v12)

	if v14 and os.clock() - v14 < 0.5 then
		return false, v13 .. "_interactive_settling_delay"
	end

	return true, nil
end

local t3 = {
	start = function(p2, _) -- line: 66
		-- upvalues: AppChatPerfEventInfo (copy), canStartInterval (copy), v3 (copy), IntervalPerformanceTracker (copy), t1 (copy), t2 (copy)
		local v17 = AppChatPerfEventInfo.getIntervalName(p2)
		local v18, v19 = canStartInterval(p2)

		if not v18 then
			v3:debug("Perf start ignored: {} (reason={})", p2, v19 or "unknown")

			return false
		end

		v3:debug("Interval Start: {}", v17)
		IntervalPerformanceTracker:startTracking(v17, nil, t1, true, true)
		t2[p2] = true

		return true
	end,
	finish = function(p4) -- line: 87
		-- upvalues: AppChatPerfEventInfo (copy), t2 (copy), v3 (copy), IntervalPerformanceTracker (copy)
		local v21 = AppChatPerfEventInfo.getIntervalName(p4)

		if not t2[p4] then
			return false
		end

		v3:debug("Interval Stop: {}", v21)
		IntervalPerformanceTracker:stopAndLogTracking(v21)
		t2[p4] = false

		return true
	end,
	cancel = function(p5) -- line: 98
		-- upvalues: AppChatPerfEventInfo (copy), t2 (copy), v3 (copy), IntervalPerformanceTracker (copy)
		local v23 = AppChatPerfEventInfo.getIntervalName(p5)

		if not t2[p5] then
			return false
		end

		v3:debug("Interval Cancel: {}", v23)
		IntervalPerformanceTracker:cancelTracking(v23)
		t2[p5] = false

		return true
	end,
	isActive = function(p6) -- line: 109
		-- upvalues: t2 (copy)
		return t2[p6] == true
	end,
	cancelIntervalsForTTI = function(p7, s1: string) -- line: 115
		-- upvalues: AppChatPerfEventInfo (copy), t2 (copy), v3 (copy), IntervalPerformanceTracker (copy)
		for _, v28 in (AppChatPerfEventInfo.getIntervalsForTTI(p7)) do
			if t2[v28] then
				local v29 = AppChatPerfEventInfo.getIntervalName(v28)

				v3:debug("Canceling interval ({}): {}", s1, v29)
				IntervalPerformanceTracker:cancelTracking(v29)
				t2[v28] = false
			end
		end
	end
}

AppChatTTITracker.setOnConversationSwitch(function(p8) -- line: 128
	-- upvalues: t3 (copy)
	t3.cancelIntervalsForTTI(p8, "conversation_switch")
end)

return t3
