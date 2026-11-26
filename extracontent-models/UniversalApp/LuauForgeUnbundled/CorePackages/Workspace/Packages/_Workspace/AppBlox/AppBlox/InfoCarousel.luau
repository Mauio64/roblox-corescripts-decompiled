local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style").useDesignTokens
local InfoCarouselCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/InfoCarouselCell")

return function(props)
	local v5 = useDesignTokens()
	local padding = props.padding or v5.Size.Size_600

	local v6, v7 = React.useBinding(0)

	local children = {}

	local function fn(p2)
		v7(p2.AbsoluteSize.Y)
	end

	for k, v8 in props.data do
		children["Cell" .. k] = React.createElement(InfoCarouselCell, {
			LayoutOrder = k * 2,
			headerText = v8.headerText,
			bodyText = v8.bodyText,
			icon = v8.icon,
			iconSize = props.iconSize,
			onActivated = v8.onActivated,
			padding = props.cellPadding
		})

		if k < #props.data then
			children["Divider" .. k] = React.createElement("Frame", {
				LayoutOrder = k * 2 + 1,
				Size = v6:map(function(p2)
					return UDim2.fromOffset(1, p2 / 2)
				end),
				BorderColor3 = v5.Color.Stroke.Emphasis.Color3,
				BackgroundTransparency = v5.Color.Stroke.Emphasis.Transparency,
				BorderSizePixel = 0
			})
		end
	end

	return React.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		[React.Change.AbsoluteSize] = fn
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, padding)
		}),
		Cells = React.createElement(React.Fragment, {}, children)
	})
end
