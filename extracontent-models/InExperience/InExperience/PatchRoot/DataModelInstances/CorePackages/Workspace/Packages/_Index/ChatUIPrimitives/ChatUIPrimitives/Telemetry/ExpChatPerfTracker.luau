local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local intervalPerformanceTracker = IntervalPerformanceTracker.IntervalPerformanceTracker
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Lumberyak = require(parent.Lumberyak)
local logger = Lumberyak.Logger.new(nil, "ExpChatPerfTracker")

local ExpChatPerfEventConfig = require(script.Parent.ExpChatPerfEventConfig)
local EventTypes = ExpChatPerfEventConfig.EventTypes
local Events = ExpChatPerfEventConfig.Events
local EventConfig = ExpChatPerfEventConfig.EventConfig

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local ScrollIntervalTracker = require(parent.ScrollIntervalTracker)
local FFlagExpChatMigrateScrollIntervalTracker = require(ChatUIPrimitives.Flags.FFlagExpChatMigrateScrollIntervalTracker)
local FFlagExpChatPerfTrackerTabName = require(ChatUIPrimitives.Flags.FFlagExpChatPerfTrackerTabName)

local ExpChatPerfTracker = {
	["start"] = nil,
	["start"] = nil,
	start = function(p, p2, p3): boolean
		local v = EventConfig[p] or {}

		if v.type == EventTypes.TTI then
			v.onStart(p2)
			timeToInteractiveTracker.trackStart(v.baseName)

			if FFlagExpChatPerfTrackerTabName and p3 and p3.tabName then
				timeToInteractiveTracker.updateMetadata(v.baseName, { page = p3.tabName })
			end
		else
			if v.type ~= EventTypes.Interval then
				logger:warning(`ExpChatPerfTracker.start: unknown event type for event: {p}`)
				return false
			end

			if not v.canStart(p2) then
				return false
			end

			intervalPerformanceTracker:cancelTracking(v.name)
			v.onStart(p2)

			if FFlagExpChatPerfTrackerTabName and p3 then
				intervalPerformanceTracker:startTracking(v.name, nil, v.intervalMetrics, true, true, p3)
			else
				intervalPerformanceTracker:startTracking(v.name, nil, v.intervalMetrics, true, true)
			end
		end

		return true
	end,
	finish = function(p, p2, p3)
		local v = EventConfig[p] or {}

		if v.type == EventTypes.TTI then
			if not v.canFinish(p2) then
				return
			end

			if FFlagExpChatPerfTrackerTabName and p3 and p3.tabName then
				timeToInteractiveTracker.updateMetadata(v.baseName, { page = p3.tabName })
			end

			timeToInteractiveTracker.trackEnd(v.baseName)
		else
			if v.type ~= EventTypes.Interval then
				logger:warning(`ExpChatPerfTracker.finish: unknown event type for event: {p}`)

				return
			end

			if not v.canFinish(p2) then
				return
			end

			if FFlagExpChatPerfTrackerTabName and p3 then
				logger:warning("Unable to update finished interval extra fields")
			end

			v.onFinish(p2)
			intervalPerformanceTracker:stopAndLogTracking(v.name)
		end
	end,
	cancel = function(p, p2)
		local v = EventConfig[p] or {}

		if v.type == EventTypes.TTI then
			timeToInteractiveTracker.resetEvent(v.baseName)
			return
		end

		if v.type ~= EventTypes.Interval then
			logger:warning(`ExpChatPerfTracker.cancel: unknown event type for event: {p}`)

			return
		end

		v.onFinish(p2)
		intervalPerformanceTracker:cancelTracking(v.name)
	end
}

function ExpChatPerfTracker.cancelAll()
	for k, _ in EventConfig do
		ExpChatPerfTracker.cancel(k)
	end
end

ExpChatPerfTracker.Events = Events
function ExpChatPerfTracker.startChatWindowScrollInterval(debugName, p, p2, p3)
	local v = { debugName = debugName }

	local function fn(p4)
		return ExpChatPerfTracker.start(debugName, p4, p3)
	end

	local function fn2(p4)
		ExpChatPerfTracker.finish(debugName, p4)
	end

	if FFlagExpChatMigrateScrollIntervalTracker then
		return ScrollIntervalTracker.createScrollIntervalTracker(fn, fn2, p, p2, v)
	end

	return SocialLuaAnalytics.Performance.createScrollIntervalTracker(fn, fn2, p, p2, v)
end

return ExpChatPerfTracker
