local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local BaseMenu = require(Foundation.Components.BaseMenu)
local Popover = require(Foundation.Components.Popover)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local DropdownControl = require(script.Parent.DropdownControl)
local markSelectedItem = require(script.Parent.markSelectedItem)
local t1 = {
	testId = "--foundation-dropdown",
	variant = if not Flags.FoundationDropdownVariant then nil else InputVariant.Standard,
	width = UDim.new(0, 400),
	size = InputSize.Medium
}
local t2 = {
	offset = 5,
	position = PopoverSide.Bottom
}

local function Dropdown(p1, p2) -- line: 83
	-- upvalues: withDefaults (copy), t1 (copy), Flags (copy), InputVariant (copy), React (copy), markSelectedItem (copy), Popover (copy), DropdownControl (copy), withCommonProps (copy), PopoverAlign (copy), t2 (copy), Radius (copy), BaseMenu (copy)
	local v21 = withDefaults(p1, t1)

	if Flags.FoundationDropdownVariant and v21.variant == nil then
		v21.variant = InputVariant.Standard
	end

	local v22, v23 = React.useState(false)
	local v24 = React.useRef(nil)
	local v25, v26 = React.useState(nil)
	local v27 = React.useCallback(function(p3) -- line: 92
		-- upvalues: v24 (copy), v26 (copy)
		v24.current = p3
		v26(p3)
	end, {})

	if Flags.FoundationDropdownSelectionProps then
		React.useImperativeHandle(p2, function() -- line: 98
			-- upvalues: v25 (copy)
			return v25
		end, { v25 })
	end

	local v28, v29 = React.useBinding(v21.width)
	local v30, v31 = markSelectedItem(v21.items, v21.value)
	local v32 = React.useCallback(function() -- line: 108
		-- upvalues: v23 (copy)
		v23(function(p4) -- line: 109
			return not p4
		end)
	end, {})
	local v33 = React.useCallback(function() -- line: 114
		-- upvalues: v23 (copy)
		v23(false)
	end, {})
	local v34 = React.useCallback(function(p5) -- line: 118
		-- upvalues: v23 (copy), v21 (copy)
		v23(false)
		v21.onItemChanged(p5)
	end, { v21.onItemChanged })

	v21.onAbsoluteSizeChanged = React.useCallback(function(p6) -- line: 123
		-- upvalues: p1 (copy), v29 (copy)
		if p1.onAbsoluteSizeChanged then
			p1.onAbsoluteSizeChanged(p6)
		end

		v29(UDim.new(0, p6.AbsoluteSize.X))
	end, {
		v29,
		p1.onAbsoluteSizeChanged
	})

	return React.createElement(Popover.Root, {
		isOpen = v22,
		ref = if not Flags.FoundationDropdownSelectionProps then p2 else nil
	}, {
		DropdownControl = React.createElement(DropdownControl, withCommonProps(v21, {
			variant = if not Flags.FoundationDropdownVariant then nil else v21.variant,
			onActivated = v32,
			hasError = v21.hasError,
			isDisabled = v21.isDisabled,
			item = v31,
			placeholder = v21.placeholder,
			isMenuOpen = v22,
			width = v21.width,
			size = v21.size,
			label = v21.label,
			hint = v21.hint,
			inputRef = if not Flags.FoundationDropdownSelectionProps then v24 else v27,
			Selectable = if not Flags.FoundationDropdownSelectionProps then nil else v21.Selectable,
			NextSelectionUp = if not Flags.FoundationDropdownSelectionProps then nil else v21.NextSelectionUp,
			NextSelectionDown = if not Flags.FoundationDropdownSelectionProps then nil else v21.NextSelectionDown,
			NextSelectionLeft = if not Flags.FoundationDropdownSelectionProps then nil else v21.NextSelectionLeft,
			NextSelectionRight = if not Flags.FoundationDropdownSelectionProps then nil else v21.NextSelectionRight
		})),
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = v24
		}),
		Menu = React.createElement(Popover.Content, {
			hasArrow = false,
			align = PopoverAlign.End,
			side = t2,
			onPressedOutside = v33,
			radius = Radius.Medium,
			selection = v21.selection,
			selectionGroup = v21.selectionGroup
		}, React.createElement(BaseMenu.Root, {
			couldGrow = true,
			size = v21.size,
			width = v28,
			items = v30,
			maxHeight = v21.maxHeight,
			onActivated = v34,
			radius = Radius.Medium,
			scrollingFrameRef = v21.scrollingFrameRef,
			testId = `{ v21.testId }--menu`
		}))
	})
end

return React.memo(React.forwardRef(Dropdown))
