local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CreationMenuView = require(Moments.Components.CreationMenuView)
local useCreationMenuViewModel = require(Moments.Components.useCreationMenuViewModel)

local ButtonVariant = Foundation.Enums.ButtonVariant

local function CreationMenuContainer(props)
	local v = useCreationMenuViewModel({
		onCreateFromCaptures = props.onCreateFromCaptures,
		onCreateFromAvatar = props.onCreateFromAvatar,
		onTriggerActivated = props.onTriggerActivated
	})

	return React.createElement(CreationMenuView, {
		layoutOrder = props.layoutOrder,
		testId = props.testId,
		buttonTestId = props.buttonTestId,
		buttonVariant = props.buttonVariant,
		isOpen = v.isOpen,
		items = v.items,
		menuRef = v.menuRef,
		onToggle = v.onToggle,
		onPressedOutside = v.onPressedOutside
	})
end

return CreationMenuContainer
