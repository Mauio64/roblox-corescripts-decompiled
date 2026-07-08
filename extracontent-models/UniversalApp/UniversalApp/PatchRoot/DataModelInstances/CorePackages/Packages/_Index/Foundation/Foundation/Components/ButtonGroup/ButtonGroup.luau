local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Button = require(Foundation.Components.Button)

require(Foundation.Enums.ButtonVariant)

local FillBehavior = require(Foundation.Enums.FillBehavior)
local InputSize = require(Foundation.Enums.InputSize)
local Orientation = require(Foundation.Enums.Orientation)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-button-group",
	orientation = Orientation.Horizontal,
	size = InputSize.Medium
}

local function ButtonGroup(p1, p2) -- line: 52
	-- upvalues: withDefaults (copy), t1 (copy), Orientation (copy), FillBehavior (copy), React (copy), Button (copy), View (copy), withCommonProps (copy)
	local v15 = withDefaults(p1, t1)

	assert(#v15.buttons <= 3, `ButtonGroup: a maximum of 3 buttons is supported, got { #v15.buttons }.`)

	local v16 = v15.orientation == Orientation.Vertical
	local v17 = v16 or v15.fillBehavior == FillBehavior.Fill
	local v18 = if v16 or not v17 then nil else FillBehavior.Fill
	local t2 = {}

	for v20, v21 in v15.buttons do
		t2["Button" .. v20] = React.createElement(Button, {
			text = v21.text,
			onActivated = v21.onActivated,
			variant = v21.variant,
			isDisabled = v21.isDisabled,
			isLoading = v21.isLoading,
			icon = v21.icon,
			inputDelay = v21.inputDelay,
			ref = v21.ref,
			size = v15.size,
			fillBehavior = v18,
			LayoutOrder = v20,
			testId = `{ v15.testId }--button-{ v20 }`
		})
	end

	return React.createElement(View, withCommonProps(v15, {
		tag = {
			["gap-small"] = true,
			["col flex-x-fill"] = v16,
			row = not v16 and v17,
			["row wrap"] = not v16 and not v17,
			["size-full-0 auto-y"] = v17,
			["auto-xy"] = not v17
		},
		ref = p2
	}), t2)
end

return React.memo(React.forwardRef(ButtonGroup))
