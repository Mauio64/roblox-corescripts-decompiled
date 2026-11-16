local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
require(AvatarExperienceGifting.Types.GiftSendFlowNavigationOverrides)

local AvatarItemGiftRecipientPickerView = require(script.Parent.AvatarItemGiftRecipientPickerView)
local useAvatarItemGiftRecipientPickerViewModel = require(script.Parent.useAvatarItemGiftRecipientPickerViewModel)

local function AvatarItemGiftRecipientPickerContainer(p)
	local v = useAvatarItemGiftRecipientPickerViewModel(p.navigationOverrides)
	return React.createElement(AvatarItemGiftRecipientPickerView, v)
end

return AvatarItemGiftRecipientPickerContainer
