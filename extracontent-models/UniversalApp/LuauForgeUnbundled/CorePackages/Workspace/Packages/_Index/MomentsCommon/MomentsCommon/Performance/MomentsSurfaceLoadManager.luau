local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags")
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/TimeToInteractiveTracker").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/CaptureKind")
local eventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local fIntMomentsSurfaceLoadTTISamplingRate = SharedFlags.FIntMomentsSurfaceLoadTTISamplingRate

local count = 0
local lastTime = nil

local function computeElapsedMs()
	if lastTime == nil then
		return 0
	end

	return (os.clock() - lastTime) * 1000
end

local function abortMeasurement(p2)
	local events = timeToInteractiveTracker.getEvents()
	local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

	if not v5 then
		return
	end

	if p2 ~= nil then
		Analytics.reportMomentsSurfaceLoadAbort(p2)
	end

	timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
	lastTime = nil
end

local function scheduleCapTimeout(p2)
	local fIntMomentsSurfaceLoadTTIMaxMs = SharedFlags.FIntMomentsSurfaceLoadTTIMaxMs

	if fIntMomentsSurfaceLoadTTIMaxMs <= 0 then
		return
	end

	task.delay(fIntMomentsSurfaceLoadTTIMaxMs / 1000, function()
		if p2 == count then
			local events = timeToInteractiveTracker.getEvents()
			local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

			if v5 then
				local events2 = timeToInteractiveTracker.getEvents()
				local v6 = not (events2 == nil) and events2.Watch_MomentsFeed ~= nil

				if not v6 then
					return
				end

				Analytics.reportMomentsSurfaceLoadAbort("capped")

				timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
				lastTime = nil
			end
		end
	end)
end

return {
	EVENT_NAME = "Watch_MomentsFeed",
	start = function()
		count += 1
		lastTime = os.clock()
		timeToInteractiveTracker.trackStart("Watch_MomentsFeed", true)
		local v5 = count
		local fIntMomentsSurfaceLoadTTIMaxMs = SharedFlags.FIntMomentsSurfaceLoadTTIMaxMs

		if fIntMomentsSurfaceLoadTTIMaxMs <= 0 then
			return
		end

		task.delay(fIntMomentsSurfaceLoadTTIMaxMs / 1000, function()
			if v5 == count then
				local events = timeToInteractiveTracker.getEvents()
				local v6 = not (events == nil) and events.Watch_MomentsFeed ~= nil

				if v6 then
					local events2 = timeToInteractiveTracker.getEvents()
					local v7 = not (events2 == nil) and events2.Watch_MomentsFeed ~= nil

					if not v7 then
						return
					end

					Analytics.reportMomentsSurfaceLoadAbort("capped")

					timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
					lastTime = nil
				end
			end
		end)
	end,
	isSessionActive = function(): boolean
		local events = timeToInteractiveTracker.getEvents()
		return events ~= nil and events.Watch_MomentsFeed ~= nil
	end,
	getSessionGeneration = function()
		return count
	end,
	elapsedMs = computeElapsedMs,
	renderStarted = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", milestone.RenderStarted)
	end,
	surfaceMounted = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", milestone.SurfaceMounted)
	end,
	primaryDataStarted = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", milestone.PrimaryDataStarted.Name)
	end,
	primaryDataNetworkFetch = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackSubphase(
			"Watch_MomentsFeed",
			milestone.PrimaryDataStarted.Name,
			milestone.PrimaryDataStarted.Subphase.NetworkFetch
		)
	end,
	primaryDataResponseReceived = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackSubphase(
			"Watch_MomentsFeed",
			milestone.PrimaryDataStarted.Name,
			milestone.PrimaryDataStarted.Subphase.ResponseReceived
		)
	end,
	primaryDataReady = function()
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", milestone.PrimaryDataReady.Name)
	end,
	markSurfaceReady = function(p2)
		local events = timeToInteractiveTracker.getEvents()
		local v5 = not (events == nil) and events.Watch_MomentsFeed ~= nil

		if not v5 then
			return
		end

		local v6 = lastTime == nil and 0 or (os.clock() - lastTime) * 1000

		local fIntMomentsSurfaceLoadTTIMaxMs = SharedFlags.FIntMomentsSurfaceLoadTTIMaxMs

		if fIntMomentsSurfaceLoadTTIMaxMs > 0 and fIntMomentsSurfaceLoadTTIMaxMs < v6 then
			local events2 = timeToInteractiveTracker.getEvents()
			local v7 = not (events2 == nil) and events2.Watch_MomentsFeed ~= nil

			if not v7 then
				return
			end

			Analytics.reportMomentsSurfaceLoadAbort("capped")

			timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
			lastTime = nil
		else
			if p2 ~= nil then
				timeToInteractiveTracker.updateMetadata("Watch_MomentsFeed", {
					subcategory = p2
				})
			end

			timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", milestone.SurfaceReady)
			timeToInteractiveTracker.trackEnd("Watch_MomentsFeed", {
				samplingRateOverride = fIntMomentsSurfaceLoadTTISamplingRate
			})

			fireAnalyticsEvent(eventNames.MomentsFirstContentLoadedTimestamp, {
				value = v6
			})
			lastTime = nil
		end
	end,
	abort = abortMeasurement
}
