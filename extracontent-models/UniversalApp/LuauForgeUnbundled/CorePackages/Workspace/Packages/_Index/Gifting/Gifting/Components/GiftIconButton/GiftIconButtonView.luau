local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function GiftIconButtonView(props)
	return React.createElement(iconButton, {
		icon = iconName.GiftBox,
		onActivated = props.onActivated,
		isCircular = props.isCircular == true,
		isDisabled = props.isDisabled,
		LayoutOrder = props.LayoutOrder,
		size = inputSize.Medium,
		variant = buttonVariant.Standard,
		testId = "gift-icon-button"
	})
end

return React.memo(GiftIconButtonView)
