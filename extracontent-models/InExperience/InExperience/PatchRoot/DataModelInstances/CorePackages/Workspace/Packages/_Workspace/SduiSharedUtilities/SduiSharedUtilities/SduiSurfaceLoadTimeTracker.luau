local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent

local SduiLoadTimer = require(SduiSharedUtilities.SduiLoadTimer)
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
require(SduiSharedUtilities.SduiPageAnalytics)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SharedFlags = require(parent.SharedFlags)
local FFlagEDPTTIParityDefinitions = SharedFlags.FFlagEDPTTIParityDefinitions

local Milestone = timeToInteractiveTracker.Milestone

return {
	createLoadTimerWithSurfaceLoadTime = function(p: string, data, callback)
		local eventName = data.eventName
		local manualSurfaceReady = data.manualSurfaceReady == true

		local v = FFlagEDPTTIParityDefinitions and data.manualFunctionallyReady == true
		local loadTimer = SduiLoadTimer.createLoadTimer(p, callback)

		local v2 = false
		local set = {}

		local function trackOnce(p2: string) -- 8 equivalent calls inferred from this helper
			if not set[p2] then
				set[p2] = true
				timeToInteractiveTracker.trackMilestone(eventName, p2)
			end
		end

		local function trackSurfaceReady(p2) -- 1 equivalent call inferred from this helper
			if set[Milestone.SurfaceReady] then
				return
			end

			if p2 then
				timeToInteractiveTracker.updateMetadata(eventName, p2)
			end

			trackOnce(Milestone.SurfaceReady) -- inferred equivalent call
			timeToInteractiveTracker.trackEnd(eventName)
		end

		local function ensureStarted() -- 4 equivalent calls inferred from this helper
			if not v2 then
				v2 = true
				timeToInteractiveTracker.trackStart(eventName, true)

				if data.metadata then
					timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
				end
			end
		end

		local function logRenderStarted()
			ensureStarted() -- inferred equivalent call
			trackOnce(Milestone.RenderStarted) -- inferred equivalent call
		end

		local logUiRequestSent = loadTimer.logUiRequestSent
		function loadTimer.logUiRequestSent()
			logUiRequestSent()
			ensureStarted() -- inferred equivalent call
			trackOnce(Milestone.PrimaryDataStarted.Name) -- inferred equivalent call
		end

		local logUiRequestQueued = loadTimer.logUiRequestQueued
		function loadTimer.logUiRequestQueued()
			logUiRequestQueued()
			ensureStarted() -- inferred equivalent call
		end

		local logResponseDecodeBegin = loadTimer.logResponseDecodeBegin
		function loadTimer.logResponseDecodeBegin()
			logResponseDecodeBegin()
			trackOnce(Milestone.PrimaryDataReady.Name) -- inferred equivalent call
			trackOnce(Milestone.DataProcessingStarted.Name) -- inferred equivalent call
		end

		local logComponentMounted = loadTimer.logComponentMounted
		function loadTimer.logComponentMounted()
			logComponentMounted()
			trackOnce(Milestone.SurfaceMounted) -- inferred equivalent call
		end

		local logComponentReady = loadTimer.logComponentReady
		function loadTimer.logComponentReady()
			trackOnce(Milestone.DataProcessingCompleted.Name) -- inferred equivalent call
			logComponentReady()

			if not v then
				trackOnce(Milestone.FunctionallyReady) -- inferred equivalent call
			end

			if not manualSurfaceReady then
				trackSurfaceReady() -- inferred equivalent call
			end
		end

		loadTimer.logRenderStarted = logRenderStarted
		loadTimer.trackOnce = trackOnce
		loadTimer.trackSurfaceReady = trackSurfaceReady
		loadTimer.surfaceLoadTimeEventName = eventName
		getSduiClientPageScope(p).set("__sduiSurfaceLoadTimeTracker", loadTimer)

		if FFlagEDPTTIParityDefinitions and data.startImmediately == true then
			ensureStarted() -- inferred equivalent call
		end

		return loadTimer
	end,
	SURFACE_LOAD_TIME_PAGE_SCOPE_KEY = "__sduiSurfaceLoadTimeTracker"
}
