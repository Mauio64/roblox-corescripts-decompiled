local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local SharedFlags = require(MomentsCommonParent.SharedFlags)
local TimeToInteractiveTracker = require(MomentsCommonParent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local Analytics = require(MomentsCommon.Analytics)
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local FIntMomentsSurfaceLoadTTISamplingRate = SharedFlags.FIntMomentsSurfaceLoadTTISamplingRate
local n1 = 0
local elapsed = nil

local function computeElapsedMs() -- line: 29
	-- upvalues: elapsed (ref)
	if elapsed == nil then
		return 0
	end

	return (os.clock() - elapsed) * 1000
end

return {
	EVENT_NAME = "Watch_MomentsFeed",
	start = function() -- line: 39
		-- upvalues: n1 (ref), elapsed (ref), TimeToInteractiveTracker (copy)
		n1 += 1
		elapsed = os.clock()
		TimeToInteractiveTracker.trackStart("Watch_MomentsFeed", true)
	end,
	isSessionActive = function() -- line: 24
		-- upvalues: TimeToInteractiveTracker (copy)
		local v13 = TimeToInteractiveTracker.getEvents()

		return v13 ~= nil and v13.Watch_MomentsFeed ~= nil
	end,
	getSessionGeneration = function() -- line: 47
		-- upvalues: n1 (ref)
		return n1
	end,
	elapsedMs = computeElapsedMs,
	renderStarted = function() -- line: 53
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v14 = TimeToInteractiveTracker.getEvents()

		if v14 == nil or v14.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.RenderStarted)
	end,
	surfaceMounted = function() -- line: 60
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v15 = TimeToInteractiveTracker.getEvents()

		if v15 == nil or v15.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.SurfaceMounted)
	end,
	primaryDataStarted = function() -- line: 67
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v16 = TimeToInteractiveTracker.getEvents()

		if v16 == nil or v16.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.PrimaryDataStarted.Name)
	end,
	primaryDataNetworkFetch = function() -- line: 74
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v17 = TimeToInteractiveTracker.getEvents()

		if v17 == nil or v17.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackSubphase("Watch_MomentsFeed", Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.NetworkFetch)
	end,
	primaryDataResponseReceived = function() -- line: 85
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v18 = TimeToInteractiveTracker.getEvents()

		if v18 == nil or v18.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackSubphase("Watch_MomentsFeed", Milestone.PrimaryDataStarted.Name, Milestone.PrimaryDataStarted.Subphase.ResponseReceived)
	end,
	primaryDataReady = function() -- line: 96
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy)
		local v19 = TimeToInteractiveTracker.getEvents()

		if v19 == nil or v19.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.PrimaryDataReady.Name)
	end,
	markSurfaceReady = function() -- line: 103
		-- upvalues: TimeToInteractiveTracker (copy), Milestone (copy), FIntMomentsSurfaceLoadTTISamplingRate (copy), fireAnalyticsEvent (copy), EventNames (copy), elapsed (ref)
		local v20 = TimeToInteractiveTracker.getEvents()

		if v20 == nil or v20.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.SurfaceReady)
		TimeToInteractiveTracker.trackEnd("Watch_MomentsFeed", {
			samplingRateOverride = FIntMomentsSurfaceLoadTTISamplingRate
		})
		fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, {
			value = if elapsed ~= nil then (os.clock() - elapsed) * 1000 else 0
		})
		elapsed = nil
	end,
	abort = function() -- line: 119
		-- upvalues: TimeToInteractiveTracker (copy), elapsed (ref)
		local v21 = TimeToInteractiveTracker.getEvents()

		if v21 == nil or v21.Watch_MomentsFeed == nil then
			return
		end

		TimeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
		elapsed = nil
	end
}
