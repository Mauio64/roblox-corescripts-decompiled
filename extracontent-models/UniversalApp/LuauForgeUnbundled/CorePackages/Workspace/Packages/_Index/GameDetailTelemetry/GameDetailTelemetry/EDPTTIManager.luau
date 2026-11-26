local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailTelemetry/TimeToInteractiveTracker").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone
local PageGate = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailTelemetry/PageGate")
local fFlagEnablePLTPrefetchCallbacks = PageGate.FFlagEnablePLTPrefetchCallbacks

local EDPTTIConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameDetailTelemetry/GameDetailTelemetry/EDPTTIConstants")

local defineFastFlag = game:DefineFastFlag("EnableEDPTTIManagerColdWarmDetection", false)

local EDP_TTI_EVENT_NAME = EDPTTIConstants.EDP_TTI_EVENT_NAME
local FIRST_MEDIA_RESOLVED = EDPTTIConstants.EDP_MILESTONE.FIRST_MEDIA_RESOLVED

local flag = false
local flag2 = false
local flag3 = false

return {
	startTracking = function(p2)
		flag = false
		flag2 = false
		flag3 = false

		local v5 = timeToInteractiveTracker.getEvents(false)[EDP_TTI_EVENT_NAME]

		if not (v5 and v5.startTime) then
			timeToInteractiveTracker.trackStart(EDP_TTI_EVENT_NAME, defineFastFlag and true or nil)

			timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { page = p2 })
		end
	end,
	restartTracking = function(p2)
		flag = false
		flag2 = false
		flag3 = false

		timeToInteractiveTracker.trackStart(EDP_TTI_EVENT_NAME, defineFastFlag and true or nil)

		timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { page = p2 })
	end,
	setImplementation = function(p2)
		timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { category = p2 })
	end,
	trackFunctionallyReady = function()
		if flag then
			return
		end

		flag = true

		if timeToInteractiveTracker.trackMilestone then
			timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, milestone.FunctionallyReady)
		end

		if fFlagEnablePLTPrefetchCallbacks then
			PageGate.signal(PageGate.Page.ExperienceDetail, PageGate.Milestone.FunctionallyReady)
		end
	end,
	trackFirstMediaResolved = function(p2)
		if flag3 then
			return
		end

		flag3 = true

		if timeToInteractiveTracker.trackMilestone then
			timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, FIRST_MEDIA_RESOLVED, {
				id = p2
			})
		end
	end,
	trackSurfaceReady = function(p2)
		if flag2 then
			return
		end

		flag2 = true

		if p2 then
			timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, p2)
		end

		if timeToInteractiveTracker.trackMilestone then
			timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, milestone.SurfaceReady)
		end

		timeToInteractiveTracker.trackEnd(EDP_TTI_EVENT_NAME)
	end
}
