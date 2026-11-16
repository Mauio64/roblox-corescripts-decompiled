local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local SharedFlags = require(parent.SharedFlags)
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Milestone = timeToInteractiveTracker.Milestone

local Analytics = require(MomentsCommon.Analytics)
require(MomentsCommon.Enums.CaptureKind)
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent
local FIntMomentsSurfaceLoadTTISamplingRate = SharedFlags.FIntMomentsSurfaceLoadTTISamplingRate

local count = 0
local lastTime = nil

local function isSessionActive(): boolean -- 11 equivalent calls inferred from this helper
	local events = timeToInteractiveTracker.getEvents()
	return events ~= nil and events.Watch_MomentsFeed ~= nil
end

local function computeElapsedMs() -- 1 equivalent call inferred from this helper
	if lastTime == nil then
		return 0
	end

	return (os.clock() - lastTime) * 1000
end

local function abortMeasurement(p)
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	if p ~= nil then
		Analytics.reportMomentsSurfaceLoadAbort(p)
	end

	timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
	lastTime = nil
end

local function scheduleCapTimeout(count2: number) -- 1 equivalent call inferred from this helper
	local fIntMomentsSurfaceLoadTTIMaxMs = SharedFlags.FIntMomentsSurfaceLoadTTIMaxMs

	if fIntMomentsSurfaceLoadTTIMaxMs <= 0 then
		return
	end

	task.delay(fIntMomentsSurfaceLoadTTIMaxMs / 1000, function()
		if count2 == count and isSessionActive() then -- inferred equivalent call
			if not isSessionActive() then -- inferred equivalent call
				return
			end

			Analytics.reportMomentsSurfaceLoadAbort("capped")

			timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
			lastTime = nil
		end
	end)
end

local MomentsSurfaceLoadManager = {}
MomentsSurfaceLoadManager.EVENT_NAME = "Watch_MomentsFeed"

function MomentsSurfaceLoadManager.start()
	count += 1
	lastTime = os.clock()
	timeToInteractiveTracker.trackStart("Watch_MomentsFeed", true)
	scheduleCapTimeout(count) -- inferred equivalent call
end

MomentsSurfaceLoadManager.isSessionActive = isSessionActive

function MomentsSurfaceLoadManager.getSessionGeneration()
	return count
end

MomentsSurfaceLoadManager.elapsedMs = computeElapsedMs

function MomentsSurfaceLoadManager.renderStarted()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.RenderStarted)
end

function MomentsSurfaceLoadManager.surfaceMounted()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.SurfaceMounted)
end

function MomentsSurfaceLoadManager.primaryDataStarted()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.PrimaryDataStarted.Name)
end

function MomentsSurfaceLoadManager.primaryDataNetworkFetch()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackSubphase(
		"Watch_MomentsFeed",
		Milestone.PrimaryDataStarted.Name,
		Milestone.PrimaryDataStarted.Subphase.NetworkFetch
	)
end

function MomentsSurfaceLoadManager.primaryDataResponseReceived()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackSubphase(
		"Watch_MomentsFeed",
		Milestone.PrimaryDataStarted.Name,
		Milestone.PrimaryDataStarted.Subphase.ResponseReceived
	)
end

function MomentsSurfaceLoadManager.primaryDataReady()
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.PrimaryDataReady.Name)
end

function MomentsSurfaceLoadManager.markSurfaceReady(subcategory)
	if not isSessionActive() then -- inferred equivalent call
		return
	end

	local elapsedMs = computeElapsedMs() -- inferred equivalent call
	local fIntMomentsSurfaceLoadTTIMaxMs = SharedFlags.FIntMomentsSurfaceLoadTTIMaxMs

	if fIntMomentsSurfaceLoadTTIMaxMs > 0 and fIntMomentsSurfaceLoadTTIMaxMs < elapsedMs then
		if not isSessionActive() then -- inferred equivalent call
			return
		end

		Analytics.reportMomentsSurfaceLoadAbort("capped")

		timeToInteractiveTracker.destroyEvent("Watch_MomentsFeed")
	else
		if subcategory ~= nil then
			timeToInteractiveTracker.updateMetadata("Watch_MomentsFeed", {
				subcategory = subcategory
			})
		end

		timeToInteractiveTracker.trackMilestone("Watch_MomentsFeed", Milestone.SurfaceReady)
		timeToInteractiveTracker.trackEnd("Watch_MomentsFeed", {
			samplingRateOverride = FIntMomentsSurfaceLoadTTISamplingRate
		})

		fireAnalyticsEvent(EventNames.MomentsFirstContentLoadedTimestamp, { value = elapsedMs })
	end

	lastTime = nil
end

MomentsSurfaceLoadManager.abort = abortMeasurement
return MomentsSurfaceLoadManager
