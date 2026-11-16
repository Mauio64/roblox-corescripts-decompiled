local parent = script:FindFirstAncestor("AvatarExperienceGifting").Parent

local React = require(parent.React)
local Gifting = require(parent.Gifting)

local RecipientPickerView = Gifting.Components.RecipientPickerView

local function AvatarItemGiftRecipientPickerView(p)
	if p.isVisible then
		return React.createElement(RecipientPickerView, p.pickerProps)
	end

	return nil
end

return AvatarItemGiftRecipientPickerView
