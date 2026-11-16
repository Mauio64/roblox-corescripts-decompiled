local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseMenu = require(Foundation.Components.BaseMenu)
local Popover = require(Foundation.Components.Popover)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InputSize = require(Foundation.Enums.InputSize)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)

local v = {
	size = InputSize.Medium,
	side = PopoverSide.Bottom,
	align = PopoverAlign.Start,
	testId = "--foundation-menu"
}

local function Menu(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local standard = v3.Stroke.Standard

	local createElement = React.createElement
	local root = Popover.Root
	local v4 = { isOpen = v2.isOpen, testId = v2.testId }

	local createElement2 = React.createElement
	local anchor = Popover.Anchor
	local v5 = withCommonProps(v2, { anchorRef = v2.anchorRef })
	local v6

	if not v2.anchorRef then
		v6 = v2.children
	end

	return createElement(root, v4, {
		Anchor = createElement2(anchor, v5, v6),
		Content = React.createElement(Popover.Content, {
			side = {
				position = v2.side,
				offset = standard + v3.Padding.Small
			},
			align = v2.align,
			hasArrow = false,
			onPressedOutside = v2.onPressedOutside,
			backgroundStyle = v3.Color.Surface.Surface_200,
			radius = Radius.Medium,
			ref = ref,
			selection = v2.selection,
			selectionGroup = v2.selectionGroup
		}, React.createElement(React.Fragment, nil, {
			Menu = React.createElement(BaseMenu.Root, {
				items = v2.items,
				size = v2.size,
				width = v2.width,
				maxHeight = v2.maxHeight,
				onActivated = v2.onActivated,
				onNestedLeafActivated = v2.onPressedOutside,
				radius = Radius.Medium
			})
		}))
	})
end

return React.memo(React.forwardRef(Menu))
