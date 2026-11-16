local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.InputPlatform)
local InputSize = require(Foundation.Enums.InputSize)
local Placement = require(Foundation.Enums.Placement)
require(Foundation.Enums.ShortcutSeparator)
local ShortcutVariant = require(Foundation.Enums.ShortcutVariant)

local useInputPlatform = require(Foundation.Utility.useInputPlatform)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local KeyCap = require(script.Parent.KeyCap)
local Separator = require(script.Parent.Separator)
local keyDisplay = require(script.Parent.keyDisplay)
local useShortcutVariants = require(script.Parent.useShortcutVariants)

local v = {
	size = InputSize.XSmall,
	placement = Placement.Start,
	variant = ShortcutVariant.Standard,
	testId = "--foundation-shortcut"
}

local function Shortcut(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local platform = useInputPlatform()
	local variantProps = useShortcutVariants(v3, v2.size, v2.variant)
	local count = 0
	local children = {}
	local count2 = 0

	for k, v4 in v2.shortcut do
		if v4.separator == nil then
			if v4.keyCode ~= nil and not keyDisplay.isNonDisplayable(v4.keyCode) then
				count += 1
				children[`Key{count}`] = React.createElement(KeyCap, {
					keyCode = v4.keyCode,
					platform = platform,
					variantProps = variantProps,
					LayoutOrder = k,
					testId = `{v2.testId}--key-{count}`
				})
			end
		else
			count2 += 1
			children[`Separator{count2}`] = React.createElement(Separator, {
				separator = v4.separator,
				variantProps = variantProps,
				LayoutOrder = k,
				testId = `{v2.testId}--separator-{count2}`
			})
		end
	end

	local createElement = React.createElement

	local v4 = withCommonProps(v2, {
		tag = variantProps.container.tag,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, variantProps.container.gap),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		ref = ref
	})

	local v5 = {
		Keys = React.createElement(View, {
			tag = variantProps.keys.tag,
			LayoutOrder = v2.placement == Placement.End and 2 or 1,
			testId = `{v2.testId}--keys`
		}, children),
		Keybinding = 0
	}
	local keybinding

	if not (v2.keybinding == nil or v2.keybinding == "") then
		keybinding = React.createElement(Text, {
			Text = v2.keybinding,
			tag = variantProps.keybinding.tag,
			LayoutOrder = v2.placement == Placement.End and 1 or 2,
			testId = `{v2.testId}--keybinding`
		})
	end

	v5.Keybinding = keybinding
	return createElement(View, v4, v5)
end

return React.memo(React.forwardRef(Shortcut))
