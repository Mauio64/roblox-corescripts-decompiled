local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module2 = require("@luauforge/deferred/eaj")

local icon = module2.Icon
local view = module2.View

local useTokens = module2.Hooks.useTokens

local udim = UDim2.fromOffset(1, 1)

return function(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		tag = "size-full-0 bg-action-subtle auto-y padding-x-large padding-y-small row flex-between",
		ZIndex = props.ZIndex
	}
	local v8 = {
		BackButton = React.createElement(
			view,
			{
				onActivated = props.onBackActivated,
				tag = "radius-medium auto-xy padding-medium bg-action-subtle"
			},
			{
				BackIcon = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					name = "icons/navigation/pushBack",
					Position = UDim2.fromScale(0.5, 0.5),
					style = v5.Color.ActionEmphasis.Foreground,
					ZIndex = 2
				}),
				BackIconShadow = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					name = "icons/navigation/pushBack",
					Position = UDim2.fromScale(0.5, 0.5) + udim,
					style = v5.Color.Common.Shadow,
					ZIndex = 1
				})
			}
		),
		MoreButton = 0
	}

	local v9 = if not props.isPlaceholderPost then React.createElement(
		view,
		{
			onActivated = props.onMoreActivated,
			tag = "radius-medium auto-xy padding-medium bg-action-subtle"
		},
		{
			MoreIcon = React.createElement(icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = props.isContextualMenuOpen and "icons/menu/more_on" or "icons/menu/more_off",
				Position = UDim2.fromScale(0.5, 0.5),
				style = v5.Color.ActionEmphasis.Foreground,
				ZIndex = 2
			}),
			MoreIconShadow = React.createElement(icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = props.isContextualMenuOpen and "icons/menu/more_on" or "icons/menu/more_off",
				Position = UDim2.fromScale(0.5, 0.5) + udim,
				style = v5.Color.Common.Shadow,
				ZIndex = 1
			})
		}
	) else nil
	v8.MoreButton = v9
	return createElement(view, v7, v8)
end
