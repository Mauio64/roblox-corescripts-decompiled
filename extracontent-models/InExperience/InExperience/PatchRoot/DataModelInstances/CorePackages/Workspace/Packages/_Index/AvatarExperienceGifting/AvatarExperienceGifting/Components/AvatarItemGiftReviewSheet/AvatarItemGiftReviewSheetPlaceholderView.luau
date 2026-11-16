local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Gifting = require(parent.Gifting)

local GiftSheetLayoutView = Gifting.Components.GiftSheetLayoutView

local function AvatarItemGiftReviewSheetPlaceholderView(props)
	if props.isVisible then
		return React.createElement(GiftSheetLayoutView, {
			isOpen = true,
			titleText = "Purchase prompt",
			content = nil,
			onBack = props.onBack,
			onClose = props.onClose
		})
	end

	return nil
end

return AvatarItemGiftReviewSheetPlaceholderView
