local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local Menu = Foundation.Menu

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function AdsManagerMenuButtonView(props)
	return React.createElement(Menu, {
		LayoutOrder = props.layoutOrder,
		align = PopoverAlign.End,
		isOpen = props.isMenuOpen,
		items = props.menuItems,
		onActivated = props.onItemActivated,
		onPressedOutside = props.onCloseMenu,
		side = PopoverSide.Bottom,
		size = props.menuSize,
		testId = `{props.testId}.Menu`,
		width = UDim.new(0, props.menuWidth)
	}, {
		Button = React.createElement(IconButton, {
			icon = IconName.ThreeDotsHorizontal,
			isCircular = true,
			onActivated = props.onToggleMenu,
			size = props.buttonSize,
			testId = `{props.testId}.Button`,
			variant = ButtonVariant.Utility
		})
	})
end

return AdsManagerMenuButtonView
