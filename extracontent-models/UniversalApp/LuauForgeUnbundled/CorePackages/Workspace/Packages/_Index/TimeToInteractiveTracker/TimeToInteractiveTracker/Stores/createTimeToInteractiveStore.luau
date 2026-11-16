local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/Signals").createSignal

local fFlagEnableTTIRecordWebViewMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/SharedFlags").FFlagEnableTTIRecordWebViewMilestones
local FFlagTTITrackerDropEventsOnAppHide = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerDropEventsOnAppHide")
local getAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getAppLifecycleObserverService")
local FFlagTTITrackerDropEventsOnJoinAttempt = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerDropEventsOnJoinAttempt")
local getOnNewJoinAttempt = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getOnNewJoinAttempt")

local updateTTIEventMetadata = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/updateTTIEventMetadata")
local trackTTIEventStart = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/trackTTIEventStart")
local trackTTIEventEnd = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/trackTTIEventEnd")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/trackMilestone")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/trackSubphase")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/trackRequest")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/recordWebViewMilestones")
local resetTTIEvent = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/resetTTIEvent")
local destroyTTIEvent = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/destroyTTIEvent")
local dropInFlightTTIEvents = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/dropInFlightTTIEvents")

local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Hooks/useTTIRenderAndMountedTracking")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function()
	local signal, v5 = createSignal({})

	local v6 = FFlagTTITrackerDropEventsOnAppHide and getAppLifecycleObserverService()

	if v6 then
		v6.OnHide:Connect(dropInFlightTTIEvents(v5))
	end

	local v7 = FFlagTTITrackerDropEventsOnJoinAttempt and getOnNewJoinAttempt()

	if v7 then
		v7:Connect(dropInFlightTTIEvents(v5))
	end

	local v8 = {
		getEvents = signal,
		setEvents = v5,
		updateMetadata = updateTTIEventMetadata(v5),
		trackStart = trackTTIEventStart(v5),
		trackEnd = trackTTIEventEnd(v5),
		trackMilestone = module8(signal, v5),
		trackSubphase = module9(signal, v5),
		trackRequest = module10(signal, v5),
		recordWebViewMilestones = 0,
		resetEvent = 0,
		destroyEvent = 0,
		Milestone = 0,
		Hooks = 0
	}

	local v9 = if fFlagEnableTTIRecordWebViewMilestones then module11(signal, v5) else nil
	v8.recordWebViewMilestones = v9

	v8.resetEvent = resetTTIEvent(v5)
	v8.destroyEvent = destroyTTIEvent(v5)
	v8.Milestone = constants
	v8.Hooks = { useTTIRenderAndMountedTracking = module16(module8(signal, v5)) }

	return v8
end
