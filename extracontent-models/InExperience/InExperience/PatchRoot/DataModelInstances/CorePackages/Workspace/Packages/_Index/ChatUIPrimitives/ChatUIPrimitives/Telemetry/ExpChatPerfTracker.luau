local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local IntervalPerformanceTracker = require(ChatUIPrimitivesParent.IntervalPerformanceTracker).IntervalPerformanceTracker
local TimeToInteractiveTracker = require(ChatUIPrimitivesParent.TimeToInteractiveTracker).TimeToInteractiveTracker
local v5 = require(ChatUIPrimitivesParent.Lumberyak).Logger.new(nil, "ExpChatPerfTracker")
local ExpChatPerfEventConfig = require(script.Parent.ExpChatPerfEventConfig)
local EventTypes = ExpChatPerfEventConfig.EventTypes
local Events = ExpChatPerfEventConfig.Events
local EventConfig = ExpChatPerfEventConfig.EventConfig
local SocialLuaAnalytics = require(ChatUIPrimitivesParent.SocialLuaAnalytics)
local ScrollIntervalTracker = require(ChatUIPrimitivesParent.ScrollIntervalTracker)
local FFlagExpChatScrollPerfTracking = require(ChatUIPrimitives.Flags.FFlagExpChatScrollPerfTracking)
local FFlagExpChatMigrateScrollIntervalTracker = require(ChatUIPrimitives.Flags.FFlagExpChatMigrateScrollIntervalTracker)
local t1 = {
	start = function(p1, p2) -- line: 24
		-- upvalues: EventConfig (copy), EventTypes (copy), TimeToInteractiveTracker (copy), IntervalPerformanceTracker (copy), v5 (copy)
		local v17 = EventConfig[p1] or {}

		if v17.type == EventTypes.TTI then
			v17.onStart(p2)
			TimeToInteractiveTracker.trackStart(v17.baseName)

			return true
		end

		if v17.type == EventTypes.Interval then
			if not v17.canStart(p2) then
				return false
			end

			IntervalPerformanceTracker:cancelTracking(v17.name)
			v17.onStart(p2)
			IntervalPerformanceTracker:startTracking(v17.name, nil, v17.intervalMetrics, true, true)

			return true
		end

		v5:warning(`ExpChatPerfTracker.start: unknown event type for event: { p1 }`)

		return false
	end,
	finish = function(p3, p4) -- line: 46
		-- upvalues: EventConfig (copy), EventTypes (copy), TimeToInteractiveTracker (copy), IntervalPerformanceTracker (copy), v5 (copy)
		local v20 = EventConfig[p3] or {}

		if v20.type == EventTypes.TTI then
			if not v20.canFinish(p4) then
				return
			end

			TimeToInteractiveTracker.trackEnd(v20.baseName)

			return
		end

		if v20.type == EventTypes.Interval then
			if not v20.canFinish(p4) then
				return
			end

			v20.onFinish(p4)
			IntervalPerformanceTracker:stopAndLogTracking(v20.name)

			return
		end

		v5:warning(`ExpChatPerfTracker.finish: unknown event type for event: { p3 }`)
	end,
	cancel = function(p5, p6) -- line: 64
		-- upvalues: EventConfig (copy), EventTypes (copy), TimeToInteractiveTracker (copy), IntervalPerformanceTracker (copy), v5 (copy)
		local v23 = EventConfig[p5] or {}

		if v23.type == EventTypes.TTI then
			TimeToInteractiveTracker.resetEvent(v23.baseName)

			return
		end

		if v23.type == EventTypes.Interval then
			v23.onFinish(p6)
			IntervalPerformanceTracker:cancelTracking(v23.name)

			return
		end

		v5:warning(`ExpChatPerfTracker.cancel: unknown event type for event: { p5 }`)
	end
}

function t1.cancelAll() -- line: 76
	-- upvalues: EventConfig (copy), t1 (copy)
	for v24, _ in EventConfig do
		t1.cancel(v24)
	end
end

t1.Events = Events

if FFlagExpChatScrollPerfTracking then
	function t1.startChatWindowScrollInterval(p7, p8, p9) -- line: 85
		-- upvalues: t1 (copy), FFlagExpChatMigrateScrollIntervalTracker (copy), ScrollIntervalTracker (copy), SocialLuaAnalytics (copy)
		local t2 = {
			debugName = p7
		}

		local function v30(p10) -- line: 93
			-- upvalues: t1 (copy), p7 (copy)
			return t1.start(p7, p10)
		end
		local function v31(p11) -- line: 96
			-- upvalues: t1 (copy), p7 (copy)
			t1.finish(p7, p11)
		end

		if FFlagExpChatMigrateScrollIntervalTracker then
			return ScrollIntervalTracker.createScrollIntervalTracker(v30, v31, p8, p9, t2)
		end

		return SocialLuaAnalytics.Performance.createScrollIntervalTracker(v30, v31, p8, p9, t2)
	end
end

return t1
