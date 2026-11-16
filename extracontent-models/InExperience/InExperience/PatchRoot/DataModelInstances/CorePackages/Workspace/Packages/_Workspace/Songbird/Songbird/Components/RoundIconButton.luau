local Songbird = script:FindFirstAncestor("Songbird")

local React = require(Songbird.Parent.React)
local Foundation = require(Songbird.Parent.Foundation)

local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(props)
	local v = useTokens()

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
				style = v.Color.ActionEmphasis.Foreground
			})
		}
	)
end

return RoundIconButton
