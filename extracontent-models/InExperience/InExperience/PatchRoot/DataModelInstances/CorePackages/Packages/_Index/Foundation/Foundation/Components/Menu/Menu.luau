local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BaseMenu = require(Foundation.Components.BaseMenu)
local Flags = require(Foundation.Utility.Flags)
local Popover = require(Foundation.Components.Popover)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local t1 = {
	testId = "--foundation-menu",
	size = InputSize.Medium,
	side = PopoverSide.Bottom,
	align = PopoverAlign.Start
}

local function Menu(p1, p2) -- line: 67
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), Popover (copy), withCommonProps (copy), Flags (copy), Radius (copy), BaseMenu (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useTokens()
	local Standard = v19.Stroke.Standard

	return React.createElement(Popover.Root, {
		isOpen = v18.isOpen,
		testId = v18.testId
	}, {
		Anchor = React.createElement(Popover.Anchor, withCommonProps(v18, {
			anchorRef = v18.anchorRef
		}), if not v18.anchorRef then v18.children else nil),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				position = v18.side,
				offset = Standard + v19.Padding.Small
			},
			align = v18.align,
			onPressedOutside = v18.onPressedOutside,
			backgroundStyle = if not Flags.FoundationBaseMenuBeta then v19.Color.Surface.Surface_100 else v19.Color.Surface.Surface_200,
			radius = Radius.Medium,
			ref = p2,
			selection = v18.selection,
			selectionGroup = v18.selectionGroup
		}, React.createElement(React.Fragment, nil, {
			Menu = React.createElement(BaseMenu.Root, {
				items = v18.items,
				size = v18.size,
				width = v18.width,
				maxHeight = v18.maxHeight,
				onActivated = v18.onActivated,
				onNestedLeafActivated = v18.onPressedOutside,
				radius = Radius.Medium
			})
		}))
	})
end

return React.memo(React.forwardRef(Menu))
