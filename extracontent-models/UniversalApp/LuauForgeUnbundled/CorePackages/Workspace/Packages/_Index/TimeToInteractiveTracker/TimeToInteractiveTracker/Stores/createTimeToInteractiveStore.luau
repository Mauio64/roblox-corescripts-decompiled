local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/Signals").createSignal

local fFlagEnableTTIRecordWebViewMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/SharedFlags").FFlagEnableTTIRecordWebViewMilestones
local fFlagLuaAppNavTTIMeasurementV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/SharedFlags").FFlagLuaAppNavTTIMeasurementV2
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
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/Actions/discardOlderNavigationStarts")

local logTTIDiscard = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/logTTIDiscard")
local hasNavigationCommitted = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/hasNavigationCommitted")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Milestones/constants")
local navigationEventPrefix = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/navigationEventPrefix")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Hooks/useTTIRenderAndMountedTracking")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function()
	local signal, v5 = createSignal({})

	local v6 = {}
	local v7, v8 = trackTTIEventEnd(v5, v6)

	if FFlagTTITrackerDropEventsOnAppHide then
		local v9 = getAppLifecycleObserverService()

		if fFlagLuaAppNavTTIMeasurementV2 and v9 then
			local v10 = dropInFlightTTIEvents(v5)
			v9.OnHide:Connect(function()
				local v11 = signal(false)

				for k, v12 in v10() do
					if hasNavigationCommitted(v11[v12]) then
						logTTIDiscard(v12, "backgrounded")
					end
				end
			end)
		elseif v9 then
			v9.OnHide:Connect(dropInFlightTTIEvents(v5))
		end
	end

	if FFlagTTITrackerDropEventsOnJoinAttempt then
		local v9 = getOnNewJoinAttempt()

		if fFlagLuaAppNavTTIMeasurementV2 and v9 then
			local v10 = dropInFlightTTIEvents(v5)
			v9:Connect(function()
				local v11 = signal(false)

				for k, v12 in v10() do
					if hasNavigationCommitted(v11[v12]) then
						logTTIDiscard(v12, "joinAttempt")
					end
				end
			end)
		elseif v9 then
			v9:Connect(dropInFlightTTIEvents(v5))
		end
	end

	local v9 = {
		getEvents = signal,
		setEvents = v5,
		updateMetadata = updateTTIEventMetadata(v5),
		trackStart = trackTTIEventStart(v5, v6),
		trackEnd = v7,
		trackEndAtNextFrame = v8,
		trackMilestone = module8(signal, v5),
		trackSubphase = module9(signal, v5),
		trackRequest = module10(signal, v5),
		recordWebViewMilestones = 0,
		resetEvent = 0,
		destroyEvent = 0,
		discardOlderNavigationStarts = 0,
		Milestone = 0,
		NAVIGATION_EVENT_PREFIX = 0,
		Hooks = 0
	}

	local v10 = if fFlagEnableTTIRecordWebViewMilestones then module11(signal, v5) else nil
	v9.recordWebViewMilestones = v10

	v9.resetEvent = resetTTIEvent(v5)
	v9.destroyEvent = destroyTTIEvent(v5)
	v9.discardOlderNavigationStarts = module15(v5, v6)
	v9.Milestone = constants
	v9.NAVIGATION_EVENT_PREFIX = navigationEventPrefix
	v9.Hooks = { useTTIRenderAndMountedTracking = module20(module8(signal, v5)) }

	return v9
end
