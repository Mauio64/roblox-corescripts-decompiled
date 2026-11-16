local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
require(AvatarExperienceGifting.Types.GiftSendFlowNavigationOverrides)

local AvatarItemGiftReviewSheetPlaceholderView = require(script.Parent.AvatarItemGiftReviewSheetPlaceholderView)
local useAvatarItemGiftReviewSheetViewModel = require(script.Parent.useAvatarItemGiftReviewSheetViewModel)

local function AvatarItemGiftReviewSheetContainer(p)
	local v = useAvatarItemGiftReviewSheetViewModel(p.navigationOverrides)
	return React.createElement(AvatarItemGiftReviewSheetPlaceholderView, v)
end

return AvatarItemGiftReviewSheetContainer
