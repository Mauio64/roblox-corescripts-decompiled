local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize

return {
	Images = {
		MuteIcon = {
			Image = "rbxasset://textures/ui/VoiceChat/SpeakerLight/Unmuted0.png",
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium))
		},
		BlockIcon = {
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
			Image = Images["icons/actions/block"]
		},
		VoiceChatIcon = {
			Image = "rbxasset://textures/ui/VoiceChat/SpeakerLight/Unmuted0.png",
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium))
		},
		TextChatIcon = {
			Image = "rbxasset://textures/ui/TopBar/chatOff.png",
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium))
		},
		OtherIcon = {
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
			Image = Images["icons/menu/help"]
		},
		RoundedRect = {
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Image = Images["component_assets/circle_17"]
		}
	}
}
