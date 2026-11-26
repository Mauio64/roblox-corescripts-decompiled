local AvatarItemGiftEntryPointContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftEntryPoint/AvatarItemGiftEntryPointContainer")

local AvatarItemGiftRecipientPickerContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftRecipientPicker/AvatarItemGiftRecipientPickerContainer")

local AvatarItemGiftReviewSheetContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftReviewSheet/AvatarItemGiftReviewSheetContainer")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Types/GiftSendFlowNavigationOverrides")
return {
	Components = {
		AvatarItemGiftEntryPoint = AvatarItemGiftEntryPointContainer,
		AvatarItemGiftRecipientPicker = AvatarItemGiftRecipientPickerContainer,
		AvatarItemGiftReviewSheet = AvatarItemGiftReviewSheetContainer
	},
	Hooks = { useAvatarItemGiftEligibility = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Hooks/useAvatarItemGiftEligibility") },
	Utils = {}
}
