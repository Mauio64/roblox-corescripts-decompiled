local ParentParent = script.Parent.Parent.Parent
local FirstPersonToggleEvent = require(ParentParent.Events.VR.FirstPersonToggleEvent)
local HapticFeedbackEvent = require(ParentParent.Events.VR.HapticFeedbackEvent)
local HapticFeedbackTwiceEvent = require(ParentParent.Events.VR.HapticFeedbackTwiceEvent)
local SoundFeedbackEvent = require(ParentParent.Events.VR.SoundFeedbackEvent)
local JumpEvent = require(ParentParent.Events.VR.JumpEvent)
local MoveToGoalEvent = require(ParentParent.Events.VR.MoveToGoalEvent)
local PerspectiveTooltipEvent = require(ParentParent.Events.VR.PerspectiveTooltipEvent)
local MovementTooltipEvent = require(ParentParent.Events.VR.MovementTooltipEvent)
local LeaveGameIconHighlightEvent = require(ParentParent.Events.VR.LeaveGameIconHighlightEvent)
local PlatformEnum = require(ParentParent.Enums.PlatformEnum)
local FTUXEventTypes = require(ParentParent.Resources.FTUXEventTypes)

require(script.Parent.Parent.EventType)

local v13 = FTUXEventTypes[PlatformEnum.QuestVR]

return {
	Name = "VRFTUXEventHandler",
	StartEvent = function(p1, p2: ((...any) -> ...any)) -- line: 25
		-- upvalues: v13 (copy), FirstPersonToggleEvent (copy), MoveToGoalEvent (copy), JumpEvent (copy), PerspectiveTooltipEvent (copy), MovementTooltipEvent (copy), HapticFeedbackEvent (copy), SoundFeedbackEvent (copy), HapticFeedbackTwiceEvent (copy), LeaveGameIconHighlightEvent (copy)
		if p1 == v13.FirstPersonToggleEvent then
			task.spawn(FirstPersonToggleEvent.StartEvent, p2)

			return
		end

		if p1 == v13.MoveToGoalEvent then
			task.spawn(MoveToGoalEvent.StartEvent, p2)

			return
		end

		if p1 == v13.JumpEvent then
			task.spawn(JumpEvent.StartEvent, p2)

			return
		end

		if p1 == v13.PerspectiveTooltipEvent then
			task.spawn(PerspectiveTooltipEvent.StartEvent)

			return
		end

		if p1 == v13.MovementTooltipEvent then
			task.spawn(MovementTooltipEvent.StartEvent)

			return
		end

		if p1 == v13.HapticFeedbackEvent then
			task.spawn(HapticFeedbackEvent.StartEvent)

			return
		end

		if p1 == v13.SoundFeedbackEvent then
			task.spawn(SoundFeedbackEvent.StartEvent)

			return
		end

		if p1 == v13.HapticFeedbackTwiceEvent then
			task.spawn(HapticFeedbackTwiceEvent.StartEvent)

			return
		end

		if p1 == v13.LeaveGameIconHighlightEvent then
			task.spawn(LeaveGameIconHighlightEvent.StartEvent)

			return
		end

		warn("Unmapped VRFTUX event type: " .. tostring(p1))
	end,
	StopEvent = function(p3) -- line: 49
		-- upvalues: v13 (copy), FirstPersonToggleEvent (copy), MoveToGoalEvent (copy), JumpEvent (copy), PerspectiveTooltipEvent (copy), MovementTooltipEvent (copy), LeaveGameIconHighlightEvent (copy)
		if p3 == v13.FirstPersonToggleEvent then
			task.spawn(FirstPersonToggleEvent.StopEvent)

			return
		end

		if p3 == v13.MoveToGoalEvent then
			task.spawn(MoveToGoalEvent.StopEvent)

			return
		end

		if p3 == v13.JumpEvent then
			task.spawn(JumpEvent.StopEvent)

			return
		end

		if p3 == v13.PerspectiveTooltipEvent then
			task.spawn(PerspectiveTooltipEvent.StopEvent)

			return
		end

		if p3 == v13.MovementTooltipEvent then
			task.spawn(MovementTooltipEvent.StopEvent)

			return
		end

		if p3 == v13.LeaveGameIconHighlightEvent then
			task.spawn(LeaveGameIconHighlightEvent.StopEvent)

			return
		end

		if p3 == v13.HapticFeedbackTwiceEvent then
			return
		end

		if p3 == v13.HapticFeedbackEvent then
			return
		end

		if p3 == v13.SoundFeedbackEvent then
			return
		end

		warn("Unmapped VRFTUX event type: " .. tostring(p3))
	end
}
