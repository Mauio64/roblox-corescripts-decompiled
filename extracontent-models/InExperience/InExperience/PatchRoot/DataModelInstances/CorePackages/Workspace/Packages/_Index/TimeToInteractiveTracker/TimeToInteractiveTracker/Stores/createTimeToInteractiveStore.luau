local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local createSignal = require(TimeToInteractiveTrackerParent.Signals).createSignal
local FFlagEnableTTIRecordWebViewMilestones = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagEnableTTIRecordWebViewMilestones
local updateTTIEventMetadata = require(script.Parent.Actions.updateTTIEventMetadata)
local trackTTIEventStart = require(script.Parent.Actions.trackTTIEventStart)
local trackTTIEventEnd = require(script.Parent.Actions.trackTTIEventEnd)
local trackMilestone = require(script.Parent.Actions.trackMilestone)
local trackSubphase = require(script.Parent.Actions.trackSubphase)
local trackRequest = require(script.Parent.Actions.trackRequest)
local recordWebViewMilestones = require(script.Parent.Actions.recordWebViewMilestones)
local resetTTIEvent = require(script.Parent.Actions.resetTTIEvent)
local destroyTTIEvent = require(script.Parent.Actions.destroyTTIEvent)
local constants = require(TimeToInteractiveTracker.Milestones.constants)
local useTTIRenderAndMountedTracking = require(TimeToInteractiveTracker.Hooks.useTTIRenderAndMountedTracking)

require(script.Parent.types)

return function() -- line: 28
	-- upvalues: createSignal (copy), updateTTIEventMetadata (copy), trackTTIEventStart (copy), trackTTIEventEnd (copy), trackMilestone (copy), trackSubphase (copy), trackRequest (copy), FFlagEnableTTIRecordWebViewMilestones (copy), recordWebViewMilestones (copy), resetTTIEvent (copy), destroyTTIEvent (copy), constants (copy), useTTIRenderAndMountedTracking (copy)
	local v16, v17 = createSignal({})

	return {
		getEvents = v16,
		setEvents = v17,
		updateMetadata = updateTTIEventMetadata(v17),
		trackStart = trackTTIEventStart(v17),
		trackEnd = trackTTIEventEnd(v17),
		trackMilestone = trackMilestone(v16, v17),
		trackSubphase = trackSubphase(v16, v17),
		trackRequest = trackRequest(v16, v17),
		recordWebViewMilestones = if not FFlagEnableTTIRecordWebViewMilestones then nil else recordWebViewMilestones(v16, v17),
		resetEvent = resetTTIEvent(v17),
		destroyEvent = destroyTTIEvent(v17),
		Milestone = constants,
		Hooks = {
			useTTIRenderAndMountedTracking = useTTIRenderAndMountedTracking(trackMilestone(v16, v17))
		}
	}
end
