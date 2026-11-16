local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = BuilderIcons.Icon

local Button = require(Foundation.Components.Button)
local Icon2 = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local Translator = require(Foundation.Utility.Localization.Translator)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	icon = { name = "icons/status/oof_xlarge", size = IconSize.Large },
	text = Translator:FormatByKey("CommonUI.Controls.NoResultsFound"),
	button = {
		icon = Icon.TwoArrowsSpinClockwise,
		text = Translator:FormatByKey("CommonUI.Controls.Action.Refresh"),
		onActivated = nil
	},
	testId = "--foundation-empty"
}

local function Empty(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()

	local createElement = React.createElement

	local v4 = withCommonProps(v2, {
		tag = "col align-x-center align-y-center gap-small size-full auto-xy",
		ref = ref
	})

	local v5 = {
		Icon = React.createElement(Icon2, {
			name = v2.icon.name,
			size = v2.icon.size,
			style = v3.Color.Content.Default,
			LayoutOrder = 1
		}),
		Text = React.createElement(Text, {
			Text = v2.text,
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default",
			testId = `{v2.testId}--text`
		}),
		Button = 0
	}
	local button

	if v2.button and v2.button.onActivated then
		button = React.createElement(Button, {
			text = v2.button.text,
			icon = v2.button.icon,
			onActivated = v2.button.onActivated,
			LayoutOrder = 3
		})
	end

	v5.Button = button
	return createElement(View, v4, v5)
end

return React.memo(React.forwardRef(Empty))
