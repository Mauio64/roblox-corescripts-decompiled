local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/BuilderIcons")

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function SquadLobbyUserOverflowMenuView(props)
	local v5 = Foundation.Hooks.useTokens()

	if #props.items == 0 then
		return nil
	end

	return React.createElement(Foundation.Menu, {
		isOpen = props.isOpen,
		items = props.items,
		size = inputSize.Medium,
		side = popoverSide.Bottom,
		align = popoverAlign.End,
		onPressedOutside = props.onClose,
		ref = props.menuRef,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v5.Padding.Small, 0, v5.Padding.Small),
		ZIndex = 5,
		testId = `{props.testId}--menu`
	}, {
		Trigger = React.createElement(Foundation.IconButton, {
			icon = BuilderIcons.Icon.ThreeDotsHorizontal,
			isCircular = true,
			size = inputSize.Small,
			variant = buttonVariant.Utility,
			onActivated = props.onTriggerActivated,
			testId = `{props.testId}--trigger`
		})
	})
end

return SquadLobbyUserOverflowMenuView
