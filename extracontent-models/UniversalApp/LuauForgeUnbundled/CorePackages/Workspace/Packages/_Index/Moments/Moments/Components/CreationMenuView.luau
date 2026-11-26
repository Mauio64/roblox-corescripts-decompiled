local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local plusLarge = BuilderIcons.Icon.PlusLarge

local iconButton = Foundation.IconButton
local menu = Foundation.Menu

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function CreationMenuView(props)
	return React.createElement(menu, {
		align = Foundation.Enums.PopoverAlign.End,
		isOpen = props.isOpen,
		items = props.items,
		LayoutOrder = props.layoutOrder,
		onPressedOutside = props.onPressedOutside,
		ref = props.menuRef,
		side = Foundation.Enums.PopoverSide.Bottom,
		testId = props.testId
	}, {
		Trigger = React.createElement(iconButton, {
			LayoutOrder = props.layoutOrder,
			icon = plusLarge,
			onActivated = props.onToggle,
			variant = props.buttonVariant or buttonVariant.Utility,
			size = inputSize.Medium,
			isCircular = true,
			Selectable = true,
			testId = props.buttonTestId or "--moments-creation-menu-button"
		})
	})
end

return CreationMenuView
