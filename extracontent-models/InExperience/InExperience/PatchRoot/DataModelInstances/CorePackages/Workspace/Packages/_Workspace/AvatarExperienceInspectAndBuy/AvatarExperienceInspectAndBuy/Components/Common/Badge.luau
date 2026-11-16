local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local IconSize = Foundation.Enums.IconSize

local function Badge(props)
	local v = useTokens()

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "auto-xy row align-x-center align-y-center bg-surface-300 radius-circle padding-small gap-xsmall",
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Text = "",
		onActivated = props.onActivated
	}
	local v3 = {
		Icon = React.createElement(Foundation.Icon, {
			name = props.icon,
			variant = props.iconVariant,
			size = IconSize.Medium,
			style = v.Color.Content.Default,
			LayoutOrder = 1
		}),
		Text = 0
	}
	local text

	if props.text then
		text = React.createElement(Foundation.Text, {
			tag = "text-caption-large content-emphasis text-align-x-left auto-xy text-truncate-none",
			Text = props.text,
			textStyle = v.Color.Content.Default,
			LayoutOrder = 2
		})
	end

	v3.Text = text
	return createElement(view, v2, v3)
end

return Badge
