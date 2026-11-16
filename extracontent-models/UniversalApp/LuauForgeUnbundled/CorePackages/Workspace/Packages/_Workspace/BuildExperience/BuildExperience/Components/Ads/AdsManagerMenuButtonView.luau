local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local iconButton = Foundation.IconButton
local menu = Foundation.Menu

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function AdsManagerMenuButtonView(props)
	return React.createElement(menu, {
		LayoutOrder = props.layoutOrder,
		align = popoverAlign.End,
		isOpen = props.isMenuOpen,
		items = props.menuItems,
		onActivated = props.onItemActivated,
		onPressedOutside = props.onCloseMenu,
		side = popoverSide.Bottom,
		size = props.menuSize,
		testId = `{props.testId}.Menu`,
		width = UDim.new(0, props.menuWidth)
	}, {
		Button = React.createElement(iconButton, {
			icon = iconName.ThreeDotsHorizontal,
			isCircular = true,
			onActivated = props.onToggleMenu,
			size = props.buttonSize,
			testId = `{props.testId}.Button`,
			variant = buttonVariant.Utility
		})
	})
end

return AdsManagerMenuButtonView
