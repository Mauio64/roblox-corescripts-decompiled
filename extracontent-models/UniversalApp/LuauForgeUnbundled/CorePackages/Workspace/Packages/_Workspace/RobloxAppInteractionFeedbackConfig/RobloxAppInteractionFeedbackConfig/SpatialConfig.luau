require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/InteractionFeedback")
local sounds = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/SoundManager").Sounds

return {
	Default = {
		Press = {
			Sound = sounds.AppSelect.Name,
			Haptic = Enum.HapticEffectType.UIClick
		},
		Hover = {
			Sound = sounds.AppHover1.Name,
			Haptic = Enum.HapticEffectType.UIHover
		}
	},
	PlayExperienceButton = {
		Press = {
			Sound = sounds.NotificationHigh.Name,
			Haptic = Enum.HapticEffectType.UIClick
		},
		Hover = {
			Sound = sounds.AppHover1.Name,
			Haptic = Enum.HapticEffectType.UIHover
		}
	},
	MakePurchase = {
		Press = { Sound = sounds.Purchase.Name, Haptic = Enum.HapticEffectType.UIClick },
		Hover = {
			Sound = sounds.AppHover1.Name,
			Haptic = Enum.HapticEffectType.UIHover
		}
	}
}
