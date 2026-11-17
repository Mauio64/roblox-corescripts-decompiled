local parent = script:FindFirstAncestor("Moments").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local PlusLarge = BuilderIcons.Icon.PlusLarge

local IconButton = Foundation.IconButton
local Menu = Foundation.Menu

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function CreationMenuView(props)
	return React.createElement(Menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = props.isOpen,
		items = props.items,
		LayoutOrder = props.layoutOrder,
		onPressedOutside = props.onPressedOutside,
		ref = props.menuRef,
		side = Foundation.Enums.PopoverSide.Bottom,
		testId = props.testId
	}, {
		Trigger = React.createElement(IconButton, {
			LayoutOrder = props.layoutOrder,
			icon = PlusLarge,
			onActivated = props.onToggle,
			variant = props.buttonVariant or ButtonVariant.Utility,
			size = InputSize.Medium,
			isCircular = true,
			Selectable = true,
			testId = props.buttonTestId or "--moments-creation-menu-button"
		})
	})
end

return CreationMenuView
