local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local giftIconButtonView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting").Components.GiftIconButtonView

local function AvatarItemGiftEntryPointView(p2)
	if p2.isVisible then
		return React.createElement(giftIconButtonView, p2.buttonProps)
	end

	return nil
end

return AvatarItemGiftEntryPointView
