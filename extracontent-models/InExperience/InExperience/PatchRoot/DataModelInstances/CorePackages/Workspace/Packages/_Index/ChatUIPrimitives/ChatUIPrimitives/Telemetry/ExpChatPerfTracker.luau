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
local FFlagExpChatPerfTrackerTabName = require(ChatUIPrimitives.Flags.FFlagExpChatPerfTrackerTabName)
local t3 = {
	start = function(p1, p2, t1: {[any]: any}?) -- line: 27
		-- upvalues: EventConfig (copy), EventTypes (copy), TimeToInteractiveTracker (copy), FFlagExpChatPerfTrackerTabName (copy), IntervalPerformanceTracker (copy), v5 (copy)
		local v19 = EventConfig[p1] or {}

		if v19.type == EventTypes.TTI then
			v19.onStart(p2)
			TimeToInteractiveTracker.trackStart(v19.baseName)

			if FFlagExpChatPerfTrackerTabName and t1 and t1.tabName then
				TimeToInteractiveTracker.updateMetadata(v19.baseName, {
					page = t1.tabName
				})
			end

			return true
		end

		if v19.type == EventTypes.Interval then
			if not v19.canStart(p2) then
				return false
			end

			IntervalPerformanceTracker:cancelTracking(v19.name)
			v19.onStart(p2)

			if FFlagExpChatPerfTrackerTabName and t1 then
				IntervalPerformanceTracker:startTracking(v19.name, nil, v19.intervalMetrics, true, true, t1)
			else
				IntervalPerformanceTracker:startTracking(v19.name, nil, v19.intervalMetrics, true, true)
			end

			return true
		end

		v5:warning(`ExpChatPerfTracker.start: unknown event type for event: { p1 }`)

		return false
	end,
	finish = function(p3, p4, t2: {[any]: any}?) -- line: 63
		-- upvalues: EventConfig (copy), EventTypes (copy), FFlagExpChatPerfTrackerTabName (copy), TimeToInteractiveTracker (copy), v5 (copy), IntervalPerformanceTracker (copy)
		local v23 = EventConfig[p3] or {}

		if v23.type == EventTypes.TTI then
			if not v23.canFinish(p4) then
				return
			end

			if FFlagExpChatPerfTrackerTabName and t2 and t2.tabName then
				TimeToInteractiveTracker.updateMetadata(v23.baseName, {
					page = t2.tabName
				})
			end

			TimeToInteractiveTracker.trackEnd(v23.baseName)

			return
		end

		if v23.type == EventTypes.Interval then
			if not v23.canFinish(p4) then
				return
			end

			if FFlagExpChatPerfTrackerTabName and t2 then
				v5:warning("Unable to update finished interval extra fields")
			end

			v23.onFinish(p4)
			IntervalPerformanceTracker:stopAndLogTracking(v23.name)

			return
		end

		v5:warning(`ExpChatPerfTracker.finish: unknown event type for event: { p3 }`)
	end,
	cancel = function(p5, p6) -- line: 87
		-- upvalues: EventConfig (copy), EventTypes (copy), TimeToInteractiveTracker (copy), IntervalPerformanceTracker (copy), v5 (copy)
		local v26 = EventConfig[p5] or {}

		if v26.type == EventTypes.TTI then
			TimeToInteractiveTracker.resetEvent(v26.baseName)

			return
		end

		if v26.type == EventTypes.Interval then
			v26.onFinish(p6)
			IntervalPerformanceTracker:cancelTracking(v26.name)

			return
		end

		v5:warning(`ExpChatPerfTracker.cancel: unknown event type for event: { p5 }`)
	end
}

function t3.cancelAll() -- line: 99
	-- upvalues: EventConfig (copy), t3 (copy)
	for v27, _ in EventConfig do
		t3.cancel(v27)
	end
end

t3.Events = Events

if FFlagExpChatScrollPerfTracking then
	function t3.startChatWindowScrollInterval(p7, p8, p9, t4: {[any]: any}?) -- line: 108
		-- upvalues: t3 (copy), FFlagExpChatMigrateScrollIntervalTracker (copy), ScrollIntervalTracker (copy), SocialLuaAnalytics (copy)
		local t5 = {
			debugName = p7
		}

		local function v34(p10) -- line: 117
			-- upvalues: t3 (copy), p7 (copy), t4 (copy)
			return t3.start(p7, p10, t4)
		end
		local function v35(p11) -- line: 120
			-- upvalues: t3 (copy), p7 (copy)
			t3.finish(p7, p11)
		end

		if FFlagExpChatMigrateScrollIntervalTracker then
			return ScrollIntervalTracker.createScrollIntervalTracker(v34, v35, p8, p9, t5)
		end

		return SocialLuaAnalytics.Performance.createScrollIntervalTracker(v34, v35, p8, p9, t5)
	end
end

return t3
