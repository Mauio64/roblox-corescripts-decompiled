local parent = script:FindFirstAncestor("RobloxAppInteractionFeedbackConfig").Parent
require(parent.InteractionFeedback)
local SoundManager = require(parent.SoundManager)
local Sounds = SoundManager.Sounds

return {
	Default = {
		Release = { Sound = Sounds.AppSelect.Name }
	},
	PlayExperienceButton = {
		Release = { Sound = Sounds.NotificationHigh.Name }
	},
	MakePurchase = {
		Press = { Sound = Sounds.Purchase.Name, Haptic = Enum.HapticEffectType.UIClick }
	}
}
