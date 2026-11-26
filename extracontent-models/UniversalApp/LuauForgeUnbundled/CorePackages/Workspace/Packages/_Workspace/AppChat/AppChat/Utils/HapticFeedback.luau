require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InteractionFeedback")

return {
	HapticFeedbackContext = { Default = "Default" },
	HapticFeedbackType = { Press = "Press", Hover = "Hover", Release = "Release" },
	HapticFeedbackConfig = {
		Default = {
			Press = { Haptic = Enum.HapticEffectType.UIClick },
			Hover = { Haptic = Enum.HapticEffectType.UIHover },
			Release = { Haptic = Enum.HapticEffectType.UIClick }
		}
	}
}
