local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens
local RoactGamepad = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/RoactGamepad")

return (React.forwardRef(function(props, p2)
	local horizontalMargin = props.horizontalMargin or 0
	local v5 = useDesignTokens()

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v6 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionLeft = props.NextSelectionLeft,
		onFocusGained = props.onFocusGained
	}

	local v8 = if props.hasBackground then React.createElement("Frame", {
		Size = UDim2.new(1, horizontalMargin * 2, 1, 0),
		Position = UDim2.new(0, -horizontalMargin, 0, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		ZIndex = -1
	}, {
		Gradient = React.createElement("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, v5.Color.Surface.Surface_200.Color3),
				ColorSequenceKeypoint.new(1, v5.Color.Surface.Surface_0.Color3)
			})
		})
	}) else nil

	local v9 = if props.padding then React.createElement("UIPadding", {
		PaddingBottom = props.padding.bottom,
		PaddingTop = props.padding.top,
		PaddingRight = props.padding.right,
		PaddingLeft = props.padding.left
	}) else nil
	return createElement(frame, v6, {
		GradientBackground = v8,
		WidgetListItemPadding = v9,
		Widget = React.createElement(React.Fragment, nil, props.children)
	})
end))
