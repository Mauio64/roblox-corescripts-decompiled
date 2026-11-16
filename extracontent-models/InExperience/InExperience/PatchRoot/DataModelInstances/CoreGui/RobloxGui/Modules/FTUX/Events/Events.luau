local parent = script.Parent.Parent
local PlatformEnum = require(parent.Enums.PlatformEnum)
local FTUXEventTypes = require(parent.Resources.FTUXEventTypes)

local ftuxEventType = FTUXEventTypes[PlatformEnum.QuestVR]

return {
	[PlatformEnum.QuestVR] = {
		{
			ftuxEventType.PerspectiveTooltipEvent,
			ftuxEventType.FirstPersonToggleEvent,
			ftuxEventType.HapticFeedbackEvent
		},
		{
			ftuxEventType.MovementTooltipEvent,
			ftuxEventType.MoveToGoalEvent,
			ftuxEventType.SoundFeedbackEvent,
			ftuxEventType.HapticFeedbackTwiceEvent
		},
		{ ftuxEventType.HapticFeedbackEvent, ftuxEventType.SoundFeedbackEvent },
		{ ftuxEventType.SoundFeedbackEvent, ftuxEventType.LeaveGameIconHighlightEvent }
	}
}
