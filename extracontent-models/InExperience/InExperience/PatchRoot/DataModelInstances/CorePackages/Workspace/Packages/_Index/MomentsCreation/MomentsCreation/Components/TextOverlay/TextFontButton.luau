local parent = script:FindFirstAncestor("MomentsCreation").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function TextFontButton(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = { LayoutOrder = props.LayoutOrder, tag = "auto-xy radius-circle" }

	local v3 = {
		Icon = React.createElement(IconButton, {
			icon = BuilderIcons.Icon.TextUppercaseALowercaseA,
			onActivated = props.onToggle,
			size = Foundation.Enums.InputSize.Medium,
			isCircular = true
		}),
		Highlight = 0
	}
	local highlight

	if props.expanded then
		highlight = React.createElement(View, {
			ZIndex = 2,
			tag = "size-full radius-circle",
			backgroundStyle = v.Color.State.Hover
		})
	end

	v3.Highlight = highlight
	return createElement(View, v2, v3)
end

return TextFontButton
