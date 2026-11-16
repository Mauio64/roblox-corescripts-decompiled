local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local giftSheetLayoutView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting").Components.GiftSheetLayoutView

local function AvatarItemGiftReviewSheetPlaceholderView(props)
	if props.isVisible then
		return React.createElement(giftSheetLayoutView, {
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
