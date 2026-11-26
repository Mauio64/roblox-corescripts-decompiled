local sduiSurfaceLoadTimeTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities").SduiSurfaceLoadTimeTracker
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/TimeToInteractiveTracker").TimeToInteractiveTracker

local edpttiConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/GameDetailTelemetry").EDPTTIConstants

local EDP_TTI_EVENT_NAME = edpttiConstants.EDP_TTI_EVENT_NAME
local FIRST_MEDIA_RESOLVED = edpttiConstants.EDP_MILESTONE.FIRST_MEDIA_RESOLVED

local function createExperienceDetailsPageTimer(p2, p3)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(p2, {
		eventName = EDP_TTI_EVENT_NAME,
		metadata = p3,
		manualSurfaceReady = true,
		manualFunctionallyReady = true,
		startImmediately = true
	})

	local v5 = false
	local flag = false
	local flag2 = false
	local v6 = nil

	local trackSurfaceReady = loadTimerWithSurfaceLoadTime.trackSurfaceReady
	local function finishSurfaceReady()
		trackSurfaceReady(v6)
	end

	local function markPlayButtonReady()
		if flag2 then
			return
		end

		flag2 = true

		if flag then
			trackSurfaceReady(v6)
		end
	end

	function loadTimerWithSurfaceLoadTime.trackSurfaceReady(p4)
		if not v5 then
			v5 = true
			local mediaFound = if p4 then p4.mediaFound else nil
			local v7 = mediaFound == true and "success" or mediaFound == false and "failed" or "unknown"
			timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, FIRST_MEDIA_RESOLVED, {
				id = v7
			})
		end

		if flag then
			return
		end

		flag = true
		v6 = p4

		if flag2 then
			trackSurfaceReady(v6)
		end
	end
	loadTimerWithSurfaceLoadTime.markPlayButtonReady = markPlayButtonReady

	return loadTimerWithSurfaceLoadTime
end

return createExperienceDetailsPageTimer
