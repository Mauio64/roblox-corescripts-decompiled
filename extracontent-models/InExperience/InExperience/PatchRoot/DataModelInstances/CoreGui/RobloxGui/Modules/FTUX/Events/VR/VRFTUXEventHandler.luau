local parent = script.Parent.Parent.Parent
local FirstPersonToggleEvent = require(parent.Events.VR.FirstPersonToggleEvent)
local HapticFeedbackEvent = require(parent.Events.VR.HapticFeedbackEvent)
local HapticFeedbackTwiceEvent = require(parent.Events.VR.HapticFeedbackTwiceEvent)
local SoundFeedbackEvent = require(parent.Events.VR.SoundFeedbackEvent)
local JumpEvent = require(parent.Events.VR.JumpEvent)
local MoveToGoalEvent = require(parent.Events.VR.MoveToGoalEvent)
local PerspectiveTooltipEvent = require(parent.Events.VR.PerspectiveTooltipEvent)
local MovementTooltipEvent = require(parent.Events.VR.MovementTooltipEvent)
local LeaveGameIconHighlightEvent = require(parent.Events.VR.LeaveGameIconHighlightEvent)

local PlatformEnum = require(parent.Enums.PlatformEnum)
local FTUXEventTypes = require(parent.Resources.FTUXEventTypes)
require(script.Parent.Parent.EventType)

local ftuxEventType = FTUXEventTypes[PlatformEnum.QuestVR]

local VRFTUXEventHandler = { Name = "VRFTUXEventHandler" }

function VRFTUXEventHandler.StartEvent(p, callback)
	if p == ftuxEventType.FirstPersonToggleEvent then
		task.spawn(FirstPersonToggleEvent.StartEvent, callback)
	elseif p == ftuxEventType.MoveToGoalEvent then
		task.spawn(MoveToGoalEvent.StartEvent, callback)
	elseif p == ftuxEventType.JumpEvent then
		task.spawn(JumpEvent.StartEvent, callback)
	elseif p == ftuxEventType.PerspectiveTooltipEvent then
		task.spawn(PerspectiveTooltipEvent.StartEvent)
	elseif p == ftuxEventType.MovementTooltipEvent then
		task.spawn(MovementTooltipEvent.StartEvent)
	elseif p == ftuxEventType.HapticFeedbackEvent then
		task.spawn(HapticFeedbackEvent.StartEvent)
	elseif p == ftuxEventType.SoundFeedbackEvent then
		task.spawn(SoundFeedbackEvent.StartEvent)
	elseif p == ftuxEventType.HapticFeedbackTwiceEvent then
		task.spawn(HapticFeedbackTwiceEvent.StartEvent)
	elseif p == ftuxEventType.LeaveGameIconHighlightEvent then
		task.spawn(LeaveGameIconHighlightEvent.StartEvent)
	else
		warn("Unmapped VRFTUX event type: " .. tostring(p))
	end
end

function VRFTUXEventHandler.StopEvent(p)
	if p == ftuxEventType.FirstPersonToggleEvent then
		task.spawn(FirstPersonToggleEvent.StopEvent)
		return
	end

	if p == ftuxEventType.MoveToGoalEvent then
		task.spawn(MoveToGoalEvent.StopEvent)
		return
	end

	if p == ftuxEventType.JumpEvent then
		task.spawn(JumpEvent.StopEvent)
		return
	end

	if p == ftuxEventType.PerspectiveTooltipEvent then
		task.spawn(PerspectiveTooltipEvent.StopEvent)
		return
	end

	if p == ftuxEventType.MovementTooltipEvent then
		task.spawn(MovementTooltipEvent.StopEvent)
		return
	end

	if p == ftuxEventType.LeaveGameIconHighlightEvent then
		task.spawn(LeaveGameIconHighlightEvent.StopEvent)
		return
	end

	if not (p ~= ftuxEventType.HapticFeedbackTwiceEvent and p ~= ftuxEventType.HapticFeedbackEvent and p ~= ftuxEventType.SoundFeedbackEvent) then
		return
	end

	warn("Unmapped VRFTUX event type: " .. tostring(p))
end

return VRFTUXEventHandler
