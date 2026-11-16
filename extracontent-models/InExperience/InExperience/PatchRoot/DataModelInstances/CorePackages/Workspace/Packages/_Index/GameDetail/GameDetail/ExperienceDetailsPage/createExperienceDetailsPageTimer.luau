local parent = script:FindFirstAncestor("GameDetail").Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker

local GameDetailTelemetry = require(parent.GameDetailTelemetry)
local EDPTTIConstants = GameDetailTelemetry.EDPTTIConstants

local EDP_TTI_EVENT_NAME = EDPTTIConstants.EDP_TTI_EVENT_NAME
local FIRST_MEDIA_RESOLVED = EDPTTIConstants.EDP_MILESTONE.FIRST_MEDIA_RESOLVED

local function createExperienceDetailsPageTimer(p: string, metadata)
	local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(p, {
		eventName = EDP_TTI_EVENT_NAME,
		metadata = metadata,
		manualSurfaceReady = true,
		manualFunctionallyReady = true,
		startImmediately = true
	})

	local v = false
	local flag = false
	local flag2 = false
	local v2 = nil

	local trackSurfaceReady = loadTimerWithSurfaceLoadTime.trackSurfaceReady
	local function finishSurfaceReady() -- 2 equivalent calls inferred from this helper
		trackSurfaceReady(v2)
	end

	local function markPlayButtonReady()
		if flag2 then
			return
		end

		flag2 = true

		if flag then
			finishSurfaceReady() -- inferred equivalent call
		end
	end

	function loadTimerWithSurfaceLoadTime.trackSurfaceReady(p2)
		if not v then
			v = true
			local mediaFound

			if p2 then
				mediaFound = p2.mediaFound
			end

			local id = mediaFound == true and "success" or mediaFound == false and "failed" or "unknown"
			timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, FIRST_MEDIA_RESOLVED, {
				id = id
			})
		end

		if flag then
			return
		end

		flag = true
		v2 = p2

		if flag2 then
			finishSurfaceReady() -- inferred equivalent call
		end
	end
	loadTimerWithSurfaceLoadTime.markPlayButtonReady = markPlayButtonReady

	return loadTimerWithSurfaceLoadTime
end

return createExperienceDetailsPageTimer
