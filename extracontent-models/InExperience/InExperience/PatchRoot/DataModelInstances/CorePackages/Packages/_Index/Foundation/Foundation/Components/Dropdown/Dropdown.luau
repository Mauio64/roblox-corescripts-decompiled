local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local BaseMenu = require(Foundation.Components.BaseMenu)
local Popover = require(Foundation.Components.Popover)
require(Foundation.Components.Types)

local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)

local DropdownControl = require(script.Parent.DropdownControl)
local markSelectedItem = require(script.Parent.markSelectedItem)

local v = {
	variant = InputVariant.Standard,
	width = UDim.new(0, 400),
	size = InputSize.Medium,
	testId = "--foundation-dropdown"
}

local side = { position = PopoverSide.Bottom, offset = 5 }

local function Dropdown(p, p2)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(nil)
	local inputRef = React.useCallback(function(current)
		ref.current = current
		setState2(current)
	end, {})
	React.useImperativeHandle(p2, function()
		return state2
	end, { state2 })

	local width, v3 = React.useBinding(v2.width)

	local items, v4 = markSelectedItem(v2.items, v2.value)

	local onActivated = React.useCallback(function()
		setState(function(p3): boolean
			return not p3
		end)
	end, {})

	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated2 = React.useCallback(function(p3)
		setState(false)
		v2.onItemChanged(p3)
	end, { v2.onItemChanged })

	v2.onAbsoluteSizeChanged = React.useCallback(function(p3)
		if p.onAbsoluteSizeChanged then
			p.onAbsoluteSizeChanged(p3)
		end

		v3(UDim.new(0, p3.AbsoluteSize.X))
	end, { v3, p.onAbsoluteSizeChanged })

	return React.createElement(Popover.Root, { isOpen = state }, {
		DropdownControl = React.createElement(DropdownControl, withCommonProps(v2, {
			variant = v2.variant,
			onActivated = onActivated,
			hasError = v2.hasError,
			isDisabled = v2.isDisabled,
			item = v4,
			placeholder = v2.placeholder,
			isMenuOpen = state,
			width = v2.width,
			size = v2.size,
			label = v2.label,
			hint = v2.hint,
			inputRef = inputRef,
			Selectable = v2.Selectable,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = v2.NextSelectionRight
		})),
		Anchor = React.createElement(Popover.Anchor, { anchorRef = ref }),
		Menu = React.createElement(Popover.Content, {
			hasArrow = false,
			align = PopoverAlign.End,
			side = side,
			onPressedOutside = onPressedOutside,
			radius = Radius.Medium,
			selection = v2.selection,
			selectionGroup = v2.selectionGroup
		}, React.createElement(BaseMenu.Root, {
			size = v2.size,
			couldGrow = true,
			width = width,
			items = items,
			maxHeight = v2.maxHeight,
			onActivated = onActivated2,
			radius = Radius.Medium,
			scrollingFrameRef = v2.scrollingFrameRef,
			testId = `{v2.testId}--menu`
		}))
	})
end

return React.memo(React.forwardRef(Dropdown))
