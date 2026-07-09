require(script.Parent.SoundEffects)
require(script.Parent.SoundGroups)

local v1 = math.clamp(game:DefineFastInt("AppHover1VolumePercentage", 7), 0, 100) / 100
local v2 = math.clamp(game:DefineFastInt("AppNotificationHighVolumePercentage", 15), 0, 100) / 100
local v3 = math.clamp(game:DefineFastInt("AppSelectVolumePercentage", 12), 0, 100) / 100
local v4 = math.clamp(game:DefineFastInt("PurchaseVolumePercentage", 15), 0, 100) / 100

return {
	AppSelect = {
		Name = "AppSelect",
		SoundId = "rbxassetid://17208396156",
		DefaultPlaybackProperties = {
			Volume = v3
		}
	},
	AppHover1 = {
		Name = "AppHover1",
		SoundId = "rbxassetid://17208348006",
		DefaultPlaybackProperties = {
			Volume = v1
		}
	},
	CallAccept = {
		Name = "CallAccept",
		SoundId = "rbxassetid://14891715516"
	},
	CallDecline = {
		Name = "CallDecline",
		SoundId = "rbxassetid://14891713083"
	},
	HangUp = {
		Name = "HangUp",
		SoundId = "rbxassetid://14891706508"
	},
	Hover = {
		Name = "Hover",
		SoundId = "rbxassetid://14891703967"
	},
	NotificationHigh = {
		Name = "NotificationHigh",
		SoundId = "rbxassetid://17208361335",
		DefaultPlaybackProperties = {
			Volume = v2
		}
	},
	Purchase = {
		Name = "Purchase",
		SoundId = "rbxassetid://17208380755",
		DefaultPlaybackProperties = {
			Volume = v4
		}
	},
	Ringtone = {
		Name = "Ringtone",
		SoundId = "rbxassetid://14891720242"
	},
	Select = {
		Name = "Select",
		SoundId = "rbxassetid://14891717694"
	},
	Swipe = {
		Name = "Swipe",
		SoundId = "rbxassetid://14951578106"
	},
	PartyToast = {
		Name = "PartyToast",
		SoundId = "rbxassetid://99437156604053"
	},
	VolumeTest = {
		Name = "VolumeTest",
		SoundId = "rbxasset://sounds/uuhhh.mp3"
	},
	VRAppLobbySound = {
		Name = "VRAppLobbySound",
		SoundId = "rbxassetid://15227666815",
		DefaultPlaybackProperties = {
			FadeOutTime = 3
		}
	}
}
