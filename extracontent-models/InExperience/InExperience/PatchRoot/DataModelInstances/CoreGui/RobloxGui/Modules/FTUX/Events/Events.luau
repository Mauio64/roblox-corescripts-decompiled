local ParentParent = script.Parent.Parent
local PlatformEnum = require(ParentParent.Enums.PlatformEnum)
local v3 = require(ParentParent.Resources.FTUXEventTypes)[PlatformEnum.QuestVR]

return {
	[PlatformEnum.QuestVR] = {
		{
			v3.PerspectiveTooltipEvent,
			v3.FirstPersonToggleEvent,
			v3.HapticFeedbackEvent
		},
		{
			v3.MovementTooltipEvent,
			v3.MoveToGoalEvent,
			v3.SoundFeedbackEvent,
			v3.HapticFeedbackTwiceEvent
		},
		{
			v3.HapticFeedbackEvent,
			v3.SoundFeedbackEvent
		},
		{
			v3.SoundFeedbackEvent,
			v3.LeaveGameIconHighlightEvent
		}
	}
}
