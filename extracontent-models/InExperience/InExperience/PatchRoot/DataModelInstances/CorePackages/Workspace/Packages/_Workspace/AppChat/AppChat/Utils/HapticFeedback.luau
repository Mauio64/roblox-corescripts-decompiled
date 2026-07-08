local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.InteractionFeedback)

local t1 = {
	Default = "Default"
}
local t2 = {
	Press = "Press",
	Hover = "Hover",
	Release = "Release"
}
local t3 = {
	Default = {
		Press = {
			Haptic = Enum.HapticEffectType.UIClick
		},
		Hover = {
			Haptic = Enum.HapticEffectType.UIHover
		},
		Release = {
			Haptic = Enum.HapticEffectType.UIClick
		}
	}
}

return {
	HapticFeedbackContext = t1,
	HapticFeedbackType = t2,
	HapticFeedbackConfig = t3
}
