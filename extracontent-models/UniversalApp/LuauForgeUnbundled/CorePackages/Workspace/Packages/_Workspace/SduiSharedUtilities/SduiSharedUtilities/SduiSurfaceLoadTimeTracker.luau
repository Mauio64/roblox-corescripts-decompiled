local SduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiLoadTimer")
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/TimeToInteractiveTracker").TimeToInteractiveTracker
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiPageAnalytics")
local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiClientPageScope
local fFlagEDPTTIParityDefinitions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SharedFlags").FFlagEDPTTIParityDefinitions

local milestone = timeToInteractiveTracker.Milestone

return {
	createLoadTimerWithSurfaceLoadTime = function(p2, data, p3)
		local eventName = data.eventName
		local manualSurfaceReady = data.manualSurfaceReady == true

		local v5 = fFlagEDPTTIParityDefinitions and data.manualFunctionallyReady == true
		local loadTimer = SduiLoadTimer.createLoadTimer(p2, p3)

		local v6 = false
		local set = {}

		local function ensureStarted()
			if not v6 then
				v6 = true
				timeToInteractiveTracker.trackStart(eventName, true)

				if data.metadata then
					timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
				end
			end
		end

		local function logRenderStarted()
			if not v6 then
				v6 = true
				timeToInteractiveTracker.trackStart(eventName, true)

				if data.metadata then
					timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
				end
			end

			local renderStarted = milestone.RenderStarted

			if not set[renderStarted] then
				set[renderStarted] = true
				timeToInteractiveTracker.trackMilestone(eventName, renderStarted)
			end
		end

		local logUiRequestSent = loadTimer.logUiRequestSent
		function loadTimer.logUiRequestSent()
			logUiRequestSent()

			if not v6 then
				v6 = true
				timeToInteractiveTracker.trackStart(eventName, true)

				if data.metadata then
					timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
				end
			end

			local name = milestone.PrimaryDataStarted.Name

			if not set[name] then
				set[name] = true
				timeToInteractiveTracker.trackMilestone(eventName, name)
			end
		end

		local logUiRequestQueued = loadTimer.logUiRequestQueued
		function loadTimer.logUiRequestQueued()
			logUiRequestQueued()

			if not v6 then
				v6 = true
				timeToInteractiveTracker.trackStart(eventName, true)

				if data.metadata then
					timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
				end
			end
		end

		local logResponseDecodeBegin = loadTimer.logResponseDecodeBegin
		function loadTimer.logResponseDecodeBegin()
			logResponseDecodeBegin()
			local name = milestone.PrimaryDataReady.Name

			if not set[name] then
				set[name] = true
				timeToInteractiveTracker.trackMilestone(eventName, name)
			end

			local name2 = milestone.DataProcessingStarted.Name

			if not set[name2] then
				set[name2] = true
				timeToInteractiveTracker.trackMilestone(eventName, name2)
			end
		end

		local logComponentMounted = loadTimer.logComponentMounted
		function loadTimer.logComponentMounted()
			logComponentMounted()
			local surfaceMounted = milestone.SurfaceMounted

			if not set[surfaceMounted] then
				set[surfaceMounted] = true
				timeToInteractiveTracker.trackMilestone(eventName, surfaceMounted)
			end
		end

		local logComponentReady = loadTimer.logComponentReady
		function loadTimer.logComponentReady()
			local name = milestone.DataProcessingCompleted.Name

			if not set[name] then
				set[name] = true
				timeToInteractiveTracker.trackMilestone(eventName, name)
			end

			logComponentReady()

			if not v5 then
				local functionallyReady = milestone.FunctionallyReady

				if not set[functionallyReady] then
					set[functionallyReady] = true
					timeToInteractiveTracker.trackMilestone(eventName, functionallyReady)
				end
			end

			if not manualSurfaceReady then
				if set[milestone.SurfaceReady] then
					return
				end

				local surfaceReady = milestone.SurfaceReady

				if not set[surfaceReady] then
					set[surfaceReady] = true
					timeToInteractiveTracker.trackMilestone(eventName, surfaceReady)
				end

				timeToInteractiveTracker.trackEnd(eventName)
			end
		end

		loadTimer.logRenderStarted = logRenderStarted

		function loadTimer.trackOnce(p4)
			if not set[p4] then
				set[p4] = true
				timeToInteractiveTracker.trackMilestone(eventName, p4)
			end
		end

		function loadTimer.trackSurfaceReady(p4)
			if set[milestone.SurfaceReady] then
				return
			end

			if p4 then
				timeToInteractiveTracker.updateMetadata(eventName, p4)
			end

			local surfaceReady = milestone.SurfaceReady

			if not set[surfaceReady] then
				set[surfaceReady] = true
				timeToInteractiveTracker.trackMilestone(eventName, surfaceReady)
			end

			timeToInteractiveTracker.trackEnd(eventName)
		end
		loadTimer.surfaceLoadTimeEventName = eventName
		getSduiClientPageScope(p2).set("__sduiSurfaceLoadTimeTracker", loadTimer)

		if not fFlagEDPTTIParityDefinitions or data.startImmediately ~= true or v6 then
			return loadTimer
		end

		v6 = true
		timeToInteractiveTracker.trackStart(eventName, true)

		if data.metadata then
			timeToInteractiveTracker.updateMetadata(eventName, data.metadata)
		end

		return loadTimer
	end,
	SURFACE_LOAD_TIME_PAGE_SCOPE_KEY = "__sduiSurfaceLoadTimeTracker"
}
