local ParentParent = script.Parent.Parent

return {
	[require(ParentParent.Enums.PlatformEnum).QuestVR] = {
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
