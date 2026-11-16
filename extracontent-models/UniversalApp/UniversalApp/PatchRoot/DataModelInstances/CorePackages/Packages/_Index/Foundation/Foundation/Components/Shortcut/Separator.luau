local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)

local ShortcutSeparator = require(Foundation.Enums.ShortcutSeparator)

require(script.Parent.useShortcutVariants)

local v = { [ShortcutSeparator.Or] = "/", [ShortcutSeparator.More] = "…" }

local function Separator(props)
	return React.createElement(Text, {
		Text = v[props.separator],
		tag = props.variantProps.separator.tag,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return Separator
