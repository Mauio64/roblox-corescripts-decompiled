local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")

local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(props)
	local v5 = useTokens()

	return React.createElement(
		Foundation.View,
		{
			tag = "auto-xy bg-action-emphasis radius-circle padding-small",
			onActivated = props.onActivated,
			aspectRatio = 1,
			LayoutOrder = props.LayoutOrder
		},
		{
			Icon = React.createElement(Foundation.Icon, {
				Position = props.iconOffset,
				name = props.icon,
				size = Foundation.Enums.IconSize.Medium,
				style = v5.Color.ActionEmphasis.Foreground
			})
		}
	)
end

return RoundIconButton
