local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local CreationMenuView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/CreationMenuView")
local useCreationMenuViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/useCreationMenuViewModel")

local buttonVariant = Foundation.Enums.ButtonVariant

local function CreationMenuContainer(props)
	local v5 = useCreationMenuViewModel({
		onCreateFromCaptures = props.onCreateFromCaptures,
		onCreateFromAvatar = props.onCreateFromAvatar,
		onTriggerActivated = props.onTriggerActivated
	})

	return React.createElement(CreationMenuView, {
		layoutOrder = props.layoutOrder,
		testId = props.testId,
		buttonTestId = props.buttonTestId,
		buttonVariant = props.buttonVariant,
		isOpen = v5.isOpen,
		items = v5.items,
		menuRef = v5.menuRef,
		onToggle = v5.onToggle,
		onPressedOutside = v5.onPressedOutside
	})
end

return CreationMenuContainer
