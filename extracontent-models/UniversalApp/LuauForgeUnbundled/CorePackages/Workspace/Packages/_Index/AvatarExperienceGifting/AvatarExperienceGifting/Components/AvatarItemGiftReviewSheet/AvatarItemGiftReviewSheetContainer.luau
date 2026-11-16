local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Types/GiftSendFlowNavigationOverrides")

local AvatarItemGiftReviewSheetPlaceholderView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftReviewSheet/AvatarItemGiftReviewSheetPlaceholderView")
local useAvatarItemGiftReviewSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Components/AvatarItemGiftReviewSheet/useAvatarItemGiftReviewSheetViewModel")

local function AvatarItemGiftReviewSheetContainer(p2)
	local v5 = useAvatarItemGiftReviewSheetViewModel(p2.navigationOverrides)
	return React.createElement(AvatarItemGiftReviewSheetPlaceholderView, v5)
end

return AvatarItemGiftReviewSheetContainer
