local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Gifting = require(parent.Gifting)

local GiftIconButtonView = Gifting.Components.GiftIconButtonView

local function AvatarItemGiftEntryPointView(p)
	if p.isVisible then
		return React.createElement(GiftIconButtonView, p.buttonProps)
	end

	return nil
end

return AvatarItemGiftEntryPointView
