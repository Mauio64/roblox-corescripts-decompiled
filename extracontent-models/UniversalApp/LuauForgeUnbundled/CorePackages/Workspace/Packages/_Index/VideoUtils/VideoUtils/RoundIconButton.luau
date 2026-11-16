local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Foundation")
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function RoundIconButton(props)
	local v5 = useTokens()

	return React.createElement(view, {
		tag = "auto-xy bg-over-media-100 radius-circle padding-medium",
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		ZIndex = props.ZIndex,
		onActivated = props.onActivated,
		selection = props.Selectable ~= nil and { Selectable = props.Selectable } or nil
	}, {
		Icon = React.createElement(icon, {
			name = props.icon,
			size = iconSize.Medium,
			style = v5.Color.Content.Emphasis
		})
	})
end

return RoundIconButton
