local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function GiftIconButtonView(props)
	return React.createElement(IconButton, {
		icon = IconName.GiftBox,
		onActivated = props.onActivated,
		isCircular = props.isCircular == true,
		isDisabled = props.isDisabled,
		LayoutOrder = props.LayoutOrder,
		size = InputSize.Medium,
		variant = ButtonVariant.Standard,
		testId = "gift-icon-button"
	})
end

return React.memo(GiftIconButtonView)
