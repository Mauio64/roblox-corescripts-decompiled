local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local recipientPickerView = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting").Components.RecipientPickerView

local function AvatarItemGiftRecipientPickerView(p2)
	if p2.isVisible then
		return React.createElement(recipientPickerView, p2.pickerProps)
	end

	return nil
end

return AvatarItemGiftRecipientPickerView
