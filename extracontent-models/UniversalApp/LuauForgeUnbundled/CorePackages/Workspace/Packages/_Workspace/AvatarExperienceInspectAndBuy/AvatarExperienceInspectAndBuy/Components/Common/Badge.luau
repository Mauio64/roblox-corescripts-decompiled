local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local useTokens = Foundation.Hooks.useTokens
local iconSize = Foundation.Enums.IconSize

local function Badge(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		tag = "auto-xy row align-x-center align-y-center bg-surface-300 radius-circle padding-small gap-xsmall",
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Text = "",
		onActivated = props.onActivated
	}
	local v7 = {
		Icon = React.createElement(Foundation.Icon, {
			name = props.icon,
			variant = props.iconVariant,
			size = iconSize.Medium,
			style = v5.Color.Content.Default,
			LayoutOrder = 1
		}),
		Text = 0
	}

	local v8 = if props.text then React.createElement(Foundation.Text, {
		tag = "text-caption-large content-emphasis text-align-x-left auto-xy text-truncate-none",
		Text = props.text,
		textStyle = v5.Color.Content.Default,
		LayoutOrder = 2
	}) else nil
	v7.Text = v8
	return createElement(view, v6, v7)
end

return Badge
