require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/InteractionFeedback")
local sounds = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppInteractionFeedbackConfig/SoundManager").Sounds

return {
	Default = {
		Release = { Sound = sounds.AppSelect.Name }
	},
	PlayExperienceButton = {
		Release = { Sound = sounds.NotificationHigh.Name }
	},
	MakePurchase = {
		Press = { Sound = sounds.Purchase.Name, Haptic = Enum.HapticEffectType.UIClick }
	}
}
