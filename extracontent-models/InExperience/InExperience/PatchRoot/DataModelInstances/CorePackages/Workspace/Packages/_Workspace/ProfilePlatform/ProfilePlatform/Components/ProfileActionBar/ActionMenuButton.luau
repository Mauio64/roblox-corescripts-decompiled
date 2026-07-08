local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local Menu = Foundation.Menu
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function ActionMenuButton(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy), InputSize (copy), Menu (copy), PopoverAlign (copy), PopoverSide (copy)
	local v13, v14 = React.useState(false)
	local v15 = React.useRef(nil)
	local v16 = t1.buttonRef or v15
	local v17 = React.useCallback(function() -- line: 28
		-- upvalues: v14 (copy), v13 (copy), t1 (copy)
		v14(function(p1) -- line: 29
			return not p1
		end)

		if not v13 and t1.onMenuOpened then
			t1.onMenuOpened()
		end
	end, {
		v13,
		t1.onMenuOpened
	})
	local v18 = React.useCallback(function() -- line: 37
		-- upvalues: v14 (copy)
		v14(false)
	end, {})
	local v19 = React.useCallback(function() -- line: 41
		-- upvalues: v14 (copy)
		v14(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		TriggerButton = React.createElement(Button, {
			onActivated = v17,
			text = t1.text,
			variant = t1.variant or ButtonVariant.Emphasis,
			width = UDim.new(1, 0),
			fillBehavior = FillBehavior.Fill,
			size = InputSize.Medium,
			ref = v16,
			LayoutOrder = t1.LayoutOrder
		}),
		ActionMenu = if not v13 then nil else React.createElement(Menu, {
			isOpen = true,
			align = PopoverAlign.Start,
			anchorRef = v16,
			items = t1.menuItems,
			onActivated = v19,
			onPressedOutside = v18,
			side = PopoverSide.Top,
			size = InputSize.Medium
		})
	})
end

return ActionMenuButton
