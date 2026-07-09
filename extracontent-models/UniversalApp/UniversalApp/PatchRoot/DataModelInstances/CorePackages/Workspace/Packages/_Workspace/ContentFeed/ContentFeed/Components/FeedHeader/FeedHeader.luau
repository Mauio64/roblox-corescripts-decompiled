local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local uDim2 = UDim2.fromOffset(1, 1)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), uDim2 (copy)
	local v9 = useTokens()

	return React.createElement(View, {
		tag = "size-full-0 bg-action-subtle auto-y padding-x-large padding-y-small row flex-between",
		ZIndex = t1.ZIndex
	}, {
		BackButton = React.createElement(View, {
			tag = "radius-medium auto-xy padding-medium bg-action-subtle",
			onActivated = t1.onBackActivated
		}, {
			BackIcon = React.createElement(Icon, {
				name = "icons/navigation/pushBack",
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				style = v9.Color.ActionEmphasis.Foreground
			}),
			BackIconShadow = React.createElement(Icon, {
				name = "icons/navigation/pushBack",
				ZIndex = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5) + uDim2,
				style = v9.Color.Common.Shadow
			})
		}),
		MoreButton = if t1.isPlaceholderPost then nil else React.createElement(View, {
			tag = "radius-medium auto-xy padding-medium bg-action-subtle",
			onActivated = t1.onMoreActivated
		}, {
			MoreIcon = React.createElement(Icon, {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = not t1.isContextualMenuOpen and "icons/menu/more_off" or "icons/menu/more_on",
				Position = UDim2.fromScale(0.5, 0.5),
				style = v9.Color.ActionEmphasis.Foreground
			}),
			MoreIconShadow = React.createElement(Icon, {
				ZIndex = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = not t1.isContextualMenuOpen and "icons/menu/more_off" or "icons/menu/more_on",
				Position = UDim2.fromScale(0.5, 0.5) + uDim2,
				style = v9.Color.Common.Shadow
			})
		})
	})
end
