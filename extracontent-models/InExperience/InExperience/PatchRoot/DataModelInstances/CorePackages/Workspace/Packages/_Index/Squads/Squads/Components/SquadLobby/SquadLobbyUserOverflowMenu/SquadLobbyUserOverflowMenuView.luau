local parent = script:FindFirstAncestor("Squads").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function SquadLobbyUserOverflowMenuView(props)
	local v = Foundation.Hooks.useTokens()

	if #props.items == 0 then
		return nil
	end

	return React.createElement(Foundation.Menu, {
		isOpen = props.isOpen,
		items = props.items,
		size = InputSize.Medium,
		side = PopoverSide.Bottom,
		align = PopoverAlign.End,
		onPressedOutside = props.onClose,
		ref = props.menuRef,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v.Padding.Small, 0, v.Padding.Small),
		ZIndex = 5,
		testId = `{props.testId}--menu`
	}, {
		Trigger = React.createElement(Foundation.IconButton, {
			icon = BuilderIcons.Icon.ThreeDotsHorizontal,
			isCircular = true,
			size = InputSize.Small,
			variant = ButtonVariant.Utility,
			onActivated = props.onTriggerActivated,
			testId = `{props.testId}--trigger`
		})
	})
end

return SquadLobbyUserOverflowMenuView
