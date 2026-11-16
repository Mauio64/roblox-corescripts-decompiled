local parent = script.Parent.Parent
local PlatformEnum = require(parent.Enums.PlatformEnum)

return {
	[PlatformEnum.QuestVR] = {
		FirstPersonToggleEvent = "FirstPersonToggleEvent",
		MoveToGoalEvent = "MoveToGoalEvent",
		HapticFeedbackEvent = "HapticFeedbackEvent",
		HapticFeedbackTwiceEvent = "HapticFeedbackTwiceEvent",
		SoundFeedbackEvent = "SoundFeedbackEvent",
		JumpEvent = "JumpEvent",
		PerspectiveTooltipEvent = "PerspectiveTooltipEvent",
		MovementTooltipEvent = "MovementTooltipEvent",
		LeaveGameIconHighlightEvent = "LeaveGameIconHighlightEvent"
	}
}
