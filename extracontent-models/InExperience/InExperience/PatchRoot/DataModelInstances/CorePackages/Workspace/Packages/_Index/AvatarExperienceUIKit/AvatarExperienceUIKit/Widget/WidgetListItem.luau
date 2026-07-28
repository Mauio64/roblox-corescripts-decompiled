local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local RoactGamepad = require(Parent.RoactGamepad)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 28
	-- upvalues: useDesignTokens (copy), React (copy), RoactGamepad (copy)
	local v7 = t1.horizontalMargin or 0
	local v8 = useDesignTokens()

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionLeft = t1.NextSelectionLeft,
		onFocusGained = t1.onFocusGained
	}, {
		GradientBackground = if not t1.hasBackground then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = -1,
			Size = UDim2.new(1, v7 * 2, 1, 0),
			Position = UDim2.new(0, -v7, 0, 0),
			BackgroundColor3 = Color3.new(1, 1, 1)
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v8.Color.Surface.Surface_200.Color3),
					ColorSequenceKeypoint.new(1, v8.Color.Surface.Surface_0.Color3)
				})
			})
		}),
		WidgetListItemPadding = if not t1.padding then nil else React.createElement("UIPadding", {
			PaddingBottom = t1.padding.bottom,
			PaddingTop = t1.padding.top,
			PaddingRight = t1.padding.right,
			PaddingLeft = t1.padding.left
		}),
		Widget = React.createElement(React.Fragment, nil, t1.children)
	})
end))
