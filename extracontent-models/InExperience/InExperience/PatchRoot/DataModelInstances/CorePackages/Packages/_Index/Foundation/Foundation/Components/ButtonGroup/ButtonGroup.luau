local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Button = require(Foundation.Components.Button)
require(Foundation.Enums.ButtonVariant)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local InputSize = require(Foundation.Enums.InputSize)
local Orientation = require(Foundation.Enums.Orientation)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local devAssert = require(Foundation.Utility.devAssert)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	maxButtonCount = 3,
	orientation = Orientation.Horizontal,
	size = InputSize.Medium,
	testId = "--foundation-button-group"
}

local function ButtonGroup(p, ref)
	local v2 = withDefaults(p, v)

	devAssert(
		#v2.buttons <= v2.maxButtonCount,
		`ButtonGroup: a maximum of {v2.maxButtonCount} buttons is supported, got {#v2.buttons}.`
	)

	local colflexxfill = v2.orientation == Orientation.Vertical
	local sizefull0autoy = colflexxfill or v2.fillBehavior == FillBehavior.Fill
	local fill

	if not (colflexxfill or not sizefull0autoy) then
		fill = FillBehavior.Fill
	end

	local children = {}

	for k, button in v2.buttons do
		children[`{k}-{button.text}`] = React.createElement(Button, {
			text = button.text,
			onActivated = button.onActivated,
			variant = button.variant,
			isDisabled = button.isDisabled,
			isLoading = button.isLoading,
			icon = button.icon,
			inputDelay = button.inputDelay,
			ref = button.ref,
			size = v2.size,
			fillBehavior = fill,
			LayoutOrder = k,
			testId = button.testId or `{v2.testId}--button-{k}`
		})
	end

	return React.createElement(View, withCommonProps(v2, {
		tag = {
			["gap-small"] = true,
			["col flex-x-fill"] = colflexxfill,
			row = not colflexxfill and sizefull0autoy,
			["row wrap"] = not (colflexxfill or sizefull0autoy),
			["size-full-0 auto-y"] = sizefull0autoy,
			["auto-xy"] = not sizefull0autoy
		},
		ref = ref
	}), children)
end

return React.memo(React.forwardRef(ButtonGroup))
