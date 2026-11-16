local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local useDismissOnEscapeOrMenu = require(ChatUIPrimitives.Hooks.useDismissOnEscapeOrMenu)

local v = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local function ExpressionFlyOutView(props)
	useDismissOnEscapeOrMenu(props.isOpen, props.onPressedOutside)

	local udim = UDim2.fromOffset(props.width or 360, props.height or 240)
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = { Size = udim, ref = props.contentRef, selectionGroup = 0 }
	local selectionGroup

	if props.focusNavEnabled then
		selectionGroup = v
	end

	v2.selectionGroup = selectionGroup
	local element = createElement(view, v2, { Container = props.content })

	return React.createElement(Foundation.Popover.Root, { isOpen = props.isOpen }, {
		Anchor = React.createElement(Foundation.Popover.Anchor, nil, {
			AnchorWrapper = React.createElement(Foundation.View, {
				tag = "col align-x-center align-y-bottom size-0-full auto-x",
				padding = props.addTopPadding and { top = UDim.new(0, 6) } or nil
			}, { Button = props.anchorContent })
		}),
		Content = React.createElement(Foundation.Popover.Content, {
			side = { position = Foundation.Enums.PopoverSide.Right, offset = 7 },
			align = { position = Foundation.Enums.PopoverAlign.Start, offset = 3 },
			hasArrow = false,
			radius = Foundation.Enums.Radius.Medium,
			onPressedOutside = props.onPressedOutside
		}, { ContentWrapper = element })
	})
end

return React.memo(ExpressionFlyOutView)
