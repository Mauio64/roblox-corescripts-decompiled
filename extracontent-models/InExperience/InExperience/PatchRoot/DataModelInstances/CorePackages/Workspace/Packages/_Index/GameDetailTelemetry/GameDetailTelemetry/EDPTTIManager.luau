local parent = script:FindFirstAncestor("GameDetailTelemetry").Parent

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local Milestone = timeToInteractiveTracker.Milestone
local PageGate = require(parent.PageGate)
local FFlagEnablePLTPrefetchCallbacks = PageGate.FFlagEnablePLTPrefetchCallbacks

local EDPTTIConstants = require(script.Parent.EDPTTIConstants)

local defineFastFlag = game:DefineFastFlag("EnableEDPTTIManagerColdWarmDetection", false)

local EDP_TTI_EVENT_NAME = EDPTTIConstants.EDP_TTI_EVENT_NAME
local FIRST_MEDIA_RESOLVED = EDPTTIConstants.EDP_MILESTONE.FIRST_MEDIA_RESOLVED

local flag = false
local flag2 = false
local flag3 = false
local EDPTTIManager = {}

function EDPTTIManager.startTracking(page: string)
	flag = false
	flag2 = false
	flag3 = false

	local v = timeToInteractiveTracker.getEvents(false)[EDP_TTI_EVENT_NAME]

	if not (v and v.startTime) then
		timeToInteractiveTracker.trackStart(EDP_TTI_EVENT_NAME, defineFastFlag and true or nil)

		timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { page = page })
	end
end

function EDPTTIManager.restartTracking(page: string)
	flag = false
	flag2 = false
	flag3 = false

	timeToInteractiveTracker.trackStart(EDP_TTI_EVENT_NAME, defineFastFlag and true or nil)

	timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { page = page })
end

function EDPTTIManager.setImplementation(category: string)
	timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, { category = category })
end

function EDPTTIManager.trackFunctionallyReady()
	if flag then
		return
	end

	flag = true

	if timeToInteractiveTracker.trackMilestone then
		timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, Milestone.FunctionallyReady)
	end

	if FFlagEnablePLTPrefetchCallbacks then
		PageGate.signal(PageGate.Page.ExperienceDetail, PageGate.Milestone.FunctionallyReady)
	end
end

function EDPTTIManager.trackFirstMediaResolved(id: string)
	if flag3 then
		return
	end

	flag3 = true

	if timeToInteractiveTracker.trackMilestone then
		timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, FIRST_MEDIA_RESOLVED, {
			id = id
		})
	end
end

function EDPTTIManager.trackSurfaceReady(p)
	if flag2 then
		return
	end

	flag2 = true

	if p then
		timeToInteractiveTracker.updateMetadata(EDP_TTI_EVENT_NAME, p)
	end

	if timeToInteractiveTracker.trackMilestone then
		timeToInteractiveTracker.trackMilestone(EDP_TTI_EVENT_NAME, Milestone.SurfaceReady)
	end

	timeToInteractiveTracker.trackEnd(EDP_TTI_EVENT_NAME)
end

return EDPTTIManager
