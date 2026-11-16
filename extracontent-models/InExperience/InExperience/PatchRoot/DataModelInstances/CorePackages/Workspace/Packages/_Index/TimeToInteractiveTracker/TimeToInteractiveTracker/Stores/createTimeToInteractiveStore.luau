local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local parent = TimeToInteractiveTracker.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTTIRecordWebViewMilestones = SharedFlags.FFlagEnableTTIRecordWebViewMilestones
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

local constants = require(TimeToInteractiveTracker.Milestones.constants)
local useTTIRenderAndMountedTracking = require(TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking)

require(script.Parent.types)

return function()
	local signal, setEvents = createSignal({})

	local v = FFlagTTITrackerDropEventsOnAppHide and getAppLifecycleObserverService()

	if v then
		v.OnHide:Connect(dropInFlightTTIEvents(setEvents))
	end

	local v2 = FFlagTTITrackerDropEventsOnJoinAttempt and getOnNewJoinAttempt()

	if v2 then
		v2:Connect(dropInFlightTTIEvents(setEvents))
	end

	local v3 = {
		getEvents = signal,
		setEvents = setEvents,
		updateMetadata = updateTTIEventMetadata(setEvents),
		trackStart = trackTTIEventStart(setEvents),
		trackEnd = trackTTIEventEnd(setEvents),
		trackMilestone = trackMilestone(signal, setEvents),
		trackSubphase = trackSubphase(signal, setEvents),
		trackRequest = trackRequest(signal, setEvents),
		recordWebViewMilestones = 0,
		resetEvent = 0,
		destroyEvent = 0,
		Milestone = 0,
		Hooks = 0
	}
	local recordWebViewMilestones2

	if FFlagEnableTTIRecordWebViewMilestones then
		recordWebViewMilestones2 = recordWebViewMilestones(signal, setEvents)
	end

	v3.recordWebViewMilestones = recordWebViewMilestones2

	v3.resetEvent = resetTTIEvent(setEvents)
	v3.destroyEvent = destroyTTIEvent(setEvents)
	v3.Milestone = constants
	v3.Hooks = {
		useTTIRenderAndMountedTracking = useTTIRenderAndMountedTracking(trackMilestone(signal, setEvents))
	}

	return v3
end
