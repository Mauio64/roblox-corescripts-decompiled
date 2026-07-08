local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local SduiLoadTimer = require(SduiSharedUtilities.SduiLoadTimer)
local TimeToInteractiveTracker = require(SduiSharedUtilitiesParent.TimeToInteractiveTracker).TimeToInteractiveTracker

require(SduiSharedUtilities.SduiPageAnalytics)

local getSduiClientPageScope = require(SduiSharedUtilitiesParent.SduiCoreSystem).getSduiClientPageScope
local Milestone = TimeToInteractiveTracker.Milestone

return {
	SURFACE_LOAD_TIME_PAGE_SCOPE_KEY = "__sduiSurfaceLoadTimeTracker",
	createLoadTimerWithSurfaceLoadTime = function(s1: string, t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 48
		-- upvalues: SduiLoadTimer (copy), TimeToInteractiveTracker (copy), Milestone (copy), getSduiClientPageScope (copy)
		local eventName = t1.eventName
		local v11 = t1.manualSurfaceReady == true
		local v12 = SduiLoadTimer.createLoadTimer(s1, p1)
		local u13 = false
		local t2 = {}

		local function ensureStarted() -- line: 82
			-- upvalues: u13 (ref), TimeToInteractiveTracker (copy), eventName (copy), t1 (copy)
			if not u13 then
				u13 = true
				TimeToInteractiveTracker.trackStart(eventName, true)

				if t1.metadata then
					TimeToInteractiveTracker.updateMetadata(eventName, t1.metadata)
				end
			end
		end

		local logUiRequestSent = v12.logUiRequestSent

		function v12.logUiRequestSent() -- line: 94
			-- upvalues: logUiRequestSent (copy), u13 (ref), TimeToInteractiveTracker (copy), eventName (copy), t1 (copy), Milestone (copy), t2 (copy)
			logUiRequestSent()

			if not u13 then
				u13 = true
				TimeToInteractiveTracker.trackStart(eventName, true)

				if t1.metadata then
					TimeToInteractiveTracker.updateMetadata(eventName, t1.metadata)
				end
			end

			local PrimaryDataStartedName = Milestone.PrimaryDataStarted.Name

			if not t2[PrimaryDataStartedName] then
				t2[PrimaryDataStartedName] = true
				TimeToInteractiveTracker.trackMilestone(eventName, PrimaryDataStartedName)
			end
		end

		local logUiRequestQueued = v12.logUiRequestQueued

		function v12.logUiRequestQueued() -- line: 101
			-- upvalues: logUiRequestQueued (copy), u13 (ref), TimeToInteractiveTracker (copy), eventName (copy), t1 (copy)
			logUiRequestQueued()

			if not u13 then
				u13 = true
				TimeToInteractiveTracker.trackStart(eventName, true)

				if t1.metadata then
					TimeToInteractiveTracker.updateMetadata(eventName, t1.metadata)
				end
			end
		end

		local logResponseDecodeBegin = v12.logResponseDecodeBegin

		function v12.logResponseDecodeBegin() -- line: 107
			-- upvalues: logResponseDecodeBegin (copy), Milestone (copy), t2 (copy), TimeToInteractiveTracker (copy), eventName (copy)
			logResponseDecodeBegin()

			local PrimaryDataReadyName = Milestone.PrimaryDataReady.Name

			if not t2[PrimaryDataReadyName] then
				t2[PrimaryDataReadyName] = true
				TimeToInteractiveTracker.trackMilestone(eventName, PrimaryDataReadyName)
			end

			local DataProcessingStartedName = Milestone.DataProcessingStarted.Name

			if not t2[DataProcessingStartedName] then
				t2[DataProcessingStartedName] = true
				TimeToInteractiveTracker.trackMilestone(eventName, DataProcessingStartedName)
			end
		end

		local logComponentMounted = v12.logComponentMounted

		function v12.logComponentMounted() -- line: 115
			-- upvalues: logComponentMounted (copy), Milestone (copy), t2 (copy), TimeToInteractiveTracker (copy), eventName (copy)
			logComponentMounted()

			local SurfaceMounted = Milestone.SurfaceMounted

			if not t2[SurfaceMounted] then
				t2[SurfaceMounted] = true
				TimeToInteractiveTracker.trackMilestone(eventName, SurfaceMounted)
			end
		end

		local logComponentReady = v12.logComponentReady

		function v12.logComponentReady() -- line: 121
			-- upvalues: Milestone (copy), t2 (copy), TimeToInteractiveTracker (copy), eventName (copy), logComponentReady (copy), v11 (copy)
			local DataProcessingCompletedName = Milestone.DataProcessingCompleted.Name

			if not t2[DataProcessingCompletedName] then
				t2[DataProcessingCompletedName] = true
				TimeToInteractiveTracker.trackMilestone(eventName, DataProcessingCompletedName)
			end

			logComponentReady()

			local FunctionallyReady = Milestone.FunctionallyReady

			if not t2[FunctionallyReady] then
				t2[FunctionallyReady] = true
				TimeToInteractiveTracker.trackMilestone(eventName, FunctionallyReady)
			end

			if not v11 then
				if t2[Milestone.SurfaceReady] then
					return
				end

				local SurfaceReady = Milestone.SurfaceReady

				if not t2[SurfaceReady] then
					t2[SurfaceReady] = true
					TimeToInteractiveTracker.trackMilestone(eventName, SurfaceReady)
				end

				TimeToInteractiveTracker.trackEnd(eventName)
			end
		end
		function v12.trackOnce(s2: string) -- line: 61
			-- upvalues: t2 (copy), TimeToInteractiveTracker (copy), eventName (copy)
			if not t2[s2] then
				t2[s2] = true
				TimeToInteractiveTracker.trackMilestone(eventName, s2)
			end
		end
		function v12.trackSurfaceReady(t3: {[any]: any}?) -- line: 68
			-- upvalues: t2 (copy), Milestone (copy), TimeToInteractiveTracker (copy), eventName (copy)
			if t2[Milestone.SurfaceReady] then
				return
			end

			if t3 then
				TimeToInteractiveTracker.updateMetadata(eventName, t3)
			end

			local SurfaceReady = Milestone.SurfaceReady

			if not t2[SurfaceReady] then
				t2[SurfaceReady] = true
				TimeToInteractiveTracker.trackMilestone(eventName, SurfaceReady)
			end

			TimeToInteractiveTracker.trackEnd(eventName)
		end

		v12.surfaceLoadTimeEventName = eventName
		getSduiClientPageScope(s1).set("__sduiSurfaceLoadTimeTracker", v12)

		return v12
	end
}
