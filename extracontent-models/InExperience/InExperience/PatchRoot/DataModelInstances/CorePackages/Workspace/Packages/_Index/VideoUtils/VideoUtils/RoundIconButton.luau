local parent = script:FindFirstAncestor("VideoUtils").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(props)
	local v = useTokens()

	return React.createElement(View, {
		tag = "auto-xy bg-over-media-100 radius-circle padding-medium",
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		ZIndex = props.ZIndex,
		onActivated = props.onActivated,
		selection = props.Selectable ~= nil and { Selectable = props.Selectable } or nil
	}, {
		Icon = React.createElement(Icon, {
			name = props.icon,
			size = IconSize.Medium,
			style = v.Color.Content.Emphasis
		})
	})
end

return RoundIconButton
