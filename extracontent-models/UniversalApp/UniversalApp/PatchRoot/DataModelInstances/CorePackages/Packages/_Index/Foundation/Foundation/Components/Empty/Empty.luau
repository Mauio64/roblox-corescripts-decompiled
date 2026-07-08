local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Button = require(Foundation.Components.Button)
local Icon = require(Foundation.Components.Icon)
local IconSize = require(Foundation.Enums.IconSize)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)
local Translator = require(Foundation.Utility.Localization.Translator)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-empty",
	icon = {
		name = "icons/status/oof_xlarge",
		size = IconSize.Large
	},
	text = Translator:FormatByKey("CommonUI.Controls.NoResultsFound"),
	button = {
		icon = "icons/common/refresh",
		onActivated = nil,
		text = Translator:FormatByKey("CommonUI.Controls.Action.Refresh")
	}
}

local function Empty(p1, p2) -- line: 46
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy), Text (copy), Button (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = useTokens()

	return React.createElement(View, withCommonProps(v17, {
		tag = "col align-x-center align-y-center gap-small size-full auto-xy",
		ref = p2
	}), {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = v17.icon.name,
			size = v17.icon.size,
			style = v18.Color.Content.Default
		}),
		Text = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-center content-default",
			Text = v17.text,
			testId = `{ v17.testId }--text`
		}),
		Button = if not v17.button or not v17.button.onActivated then nil else React.createElement(Button, {
			LayoutOrder = 3,
			text = v17.button.text,
			icon = v17.button.icon,
			onActivated = v17.button.onActivated
		})
	})
end

return React.memo(React.forwardRef(Empty))
