local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTTIRecordWebViewMilestones = SharedFlags.FFlagEnableTTIRecordWebViewMilestones
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppNavTTIMeasurementV2 = SharedFlags2.FFlagLuaAppNavTTIMeasurementV2
local FFlagTTITrackerDropEventsOnAppHide = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerDropEventsOnAppHide)
local getAppLifecycleObserverService = require(TimeToInteractiveTracker.Utils.getAppLifecycleObserverService)
local FFlagTTITrackerDropEventsOnJoinAttempt = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerDropEventsOnJoinAttempt)
local getOnNewJoinAttempt = require(TimeToInteractiveTracker.Utils.getOnNewJoinAttempt)

local updateTTIEventMetadata = require(script.Parent.Actions.updateTTIEventMetadata)
local trackTTIEventStart = require(script.Parent.Actions.trackTTIEventStart)
local trackTTIEventEnd = require(script.Parent.Actions.trackTTIEventEnd)
local trackMilestone = require(script.Parent.Actions.trackMilestone)
local trackSubphase = require(script.Parent.Actions.trackSubphase)
local trackRequest = require(script.Parent.Actions.trackRequest)
local recordWebViewMilestones = require(script.Parent.Actions.recordWebViewMilestones)
local resetTTIEvent = require(script.Parent.Actions.resetTTIEvent)
local destroyTTIEvent = require(script.Parent.Actions.destroyTTIEvent)
local dropInFlightTTIEvents = require(script.Parent.Actions.dropInFlightTTIEvents)
local discardOlderNavigationStarts = require(script.Parent.Actions.discardOlderNavigationStarts)

local logTTIDiscard = require(TimeToInteractiveTracker.Utils.logTTIDiscard)
local hasNavigationCommitted = require(TimeToInteractiveTracker.Utils.hasNavigationCommitted)
local constants = require(TimeToInteractiveTracker.Milestones.constants)
local navigationEventPrefix = require(TimeToInteractiveTracker.Utils.navigationEventPrefix)
local useTTIRenderAndMountedTracking = require(TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking)

require(script.Parent.types)

return function()
	local signal, setEvents = createSignal({})

	local v = {}
	local trackEnd, trackEndAtNextFrame = trackTTIEventEnd(setEvents, v)

	if FFlagTTITrackerDropEventsOnAppHide then
		local appLifecycleObserverService = getAppLifecycleObserverService()

		if FFlagLuaAppNavTTIMeasurementV2 and appLifecycleObserverService then
			local v2 = dropInFlightTTIEvents(setEvents)
			appLifecycleObserverService.OnHide:Connect(function()
				local v3 = signal(false)

				for _, v4 in v2() do
					if hasNavigationCommitted(v3[v4]) then
						logTTIDiscard(v4, "backgrounded")
					end
				end
			end)
		elseif appLifecycleObserverService then
			appLifecycleObserverService.OnHide:Connect(dropInFlightTTIEvents(setEvents))
		end
	end

	if FFlagTTITrackerDropEventsOnJoinAttempt then
		local v2 = getOnNewJoinAttempt()

		if FFlagLuaAppNavTTIMeasurementV2 and v2 then
			local v3 = dropInFlightTTIEvents(setEvents)
			v2:Connect(function()
				local v4 = signal(false)

				for _, v5 in v3() do
					if hasNavigationCommitted(v4[v5]) then
						logTTIDiscard(v5, "joinAttempt")
					end
				end
			end)
		elseif v2 then
			v2:Connect(dropInFlightTTIEvents(setEvents))
		end
	end

	local v2 = {
		getEvents = signal,
		setEvents = setEvents,
		updateMetadata = updateTTIEventMetadata(setEvents),
		trackStart = trackTTIEventStart(setEvents, v),
		trackEnd = trackEnd,
		trackEndAtNextFrame = trackEndAtNextFrame,
		trackMilestone = trackMilestone(signal, setEvents),
		trackSubphase = trackSubphase(signal, setEvents),
		trackRequest = trackRequest(signal, setEvents),
		recordWebViewMilestones = 0,
		resetEvent = 0,
		destroyEvent = 0,
		discardOlderNavigationStarts = 0,
		Milestone = 0,
		NAVIGATION_EVENT_PREFIX = 0,
		Hooks = 0
	}
	local recordWebViewMilestones2

	if FFlagEnableTTIRecordWebViewMilestones then
		recordWebViewMilestones2 = recordWebViewMilestones(signal, setEvents)
	end

	v2.recordWebViewMilestones = recordWebViewMilestones2

	v2.resetEvent = resetTTIEvent(setEvents)
	v2.destroyEvent = destroyTTIEvent(setEvents)
	v2.discardOlderNavigationStarts = discardOlderNavigationStarts(setEvents, v)
	v2.Milestone = constants
	v2.NAVIGATION_EVENT_PREFIX = navigationEventPrefix
	v2.Hooks = {
		useTTIRenderAndMountedTracking = useTTIRenderAndMountedTracking(trackMilestone(signal, setEvents))
	}

	return v2
end
