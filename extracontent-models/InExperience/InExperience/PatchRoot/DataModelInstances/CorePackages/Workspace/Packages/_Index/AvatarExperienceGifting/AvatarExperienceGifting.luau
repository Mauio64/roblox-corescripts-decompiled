local AvatarItemGiftEntryPointContainer = require(script.Components.AvatarItemGiftEntryPoint.AvatarItemGiftEntryPointContainer)

local AvatarItemGiftRecipientPickerContainer = require(script.Components.AvatarItemGiftRecipientPicker.AvatarItemGiftRecipientPickerContainer)

local AvatarItemGiftReviewSheetContainer = require(script.Components.AvatarItemGiftReviewSheet.AvatarItemGiftReviewSheetContainer)

require(script.Types.GiftSendFlowNavigationOverrides)
local useAvatarItemGiftEligibility = require(script.Hooks.useAvatarItemGiftEligibility)

return {
	["jest.config"] = script["jest.config"],
	Components = {
		AvatarItemGiftEntryPoint = AvatarItemGiftEntryPointContainer,
		AvatarItemGiftRecipientPicker = AvatarItemGiftRecipientPickerContainer,
		AvatarItemGiftReviewSheet = AvatarItemGiftReviewSheetContainer
	},
	Hooks = { useAvatarItemGiftEligibility = useAvatarItemGiftEligibility },
	Utils = {}
}
