local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local RoactGamepad = require(parent.RoactGamepad)

return (React.forwardRef(function(props, ref)
	local horizontalMargin = props.horizontalMargin or 0
	local v = useDesignTokens()

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v2 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = ref,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionLeft = props.NextSelectionLeft,
		onFocusGained = props.onFocusGained
	}
	local gradientBackground

	if props.hasBackground then
		gradientBackground = React.createElement("Frame", {
			Size = UDim2.new(1, horizontalMargin * 2, 1, 0),
			Position = UDim2.new(0, -horizontalMargin, 0, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			ZIndex = -1
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v.Color.Surface.Surface_200.Color3),
					ColorSequenceKeypoint.new(1, v.Color.Surface.Surface_0.Color3)
				})
			})
		})
	end

	local widgetListItemPadding

	if props.padding then
		widgetListItemPadding = React.createElement("UIPadding", {
			PaddingBottom = props.padding.bottom,
			PaddingTop = props.padding.top,
			PaddingRight = props.padding.right,
			PaddingLeft = props.padding.left
		})
	end

	return createElement(frame, v2, {
		GradientBackground = gradientBackground,
		WidgetListItemPadding = widgetListItemPadding,
		Widget = React.createElement(React.Fragment, nil, props.children)
	})
end))
